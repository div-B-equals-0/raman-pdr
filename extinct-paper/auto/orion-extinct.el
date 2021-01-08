(TeX-add-style-hook
 "orion-extinct"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("aastex63" "twocolumn" "times")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("babel" "spanish" "es-minimal" "english") ("inputenc" "utf8") ("newtxmath" "varg")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
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
    "fig:3color-extinction"
    "sec:orion-s-region"
    "sec:other-meas-extinct"
    "sec:diff-interst-bands"
    "sec:forb-metal-doubl"
    "sec:continuum-colors")
   (LaTeX-add-bibliographies
    "BibdeskLibrary")
   (LaTeX-add-counters
    "ionstage")
   (LaTeX-add-array-newcolumntypes
    "L"
    "R"
    "C"))
 :latex)

