import sys
import numpy as np
from astropy.io import fits
from astropy.wcs import WCS

try:
    INDIR = sys.argv[1]
    REBIN = sys.argv[2]
    OUTDIR = sys.argv[3]
except IndexError:
    sys.exit(f"Usage: {sys.argv[0]} INDIR REBIN OUTDIR")

infile = f"muse-hr-data-wavsec23{REBIN}-cont-sub.fits"
hdu = fits.open(f"{INDIR}/{infile}")["DATA"]

bands = {
    "R007": [6568.7, 6571.25],
    "R011": [6572.1, 6574.65],
    "R040": [6594.2, 6611.2],
    "R058": [6612.05, 6628.2],
    "R087": [6638.4, 6660.5],
    "R136": [6688.55, 6708.95],
    "B006": [6555.95, 6557.65],
    "B009": [6552.55, 6555.1],
    "B033": [6518.55, 6540.65],
    "B054": [6499.85, 6517.7],
    "B080": [6469.25, 6496.45],
    "B133": [6414.85, 6445.45],
}

wcs = WCS(hdu.header)
imhdr = wcs.celestial.to_header()

nwav, ny, nx = hdu.data.shape
wavpix = np.arange(nwav)

for band, waves in bands.items():
    waves = np.array(waves)/1e10
    [i1, i2], _, _ = wcs.world_to_array_index_values([0, 0], [0, 0], waves)
    image = hdu.data[i1:i2+1, :, :].mean(axis=0)
    outfile = infile.replace("wavsec23", f"ha-raman-{band}")
    fits.PrimaryHDU(data=image, header=imhdr).writeto(
        f"{OUTDIR}/{outfile}", overwrite=True)
