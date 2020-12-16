import sys
import numpy as np
from astropy.io import fits
from astropy.wcs import WCS
from numpy.polynomial import Chebyshev as T
import itertools

try:
    DATADIR = sys.argv[1]
    SUFFIX = sys.argv[2]
    OUTDIR = sys.argv[3]
except IndexError:
    sys.exit(f"Usage: {sys.argv[0]} DATADIR SUFFIX OUTDIR")

infile = f"muse-hr-data-wavsec23{SUFFIX}.fits"
hdu = fits.open(f"{DATADIR}/{infile}")["DATA"]
w = WCS(hdu)
nwav, ny, nx = hdu.data.shape
wavpix = np.arange(nwav)

# Two pairs of adjacent sections for the true continuum

# Wavelength sections of clean continuum
clean_sections = [
    [6070.0, 6140.0], [6170.0, 6225.0], # to the blue
    [6760.0, 6790.0], [6790.0, 6820.0], # to the red
]

cont_slices = []
for wavs in clean_sections:
    wavs = 1e-10*np.array(wavs)
    _, _, wpix = w.world_to_pixel_values([0, 0], [0, 0], wavs)
    cont_slices.append(slice(*wpix.astype(int)))


# Use median over each section to avoid weak lines
cont_maps = np.array([np.median(hdu.data[_, :, :], axis=0) for _ in cont_slices])
cont_wavpix = np.array([np.median(wavpix[_], axis=0) for _ in cont_slices])
# Inefficient but simple algorithm - loop over spaxels
bgdata = np.empty_like(hdu.data)
for j, i in itertools.product(range(ny), range(nx)):
    # Fit polynomial to BG
    try:
        p = T.fit(cont_wavpix, cont_maps[:, j, i], deg=2)
        # and fill in the BG spectrum of this spaxel
        bgdata[:, j, i] = p(wavpix)
    except:
        bgdata[:, j, i] = np.nan



for suffix, cube in [
        ["cont", bgdata],
        ["cont-sub", hdu.data - bgdata],
        ["cont-div", hdu.data/bgdata],
]:
    outfile = infile.replace(".fits", f"-{suffix}.fits")
    fits.PrimaryHDU(header=hdu.header, data=cube).writeto(
        f"{OUTDIR}/{outfile}", overwrite=True)
    print(f"Written {outfile}")
