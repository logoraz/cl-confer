(uiop:define-package :sojrn
  (:use :cl)
  (:import-from :sojrn/utils/syntax
                #:nlet)
  (:import-from :sojrn/startup
                #:*user-sojrn-directory*
                #:*sojrn-cache-directory*
                #:*sojrn-db-status*
                #:*user-config-loaded*
                #:*config-spec*
                #:*config-mgr*)
  (:import-from :sojrn/persistence
                #:outline
                #:deploy)
  (:import-from :sojrn/ui/app
                #:sojrn-app)
  (:import-from :learn-cl/sdraw
                #:sdraw)
  (:import-from :learn-cl/dtrace
                #:dtrace)
  ;; Tests/Play
  (:export #:sdraw
           #:dtrace
           #:simple-test
           #:simple-test2
           #:simple-test3)
  ;; Setup
  (:export #:*config-mgr*
           #:*config-spec*
           #:*user-sojrn-directory*
           #:*sojrn-cache-directory*
           #:*sojrn-db-status*
           #:*user-config-loaded*
           #:outline
           #:deploy)
  ;; Main Entry
  (:export #:main)
  (:documentation "Main package of SOJRN"))

(in-package :sojrn)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Play examples

(defun simple-test (&optional (n 11))
  "Simple iteration example illustrating loop."
  (loop :for i :from 0 :below n
        :collect (list (format nil "list ~A" i)
                       (/ i n))))

(defun simple-test2 (&optional (n 11))
  "Simple iteration example illustration recursion using labels"
  (labels ((rec (i acc)
             (if (>= i n)
                 (nreverse acc)
                 (rec (1+ i)
                      (cons (list (format nil "list ~A" i) (/ i n))
                            acc)))))
    (rec 0 '())))

(defun simple-test3 (&optional (n 11))
  "Simple iteration example illustration recursion using custom nlet macro."
  (nlet rec ((i 0) (acc '()))
    (if (>= i n)
        (nreverse acc)
        (rec (1+ i)
             (cons (list (format nil "list ~A" i) (/ i n)) acc)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Helpers & Conveneience Wrappers


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Entry Point

(defun main ()
  "Main entry point for the executable."
  (sojrn-app))
