(TeX-add-style-hook
 "orion-extinct"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("aastex63" "twocolumn" "times")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("babel" "spanish" "es-minimal" "english") ("inputenc" "utf8") ("newtxmath" "varg")))
   (TeX-run-style-hooks
    "latex2e"
    "amsmath"
    "aastex63"
    "aastex6310"
    "babel"
    "inputenc"
    "natbib"
    "hyperref"
    "savesym"
    "siunitx"
    "newtxmath"
    "newtxtext"
    "booktabs"
    "array")
   (TeX-add-symbols
    '("Level" 4)
    '("Term" 3)
    '("Config" 1)
    '("chem" 1)
    '("ION" 2)
    "hii"
    "Raman"
    "wn"
    "ha"
    "lya"
    "lyb"
    "th")
   (LaTeX-add-labels
    "sec:introduction"
    "fig:3color-extinction")
   (LaTeX-add-bibliographies
    "BibdeskLibrary")
   (LaTeX-add-counters
    "ionstage"))
 :latex)

