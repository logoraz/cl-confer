(defpackage :sojrn/user-config
  (:use :cl
        :sojrn/core/config-manager
        :sojrn/deployment)
  (:export #:*config-mgr*
           #:*config-spec*)
  (:documentation "Default configuration manager and config spec."))

(in-package :sojrn/user-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Current Configuration Setup

(defparameter *config-mgr* (make-instance 'config-manager))

(defparameter *config-spec*
  '(("SBCL Config"
     "~/Work/sojrn/files/common-lisp/dot-sbclrc.lisp" "~/.sbclrc"
     :spec :symlink :type :file)))

(add-configs *config-mgr* *config-spec*)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Install/Configure Common Lisp Utilities (i.e. ocicl, ccl, etc)
;;;
;; TODO: Enable `config-manager` to install/setup Common Lisp utilities like
;; ocicl...

#+(or)
(progn
  sbcl --eval "(defconstant +dynamic-space-size+ 2048)" --load setup.lisp)
