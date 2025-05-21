;;;; dot-sbclrc.lisp -> .sbclrc - SBCL Initialization File

;; Preserving existing /home/logoraz/.local/share/ocicl/ocicl-registry.cfg
;; Use setup's --force option to override.

;; Present the following code to your LISP system at startup, either
;; by adding it to your implementation's startup file
;; (~/.sbclrc, ~/.eclrc, ~/.clasprc,  ~/.abclrc, ~/.clinit.cl, or ~/.roswell/init.lisp)
;; or overriding it completely on the command line
;; (eg. sbcl --userinit init.lisp)

#-ocicl
(when (probe-file #P"/home/logoraz/.local/share/ocicl/ocicl-runtime.lisp")
  (load #P"/home/logoraz/.local/share/ocicl/ocicl-runtime.lisp"))
(asdf:initialize-source-registry
 (list :source-registry (list :directory (uiop:getcwd)) :inherit-configuration))
