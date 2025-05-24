;;;; Common Lisp Environment Setup

(defpackage #:confer/setup
  (:nicknames #:setup)
  (:use #:cl)
  (:import-from #:uiop)
  (:import-from #:sb-posix)
  (:export #:symlinkp))
(in-package #:confer/setup)

#+(or)
(eval-when (:compile-toplevel :load-toplevel :execute)
  ;;body...
  ;;use ocicl to load external libraries if needed
  )


;;#+sbcl
#+(or)
(progn
  (in-package "SB-IMPL")
  (sb-ext:without-package-locks
    (let ((old (fdefinition 'sb-impl::make-fd-stream)))
      (defun sb-impl::make-fd-stream (fd &rest rest)
        (apply old fd :auto-close nil rest)))))


(defconstant +cl-path+ (uiop:xdg-config-home #p"common-lisp"))

(defparameter *git* nil)


(defun symlinkp (pathname)
  (sb-posix:s-islnk (sb-posix:stat-mode (sb-posix:lstat pathname))))

#+(or)
(sb-ext:quit)
