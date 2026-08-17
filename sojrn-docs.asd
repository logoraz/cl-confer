(defsystem "sojrn-docs"
  :description "Documentation framework"
  :class :package-inferred-system
  :pathname "docs"
  :depends-on ("sojrn-docs/generator")
  :perform (build-op (o c)
                     (symbol-call :sojrn-docs/generator :build-docs)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Register External Systems

(register-system-packages "3bmd-ext-code-blocks" '(:3bmd-code-blocks))
