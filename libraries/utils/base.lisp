(defpackage #:confer/libraries/utils/base
  (:use #:cl)
  (:import-from #:cl-interpol)
  (:export #:concat))
(in-package #:confer/libraries/utils/base)


(defun concat (&rest strings)
  (apply #'concatenate 'string strings))