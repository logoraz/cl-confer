(defsystem #:confr
  :description "Short alias for confer"
  :author "Erik P Almaraz <erikalmaraz@fastmail.com>"
  :license "BSD 3-Clause"
  :version (:read-file-form "version.sexp")
  :depends-on (#:confer))
