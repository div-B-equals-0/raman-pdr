import sys
import numpy as np
from astropy.io import fits

try:
    DATADIR = sys.argv[1]
    SUFFIX = sys.argv[2]
    OUTDIR = sys.argv[3]
except IndexError:
    sys.exit(f"Usage: {sys.argv[0]} DATADIR SUFFIX OUTDIR")


hdu2 = fits.open(f"{DATADIR}/muse-hr-data-wavsec2{SUFFIX}.fits")["DATA"]
hdu3 = fits.open(f"{DATADIR}/muse-hr-data-wavsec3{SUFFIX}.fits")["DATA"]

hdu2.data = np.concatenate([hdu2.data, hdu3.data], axis=0)

hdu2.writeto(f"{OUTDIR}/muse-hr-data-wavsec23{SUFFIX}.fits")
