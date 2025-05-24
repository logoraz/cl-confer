(defpackage #:confer/libraries/cl-bexp/bexp
  (:use #:cl)
  (:import-from #:cl-interpol)
  (:import-from #:cl-ppcre
                #:regex-replace)
  (:import-from #:local-time
                #:now)
  (:export #:test-fn))
(in-package #:confer/libraries/cl-bexp/bexp)

;;; Notes:
;;;
;;; WIP - Goal to transcribe the base functionality of gexps to Common Lisp
;;;       i.e. build expressions (b-expressions - bexp)
;;;
;;; To describe a derivation and its build actions, one typically needs to embed build
;;; code inside host code. It boils down to manipulating build code as data, and the 
;;; homoiconicity of lisp—code has a direct representation as data—comes in handy 
;;; for that. But we need more than the normal quasiquote mechanism in lisp to 
;;; construct build expressions.

;;; ref: https://guix.gnu.org/manual/en/html_node/G_002dExpressions.html

(defun test-fn ())
