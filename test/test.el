(defvar tool (peg-noweb-parse-files "~/src/peg-noweb/src/peg-noweb.nw" "~/src/whyse/src/whyse.nw"))
;; (length tool); number of files
;; (cl-first (cl-first tool)); (caar tool); first file name.
;; (cl-first (cl-second tool)); (caadr tool); second file name.
