(defpackage :sojrn/utils/syntax
  (:use :cl)
  (:export #:concat)
  (:documentation "Syntactic Language Extensions."))

(in-package :sojrn/utils/syntax)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; String Manipulation

(defun concat (&rest strings)
  "Shorthand for CONCATENATE specialized for strings."
  (apply #'concatenate 'string strings))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Learning...

(defmacro nlet (name bindings &body body)
  `(labels ((,name ,(mapcar #'car bindings) ,@body))
     (,name ,@(mapcar #'cadr bindings))))

#+(or) ;example
(nlet fact ((n 5) (acc 1))
      (if (zerop n)
          acc
          (fact (1- n) (* acc n))))  ; => 120

#+(or) ;Equivalent to "named let" factorial
(labels ((fact (n acc)
           (if (zerop n)
               acc
               (fact (1- n) (* acc n)))))
  (fact 5 1))  ; => 120

