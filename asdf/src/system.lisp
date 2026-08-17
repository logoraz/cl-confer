(uiop:define-package :sojrn-asdf-system/system
  (:use :cl :asdf :uiop)
  (:export #:sojrn-package-inferred-system
           #:sojrn-exec-system)
  (:documentation "ASDF extension system for sojrn."))

(in-package :sojrn-asdf-system/system)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Custom System Classes

(defclass sojrn-package-inferred-system (asdf:package-inferred-system) ()
  (:documentation "Base system class for Sojrn."))

(defclass sojrn-exec-system (asdf:package-inferred-system) ()
  (:documentation "System class for Sojrn executable build."))

;; Allow for naked :class "sojrn-package-inferred-system" / "sojrn-exec-system"
;; in .asd definitions (mirrors CFFI-Grovel's :cffi-wrapper-file pattern).
(setf (find-class 'asdf::sojrn-package-inferred-system)
      (find-class 'sojrn-package-inferred-system))
(setf (find-class 'asdf::sojrn-exec-system)
      (find-class 'sojrn-exec-system))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; CFFI PATH Setup
;;;

#+linux
(defun configure-guix-cffi-path ()
  (let ((guix-env (uiop:getenv "GUIX_ENVIRONMENT")))
    (when guix-env
      (let ((lib-dir (merge-pathnames "lib/" (uiop:ensure-directory-pathname
                                              guix-env))))
        (setf (uiop:getenv "LD_LIBRARY_PATH")
              (concatenate 'string (namestring lib-dir) ":"
                           (or (uiop:getenv "LD_LIBRARY_PATH") "")))
        (pushnew lib-dir cffi:*foreign-library-directories* :test #'equal)))))

#+windows
(defun configure-windows-cffi-path ()
  (let ((lib-dir (merge-pathnames "Programs/msys64/ucrt64/bin"
                                  (uiop:xdg-data-home))))
    (setf (uiop:getenv "PATH")
          (concatenate 'string (namestring lib-dir) ";" (uiop:getenv "PATH")))
    (pushnew lib-dir cffi:*foreign-library-directories* :test #'equal)))


;;; Configure CFFI path for System build/load
#+linux (configure-guix-cffi-path)
#+windows (configure-windows-cffi-path)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Configure Executable runtime PATH
;;;

#+linux
(defmethod perform ((o load-op) (c sojrn-exec-system))
  (uiop:register-image-restore-hook #'configure-guix-cffi-path nil))

#+windows
(defmethod perform ((o load-op) (c sojrn-exec-system))
  (uiop:register-image-restore-hook #'configure-windows-cffi-path nil))

;;; Close foreign libraries before saving image (avoids double-loading on restart)
(defmethod perform :before ((o program-op) (c sojrn-exec-system))
  (loop :for lib :in (cffi:list-foreign-libraries :loaded-only t)
        :do (cffi:close-foreign-library lib)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Enable SBCL core compression for executables
;;;

#+sb-core-compression
(defmethod perform ((o image-op) (c sojrn-exec-system))
  (uiop:dump-image (output-file o c) :executable t :compression t))
