(uiop:define-package :sojrn-tests/suite
  (:use :cl
        :5am
        :sojrn/utils/syntax
        :sojrn)
  (:export )
  (:documentation "Base Test Suite"))
(in-package :sojrn-tests/suite)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Define the test suite

(def-suite suite :description "SOJRN test suite")
(in-suite suite)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Let's first define the "easy" tests

(test concat-test
      (is (string= "1 2" (concat "1 " "2"))))
