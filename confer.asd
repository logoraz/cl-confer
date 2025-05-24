(defsystem #:confer
  :description "Common Lisp Configuration Environment Resource"
  :author "Erik P Almaraz <erikalmaraz@fastmail.com"
  :license "BSD 3-Clause"
  :version (:read-file-form "version.sexp")
  ;; :defsystem-depends-on (:asdf-package-system)
  :class :package-inferred-system
  :depends-on (#:bordeaux-threads
               #:lparallel
               #:closer-mop
               #:local-time
               #:cl-interpol
               #:cl-ppcre
               #:confer/setup
               #:confer/core/all
               #:confer/libraries/utils/all
               #:confer/libraries/juego-clos/all
               #:confer/libraries/cl-bexp/all
               #:confer/libraries/website/all
               #:confer/libraries/chembook/all
               #:confer/libraries/learncl/all)
  :in-order-to ((test-op (test-op #:confer-test))))

;; setup/config
(register-system-packages "confer/setup" '(#:setup))

;; Core
(register-system-packages "confer/core/all" '(#:confer))

;; Libraries
(register-system-packages "confer/libraries/utils/all"      '(#:utils))
(register-system-packages "confer/libraries/learncl/all"    '(#:learncl))
(register-system-packages "confer/libraries/website/all"    '(#:web))
(register-system-packages "confer/libraries/chembook/all"   '(#:chembook))
(register-system-packages "confer/libraries/cl-bexp/all"    '(#:bexp))
(register-system-packages "confer/libraries/juego-clos/all" '(#:juego))

;; Externals
(register-system-packages "closer-mop"
                          '(#:c2mop
                            #:closer-common-lisp 
                            #:c2cl 
                            #:closer-common-lisp-user
                            #:c2cl-user))
