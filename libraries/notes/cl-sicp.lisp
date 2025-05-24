(defpackage #:confer/notes/cl-sicp
  (:use #:cl))
(in-package #:confer/notes/cl-sicp)

;;; Structure and Interpretation of Computer Programs (SICP)
;; Define a procedure 'doubles' that takes a procedure of one argument as an
;; argument and returns a procedure that applies the original procedure twice.
;; For example, if 'inc1' is a procedure that adds 1 to its argument, then
;; (doubles #'inc) should be a procedure that adds 2. What value is returned by
;; (funcall (funcall (doubles (doubles #'doubles)) #'inc1) 5)

(defun doubles (fn)
  (lambda (val)
    (funcall fn (funcall fn val))))

(defun inc1 (x)
  (+ x 1))

(funcall (doubles #'inc1) 1)
(funcall (funcall (doubles (doubles #'doubles)) #'inc1) 5)
