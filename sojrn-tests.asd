(defsystem "sojrn-tests"
  :description "Unit tests"
  :class :package-inferred-system
  :pathname "tests"
  :depends-on ("sojrn-tests/suite")
  :perform (test-op (o c)
                    (symbol-call :fiveam :run!
                                 (find-symbol "SUITE"
                                              :sojrn-tests/suite))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Register External Systems
(register-system-packages "fiveam" '("5AM"))
