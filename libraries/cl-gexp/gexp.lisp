(defpackage :confer/libraries/cl-gexp/gexp
  (:use :cl)
  (:import-from :cl-interpol)
  (:import-from :cl-ppcre
                #:regex-replace)
  (:import-from :local-time
                #:now)
  (:export #:test-fn))
(in-package :confer/libraries/cl-gexp/gexp)

;;; Notes:
;;;
;;; WIP - Goal to transcribe the base functionality of gexps to Common Lisp
;;;
;;; This module implements "G-expressions", or "gexps".  Gexps are like
;;; S-expressions (sexps), with two differences:
;;;
;;;   1. References (un-quotations) to derivations or packages in a gexp are
;;;      replaced by the corresponding output file name; in addition, the
;;;      'ungexp-native' unquote-like form allows code to explicitly refer to
;;;      the native code of a given package, in case of cross-compilation;
;;;
;;;   2. Gexps embed information about the derivations they refer to.
;;;
;;; Gexps make it easy to write to files Scheme code that refers to store
;;; items, or to write Scheme code to build derivations.
;;;
;;; "G expressions".

(defun test-fn ())
