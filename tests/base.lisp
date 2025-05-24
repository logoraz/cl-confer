(defpackage #:confer-test/tests/base
  (:use #:cl
        #:fiveam)
  (:export #:root-suite))
(in-package #:confer-test/tests/base)

;; https://common-lisp-libraries.readthedocs.io/fiveam/
;; https://github.com/lispci/fiveam/blob/master/t/example.lisp


 (def-suite root-suite
  :description "Root Test Suite.")

(def-suite read-file-as-string
  :description "Test the read-file-as-string function."
  :in root-suite)
(in-suite read-file-as-string)

;; We have a custom "file doesn't exist" condition.
(define-condition file-not-existing-error (error)
  ((filename :type string :initarg :filename :reader filename)))

;; We have a function that tries to read a file and signals the above condition
;; if the file doesn't exist.
(defun read-file-as-string (filename &key (error-if-not-exists t))
  "Read file content as string. FILENAME specifies the path of file.

Keyword ERROR-IF-NOT-EXISTS specifies the operation to perform when the file
is not found. T (by default) means an error will be signaled. When given NIL,
the function will return NIL in that case."
  (cond
    ((uiop:file-exists-p filename)
     (uiop:read-file-string filename))
    (error-if-not-exists
     (error 'file-not-existing-error :filename filename))
    (t nil)))

;; Our first "base" case: we read a file that contains "hello".
(test read-file-as-string-normal-file
      (let ((result (read-file-as-string "~/Work/cl-confer/tests/tmp/hello.txt")))
        ;; Tip: put the expected value as the first argument of = or equal, string= etc.
        ;; FiveAM generates a more readable report following this convention.
        (is (string= "hello" result))))

;; We read an empty file.
(test read-file-as-string-empty-file
      (let ((result (read-file-as-string "~/Work/cl-confer/tests/tmp/empty.txt")))
        (is (not (null result)))
        ;; The reason can be used to provide formatted text.
        (is (= 0 (length result)))
        "Empty string expected but got ~a" result))

;; Now we test that reading a non-existing file signals our condition.
(test read-file-as-string-non-existing-file
      (let ((result (read-file-as-string "~/Work/cl-confer/tests/tmp/non-existing-file.txt"
                                         :error-if-not-exists nil)))
        (is (null result)
            "Reading a file should return NIL when :ERROR-IF-NOT-EXISTS is set to NIL"))
      ;; SIGNALS accepts the unquoted name of a condition and a body to evaluate.
      ;; Here it checks if FILE-NOT-EXISTING-ERROR is signaled.
      (signals file-not-existing-error
               (read-file-as-string "~/Work/cl-confer/tests/tmp/non-existing-file.txt"
                                    :error-if-not-exists t)))
