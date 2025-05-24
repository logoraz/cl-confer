(defsystem #:confer-test
  :description "Unit Testing System for confer"
  :author "Erik P Almaraz <erikalmaraz@fastmail.com"
  :license "BSD 3-Clause"
  :version (:read-file-form "version.sexp")
  :class :package-inferred-system
  :depends-on (#:fiveam
               #:confer-test/tests/all)
  :perform (test-op (op c) 
                    (symbol-call 'fiveam 'run!
                                 (find-symbol* 'root-suite 'tests))))
