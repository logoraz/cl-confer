(defsystem "sojrn-asdf-system"
  :description "ASDF System Extension for sojrn"
  :author "Erik P Almaraz"
  :license "AGPL-3.0-only"
  :version (:read-file-form "version.sexp" :at (0 1))
  :depends-on ("asdf" "cffi")
  :components
  ((:module "src"
    :components
    ((:file "package")
     (:file "classes" :depends-on ("package"))
     (:file "cffi-path" :depends-on ("classes"))
     (:file "exec-hooks" :depends-on ("cffi-path")))))
  :long-description "ASDF System Extension for sojrn.")
