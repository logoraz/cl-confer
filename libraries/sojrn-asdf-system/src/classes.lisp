(uiop:define-package :sojrn-asdf-system/classes
  (:use :cl :asdf :uiop)
  (:export #:sojrn-asdf-system-extension
           #:sojrn-exec-system
           #:sojrn-doc-system)
  (:documentation "sojrn ASDF system extension classes."))

(in-package :sojrn-asdf-system/classes)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Custom System Classes

(defclass sojrn-asdf-system-extension (asdf:system) ()
  (:documentation "Base system class for Sojrn."))

(defclass sojrn-exec-system (asdf:system) ()
  (:documentation "System class for Sojrn executable build."))

(defclass sojrn-doc-system (asdf:system) ()
  (:documentation "System class for Sojrn documentation generation."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Export to ASDF

;; Allow for naked :class "sojrn-package-inferred-system" / "sojrn-exec-system"
;; in .asd definitions (mirrors CFFI-Grovel's :cffi-wrapper-file pattern).
(setf (find-class 'asdf::sojrn-asdf-system-extension)
      (find-class 'sojrn-asdf-system-extension))

(setf (find-class 'asdf::sojrn-exec-system)
      (find-class 'sojrn-exec-system))

(setf (find-class 'asdf::sojrn-doc-system)
      (find-class 'sojrn-doc-system))
