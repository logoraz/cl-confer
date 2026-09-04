(defsystem "sojrn-asdf-system"
  :description "sojrn ASDF System Extension."
  :author "Erik P Almaraz"
  :license "AGPL-3.0-only"
  :version (:read-file-form "version.sexp" :at (0 1))
  :depends-on ("asdf"
               "cffi"
               "3bmd"
               "3bmd-ext-code-blocks"
               "colorize"
               "print-licenses")
  :components
  ((:module "src"
    :components
    ((:file "classes")
     (:file "cffi-path"  :depends-on ("classes"))
     (:file "exec-hooks" :depends-on ("cffi-path"))
     (:file "docs"       :depends-on ("classes")))))
  :long-description "sojrn ASDF System Extension")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Subsystems
