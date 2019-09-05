import sys
import numpy as np
from astropy.io import fits

try:
    DATADIR = sys.argv[1]
    SUFFIX = sys.argv[2]
    OUTDIR = sys.argv[3]
except IndexError:
    sys.exit(f"Usage: {sys.argv[0]} DATADIR SUFFIX OUTDIR")

infile = f"muse-hr-data-wavsec6{SUFFIX}.fits"
hdu = fits.open(f"{DATADIR}/{infile}")["DATA"]

# wave indices for estimating continuum
kcont = [605, 617, 645, 669]

cont = np.nanmean(hdu.data[kcont, :, :], axis=0, keepdims=True)
hdu.data -= cont

outfile = infile.replace(".fits", "-cont-sub.fits")
hdu.writeto(f"{OUTDIR}/{outfile}", overwrite=True)

print(f"Written {outfile}")
