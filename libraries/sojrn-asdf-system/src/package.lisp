(uiop:define-package :sojrn-asdf-system
  (:use :cl :asdf :uiop)
  (:export #:sojrn-package-inferred-system
           #:sojrn-exec-system)
  (:documentation "sojrn ASDF system extension."))
