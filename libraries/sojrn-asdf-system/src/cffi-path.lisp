(uiop:define-package :sojrn-asdf-system/cffi-path
  (:use :cl :asdf :uiop)
  (:export #+linux #:configure-guix-cffi-path
           #+windows #:configure-windows-cffi-path)
  (:documentation "cffi-path extensions."))

(in-package :sojrn-asdf-system/cffi-path)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; CFFI PATH Setup

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
