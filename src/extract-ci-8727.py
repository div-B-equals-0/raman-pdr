import sys
import numpy as np
from astropy.io import fits

try:
    DATADIR = sys.argv[1]
    SUFFIX = sys.argv[2]
    OUTDIR = sys.argv[3]
except IndexError:
    sys.exit(f"Usage: {sys.argv[0]} DATADIR SUFFIX OUTDIR")

infile = f"muse-hr-data-wavsec6{SUFFIX}-cont-sub.fits"
hdu = fits.open(f"{DATADIR}/{infile}")["DATA"]

line = np.nanmean(hdu.data[648:652, :, :], axis=0)
hdu.data = line

outfile = f"linesum-blue-C_I-8727{SUFFIX}.fits"
hdu.writeto(f"{OUTDIR}/{outfile}", overwrite=True)

print(f"Written {outfile}")
