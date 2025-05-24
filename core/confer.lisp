(defpackage #:confer/core/confer
  (:use #:cl
        #:confer/libraries/utils/base)
  (:export #:simple-test
           #:test-utils))
(in-package #:confer/core/confer)


(defconstant +cl-path+ (uiop:xdg-config-home #p"common-lisp"))

(defun simple-test (&optional (n 11))
  "Simple function for testing."
  (loop :for i :from 0 :below n
        :collect (list (format nil "list ~A" i)
                       (/ i n))))

(defun test-utils ()
  (concat "string-1" " " "string-2"))
