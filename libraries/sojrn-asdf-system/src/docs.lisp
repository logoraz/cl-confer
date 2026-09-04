(uiop:define-package :sojrn-asdf-system/docs
  (:use :cl :asdf :uiop)
  (:import-from :sojrn-asdf-system/classes
                #:sojrn-doc-system)
  (:export #:generate-api-md
           #:build-docs)
  (:documentation "Extension for documentation generation."))

(in-package :sojrn-asdf-system/docs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Documentation Generation

(defun project-packages (prefix)
  "Return all loaded packages whose name starts with PREFIX, excluding
this project's own -DOCS/-TESTS infrastructure packages."
  (let ((docs-name (concatenate 'string prefix "/DOCS"))
        (tests-name (concatenate 'string prefix "/TESTS")))
    (remove-if-not
     (lambda (pkg)
       (let ((name (package-name pkg)))
         (and (uiop:string-prefix-p prefix name)
              (not (member name (list docs-name tests-name) :test #'string=)))))
     (list-all-packages))))

(defun render-md-file (input output)
  "Render MD file from INPUT and write normalized Markdown to OUTPUT."
  (with-open-file (in input)
    (with-open-file (out output
                         :direction :output
                         :if-exists :supersede
                         :if-does-not-exist :create)
      (3bmd:parse-and-print-to-stream in out))))

(defun generate-api-md (output-file packages)
  "Generate an API reference in Markdown by extracting docstrings
from PACKAGES and writing them to OUTPUT-FILE."
  (with-open-file (out output-file
                       :direction :output
                       :if-exists :supersede
                       :if-does-not-exist :create)
    (format out "# API Reference~%~%")
    (dolist (pkg packages)
      (format out "## Package ~A~%~%" (package-name pkg))
      (do-external-symbols (sym pkg)
        (when (eq (symbol-package sym) pkg)
          (let ((fdoc (documentation sym 'function))
                (vdoc (documentation sym 'variable))
                (tdoc (documentation sym 'type))
                (cdoc (documentation sym 'class)))
            (when fdoc (format out "### `~A` (function)~%~A~%~%" sym fdoc))
            (when vdoc (format out "### `~A` (variable)~%~A~%~%" sym vdoc))
            (when tdoc (format out "### `~A` (type)~%~A~%~%" sym tdoc))
            (when cdoc (format out "### `~A` (class)~%~A~%~%" sym cdoc))))))))

(defun build-docs (system &key keep)
  "Documentation builder for SYSTEM, driven by its primary system name."
  (let* ((prefix  (string-upcase (asdf:primary-system-name system)))
         (root    (asdf:system-source-directory (asdf:primary-system-name system)))
         (manual  (merge-pathnames "docs/manual/" root))
         (outdir  (merge-pathnames "out/" manual))
         (sections '("intro.md" "usage.md" "api.md" "internals.md")))
    (ensure-directories-exist manual)
    (generate-api-md (merge-pathnames "api.md" manual) (project-packages prefix))
    (ensure-directories-exist outdir)
    (dolist (f sections)
      (render-md-file
       (merge-pathnames f manual)
       (merge-pathnames (concatenate 'string (pathname-name f) ".html") outdir)))
    (let ((combined (merge-pathnames "manual.html" outdir)))
      (with-open-file (out combined
                           :direction :output
                           :if-exists :supersede
                           :if-does-not-exist :create)
        (dolist (f sections)
          (with-open-file (in (merge-pathnames
                                (concatenate 'string (pathname-name f) ".html")
                                outdir))
            (loop :for line := (read-line in nil nil)
                  :while line :do (write-line line out)))
          (write-line "" out))))
    (unless keep
      (dolist (f sections)
        (let ((tmp (merge-pathnames (concatenate 'string (pathname-name f) ".html") outdir)))
          (when (probe-file tmp) (delete-file tmp)))))
    (format t "Documentation built successfully for ~A.~%" prefix)))

(defmethod perform ((o build-op) (c sojrn-doc-system))
  (build-docs c))
