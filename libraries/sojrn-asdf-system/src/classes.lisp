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
;;; Package-Inferred-System Variants
;;;
;;; Each mixes the class above with `ASDF:PACKAGE-INFERRED-SYSTEM' via
;;; CLOS multiple inheritance thus letting a project pick plain or
;;; PIS behavior by `:CLASS' by class name alone.

(defclass sojrn-package-inferred-system
    (sojrn-asdf-system-extension asdf:package-inferred-system)
  ()
  (:documentation "PIS variant of SOJRN-ASDF-SYSTEM-EXTENSION."))

(defclass sojrn-exec-package-inferred-system
    (sojrn-exec-system asdf:package-inferred-system)
  ()
  (:documentation "PIS variant of SOJRN-EXEC-SYSTEM."))

(defclass sojrn-doc-package-inferred-system
    (sojrn-doc-system asdf:package-inferred-system)
  ()
  (:documentation "PIS variant of SOJRN-DOC-SYSTEM."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Export to ASDF
;;;
;;; Allow for naked :class "sojrn-package-inferred-system" / "sojrn-exec-system"
;;; in .asd definitions (mirrors CFFI-Grovel's :cffi-wrapper-file pattern).

(setf (find-class 'asdf::sojrn-asdf-system-extension)
      (find-class 'sojrn-asdf-system-extension))

(setf (find-class 'asdf::sojrn-exec-system)
      (find-class 'sojrn-exec-system))

(setf (find-class 'asdf::sojrn-doc-system)
      (find-class 'sojrn-doc-system))

(setf (find-class 'asdf::sojrn-package-inferred-system)
      (find-class 'sojrn-package-inferred-system))

(setf (find-class 'asdf::sojrn-exec-package-inferred-system)
      (find-class 'sojrn-exec-package-inferred-system))

(setf (find-class 'asdf::sojrn-doc-package-inferred-system)
      (find-class 'sojrn-doc-package-inferred-system))
