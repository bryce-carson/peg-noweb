(defvar tool (peg-noweb-parse-files "~/src/peg-noweb/src/peg-noweb.nw" "~/src/whyse/src/whyse.nw"))
(defvar no-weave "/home/bryce/src/noweb/src/shell/noweave.nw")
(defvar no-weave-parsed (peg-noweb-parse-files no-weave))
(defvar document (peg-noweb-document 0 no-weave-parsed))
(defvar markup
  (progn (call-process "/usr/local/noweb/lib/markup" nil
                       (setq no-weave-buffer (create-file-buffer no-weave))
                       nil no-weave)
         (with-current-buffer no-weave-buffer
           (buffer-string))))

(with-current-buffer (get-buffer-create "deparse-buffer")
  (insert (peg-noweb-document-deparse document)))
(ediff-buffers no-weave-buffer (get-buffer-create "deparse-buffer"))
