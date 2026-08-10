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
;;; Defaults: Configuration Setup

(defvar *user-sojrn-directory*
  (merge-pathnames #P"sojrn/" (uiop:xdg-config-home)))

(defparameter *config-mgr* (make-instance 'config-manager))

(defparameter *config-spec* nil
  "Default config spec, pulls from the sorjn files directory.")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; User config scaffolding
;;;

(defun user-config-exists? ()
  "Check whether user-config directory and files exists"
  (probe-file (merge-pathnames "config.lisp" *user-sojrn-directory*)))

(if (user-config-exists?)
    (load (merge-pathnames "config.lisp"
                           *user-sojrn-directory*))
    (let ((sojrn-dir (merge-pathnames #P"files/"
                                      (asdf:system-source-directory :sojrn))))
      (ensure-directories-exist *user-sojrn-directory*)
      (setf *config-spec*
            `(("SBCL Config"
               ,(uiop:native-namestring sojrn-dir) "~/.sbclrc"
               :spec :symlink :type :file)))
      (add-configs *config-mgr* *config-spec*)))
