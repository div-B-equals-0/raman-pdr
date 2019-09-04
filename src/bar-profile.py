import json
import sys
import numpy as np
from astropy.io import fits
from astropy.wcs import WCS
from astropy.coordinates import SkyCoord
import astropy.units as u
from matplotlib import pyplot as plt
import seaborn as sns
import statsmodels.api as sm

try:
    INFILE, DATAPATH = sys.argv[1], sys.argv[2]
    HDU, NBLOCK, NORM = sys.argv[3], int(sys.argv[4]), sys.argv[5]
except:
    sys.exit(f"Usage: {sys.argv[0]} INFILE DATAPATH HDU NBLOCK NORM (not {sys.argv[1:]})")

try:
    HDU = int(HDU)
except:
    pass

# Origin of Bar offset frame
c0 = SkyCoord(83.8418691, -5.4113246, unit=(u.deg, u.deg))
# Position angle perp to Bar (away from Trapezium)
PA = 141.5*u.deg
bar_frame = c0.skyoffset_frame(rotation=PA)

hdu = fits.open(f"{DATAPATH}/{INFILE}")[HDU]
w = WCS(hdu).celestial

# Make sure we have 2d image, not 3d cube
if len(hdu.data.shape) == 3:
    hdu.data = hdu.data[0, :, :]

# Find coordinates of all pixels in image
ny, nx = hdu.data.shape
xpix, ypix = np.meshgrid(np.arange(nx), np.arange(ny))
c = w.pixel_to_world(xpix, ypix)

# Transform to the Bar offset frame (lon is along bar, lat is perpendicular)
cb = c.transform_to(bar_frame)

# Take a 75 arcsec section of bar
mask = np.abs(cb.lon) < (75.0/2.0)*u.arcsec
# And +/- 1 arcmin in perp direction
mask = mask & (np.abs(cb.lat) < 1.0*u.arcmin)

# offset in arcseconds perp to bar
x = cb[mask].lat.to(u.arcsec).value
# and parallel
y = cb[mask].lon.to(u.arcsec).value
# brightness
s = hdu.data[mask]

# Sort them all by x
indices = np.argsort(x)
x = x[indices]
y = y[indices]
s = s[indices]

# scale by median by default
if "median" in NORM.lower():
    s /= np.nanmedian(s)

# Calculate blockwise medians
nblock = NBLOCK
# Discard any extra points off the end
n = nblock*(len(x) // nblock)
xm = np.nanmedian(x[:n].reshape((-1, nblock)), axis=-1)
sm = np.nanmedian(s[:n].reshape((-1, nblock)), axis=-1)

jsonfile = INFILE.replace(".fits", "-bar-profile.json")
with open(jsonfile, "w") as f:
    json.dump(
        {"offset": list(xm.astype(float)), "brightness": list(sm.astype(float))},
        f, indent=3)

# Plot s(x)
figfile = INFILE.replace(".fits", "-bar-profile.jpg")
fig, ax = plt.subplots()
ax.scatter(x, s, s=3.0, c=y,
           alpha=0.3, marker=".", edgecolors="none", cmap="cool",
)
ax.plot(xm, sm, '-', color="k")
ax.set(
    xlabel="Offset, arcsec",
    yscale="linear",
    ylim=[0.0, 2.0*np.nanmax(sm)],
)
ax.set_xscale("symlog", linthreshx=10, linscalex=0.5, subsx=[2, 3, 4, 5, 6, 7, 8, 9])
sns.despine()
fig.savefig(figfile, dpi=600)

print(figfile, end="")
