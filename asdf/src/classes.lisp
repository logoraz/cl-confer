(in-package :sojrn-asdf-system)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Custom System Classes

(defclass sojrn-package-inferred-system (asdf:package-inferred-system) ()
  (:documentation "Base system class for Sojrn."))

(defclass sojrn-exec-system (asdf:package-inferred-system) ()
  (:documentation "System class for Sojrn executable build."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Export to ASDF

;; Allow for naked :class "sojrn-package-inferred-system" / "sojrn-exec-system"
;; in .asd definitions (mirrors CFFI-Grovel's :cffi-wrapper-file pattern).
(setf (find-class 'asdf::sojrn-package-inferred-system)
      (find-class 'sojrn-package-inferred-system))
(setf (find-class 'asdf::sojrn-exec-system)
      (find-class 'sojrn-exec-system))
