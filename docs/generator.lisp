(uiop:define-package :sojrn-docs/generator
  (:nicknames #:docs)
  (:use :cl
        :sojrn)
  (:import-from #:3bmd)
  (:import-from #:3bmd-code-blocks)
  (:import-from #:colorize)
  (:import-from #:print-licenses)
  (:export #:build-docs)
  (:documentation "Documentation system for sojrn"))

(in-package :sojrn-docs/generator)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; References
;;;

(defun sojrn-packages ()
  "Return all loaded SOJRN packages, excluding docs/tests infrastructure."
  (remove-if-not
   (lambda (pkg)
     (let ((name (package-name pkg)))
       (and (uiop:string-prefix-p "SOJRN" name)
            (not (member name '("SOJRN-DOCS" "SOJRN-TESTS")
                         :test #'string=)))))
   (list-all-packages)))

(defun render-md-file (input output)
  "Render MD file from INPUT and write normalized Markdown to OUTPUT."
  (with-open-file (in input)
    (with-open-file (out output
                         :direction :output
                         :if-exists :supersede
                         :if-does-not-exist :create)
      (3bmd:parse-and-print-to-stream in out))))

(defun generate-api-md (output-file &key (packages (sojrn-packages)))
  "Generate an API reference in Markdown by extracting docstrings
from the given PACKAGES and writing them to OUTPUT-FILE."
  (with-open-file (out output-file
                       :direction :output
                       :if-exists :supersede
                       :if-does-not-exist :create)
    (format out "# API Reference~%~%")
    (dolist (pkg packages)
      (let ((package (find-package pkg)))
        (when package
          (format out "## Package ~A~%~%" (package-name package))
          (do-external-symbols (sym package)
            (when (eq (symbol-package sym) package)
              (let ((fdoc (documentation sym 'function))
                    (vdoc (documentation sym 'variable))
                    (tdoc (documentation sym 'type))
                    (cdoc (documentation sym 'class)))
                (when fdoc
                  (format out "### `~A` (function)~%~A~%~%"
                          sym fdoc))
                (when vdoc
                  (format out "### `~A` (variable)~%~A~%~%"
                          sym vdoc))
                (when tdoc
                  (format out "### `~A` (type)~%~A~%~%"
                          sym tdoc))
                (when cdoc
                  (format out "### `~A` (class)~%~A~%~%"
                          sym cdoc))))))))))

(defun build-docs (&key keep)
  "Documentation builder for sojrn."
  (let* ((root   (asdf:system-source-directory :sojrn-docs))
         (manual (merge-pathnames "docs/manual/" root))
         (outdir (merge-pathnames "out/" manual))
         (sections '("intro.md" "usage.md" "api.md" "internals.md")))
    (ensure-directories-exist manual)
    (generate-api-md (merge-pathnames "api.md" manual)
                     :packages (sojrn-packages))
    (ensure-directories-exist outdir)
    (dolist (f sections)
      (render-md-file
       (merge-pathnames f manual)
       (merge-pathnames
        (concatenate 'string (pathname-name f) ".html")
        outdir)))
    (let ((combined (merge-pathnames "manual.html" outdir)))
      (with-open-file (out combined
                           :direction :output
                           :if-exists :supersede
                           :if-does-not-exist :create)
        (dolist (f sections)
          (with-open-file
              (in (merge-pathnames
                   (concatenate 'string (pathname-name f) ".html")
                   outdir))
            (loop for line = (read-line in nil nil)
                  while line do (write-line line out)))
          (write-line "" out))))
    (unless keep
      (dolist (f sections)
        (let ((tmp (merge-pathnames
                    (concatenate 'string (pathname-name f) ".html")
                    outdir)))
          (when (probe-file tmp) (delete-file tmp)))))
    (format t "Documentation built successfully.~%")))
