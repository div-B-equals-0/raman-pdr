import sys
from astropy.io import fits
import numpy as np
sys.path.append('/Users/will/Work/RubinWFC3/Tsquared')
from rebin_utils import oversample
from skimage.morphology import square
from skimage.filters.rank import modal


def minify(a, n):
    return a[::n, ::n]


ELEMENT = square(5)
def cleanup_mask(mask, n):
    """Eliminate small islands in the mask"""
    m = minify(mask, n).astype(np.uint8)
    m = m & modal(m, ELEMENT)
    return oversample(m, n).astype(bool)


try: 
    prefix, minw_scale = sys.argv[1], float(sys.argv[2])
except:
    print('Usage:', sys.argv[0], 'FITSFILE_PREFIX MINIMUM_WEIGHT [COARSE_WEIGHT]')
    sys.exit()

try:
    minw_coarse = float(sys.argv[3])
except IndexError:
    minw_coarse = None

nlist = [1, 2, 4, 8, 16, 32, 64]
minweights = [2.0, 2.0, 2.0, 4.0, 8.0, 8.0, 8.0]
if minw_coarse is not None:
    minweights[-1] = minw_coarse
outim = np.zeros((1536, 1792))
for n, minw in reversed(list(zip(nlist, minweights))):
    fn = '{}-bin{:03d}.fits'.format(prefix, n)
    hdulist = fits.open(fn)
    im = hdulist['scaled'].data
    hdr = hdulist['scaled'].header
    w = hdulist['weight'].data
    m = cleanup_mask(w*im >= minw*minw_scale, n)
    m = m & np.isfinite(w) & (w > 0.0) & np.isfinite(im) & (im > 0.0)
    outim[m] = im[m]
fits.PrimaryHDU(header=hdr, data=outim).writeto(
    f"{prefix}-multibin-{int(minw_scale)}.fits", overwrite=True)
