(defpackage #:confer/libraries/notes/scratch 
  (:use #:cl))
(in-package #:confer/libraries/notes/scratch)

;; Figure out how to use mapcar!
(mapcar (lambda (x) (+ x 1)) '(1 2 3 4 5))

;; accessing/viewing the common lisp KEYWORD package
(describe (find-package 'keyword))
(apropos "" "KEYWORD")

;; describe on sbcl will show the symbols under a package(though it might truncate it because there's a ton of symbols in it)
;; Use do-symbols to iterate over all the symbols

;; Y-Combinator
(defun Y (f)
  (labels ((g (&rest args) (apply f #'g args)))
    #'g))

#+(or)
(defun Y (f)
  (lambda (&rest args)
    (apply f (Y f) args)))
