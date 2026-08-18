(defsystem "sojrn"
  :description "Declarative dotfile/config deployment for Common Lisp."
  :author "Erik P Almaraz <erikalmaraz@fastmail.com>"
  :license "Apache-2.0"
  :version (:read-file-form "version.sexp" :at (0 1))
  :defsystem-depends-on ("sojrn-asdf-system")
  :class :sojrn-package-inferred-system
  :pathname "src"
  :depends-on ("sojrn/sojrn")
  :in-order-to ((test-op (test-op "sojrn-tests")))
  :long-description "
Declarative dotfile/config deployment for Common Lisp, with persisted state
tracking.
")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Register Systems

(register-system-packages "bordeaux-threads"   '(:bt :bt2))
(register-system-packages "cl-dbi"             '(:dbi))
(register-system-packages "cl-cffi-gtk4"       '(:gtk :gdk))
;; cl-cffi-gtk4 dependencies
(register-system-packages "cl-cffi-glib"       '(:gobject :glib :gio))
(register-system-packages "cl-cffi-gdk-pixbuf" '(:gdk-pixbuf))
(register-system-packages "cl-cffi-graphene"   '(:graphene))
(register-system-packages "cl-cffi-pango"      '(:pango))
(register-system-packages "cl-cffi-cairo"      '(:cairo))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Subsystems

(defsystem "sojrn/libraries"
  :description "Extra libraries to bring in if needed"
  :depends-on ("learn-cl"))

(defsystem "sojrn/docs"
  :class :sojrn-doc-system
  :depends-on ("sojrn"))

(defsystem "sojrn/executable"
  :description "Build executable"
  :class :sojrn-exec-system
  :depends-on ("sojrn")
  :build-operation "program-op"
  :build-pathname "dist/sojrn"
  :entry-point "sojrn:main")
