(require :sb-posix)
(require :asdf)

(defpackage #:bootstrap
  (:use #:cl)
  (:local-nicknames (#:u #:uiop)
                    (#:posix #:sb-posix))
  (:export #:bootstrap
           #:install-ocicl-deps)
  (:documentation "Script to bootstrap :sojrn"))

(in-package #:bootstrap)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Create Symlinks (SBCL only)

(defun create-symlink (source target &key force)
  "Create a symlink from SOURCE to TARGET.
If FORCE is true, remove existing file/symlink at TARGET first.
Returns T if symlink was created, NIL if it already existed and FORCE was nil."
  (let ((source-path (u:native-namestring (u:ensure-pathname source)))
        (target-path (u:native-namestring (u:ensure-pathname target))))
    (when (probe-file target-path)
      (if force
          (progn
            (format t "Removing existing file at: ~A~%" target-path)
            (delete-file target-path))
          (progn
            (format t "Skipping (already exists): ~A~%" target-path)
            (return-from create-symlink nil))))
    (format t "Creating symlink: ~A -> ~A~%" target-path source-path)
    (posix:symlink source-path target-path)
    t))

;; TODO: Refactor to take in a list of deps as opposed to just a string?
(defun install-ocicl-deps (deps dir)
  "Install ocicl dependencies (DEPS) for nxconfig."
  (u:run-program (concatenate 'string "ocicl install "
                              deps)
                 :directory dir
                 :output :string))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SOJRN Bootstrap

(defun bootstrap (&key (force nil))
  "Bootstrap :sojrn by setting up .sbclrc symlink that ensures ocicl is
properly configured, and then installs dependencies with ocicl."
  
  (format t "~%Bootstrapping sojrn configuration...~%~%")
  
  ;; Get the directory where this script is located (current working directory)
  (let ((clfiles-dir (merge-pathnames #P"files/common-lisp/"
                                      (u:getcwd))))

    (format t "Using directory: ~A~%~%" clfiles-dir)
    
    ;; Ensure ocicl directory exists
    (ensure-directories-exist (merge-pathnames #P"sojrn/ocicl/"))

    ;; Create symlinks for config files
    (create-symlink (merge-pathnames "dot-sbclrc.lisp" clfiles-dir)
                    #P"~/.sbclrc"
                    :force force)

    (format t "~%Setup complete!~%")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Run Bootstrap
;;; sbcl --load bootstrap.lisp

(bootstrap :force t)
(sb-ext:quit)
