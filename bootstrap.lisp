(require :sb-posix)
(require :asdf)

(defpackage :bootstrap
  (:use :cl)
  (:local-nicknames (#:u :uiop)
                    (#:posix :sb-posix))
  (:export #:bootstrap)
  (:documentation "Script to bootstrap :sojrn"))

(in-package :bootstrap)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Helper Functions (SBCL only)

(defun create-symlink (source target &key force)
  "Create a symlink from SOURCE to TARGET.
If FORCE is true, remove existing file/symlink at TARGET first.
Returns T if symlink was created, NIL if it already existed and FORCE was nil."
  (let ((source-path (u:native-namestring (u:ensure-pathname source)))
        (target-path (u:native-namestring (u:ensure-pathname target))))
    (when (probe-file target-path)
      (if force
          (progn
            (format t "Removing existing file at: ~A~%~%" target-path)
            (delete-file target-path))
          (progn
            (format t "Skipping (already exists): ~A~%~%" target-path)
            (return-from create-symlink nil))))
    (format t "Creating symlink: ~A -> ~A~%" target-path source-path)
    (posix:symlink source-path target-path)
    t))

(defun vendor-deps (deps)
  "Vendor dependencies, DEPS ((system-name . git-urls) ...), to ocicl directory."
  (let ((ocicl-dir (merge-pathnames #P"ocicl/" (u:getcwd))))
    (labels ((vend (deps acc)
               (if (null deps) acc
                   (let* ((system-name (caar deps))
                         (git-url (cdar deps))
                         (target-dir (merge-pathnames
                                      (concatenate 'string system-name "/")
                                      ocicl-dir)))
                     (if (probe-file target-dir)
                         (u:delete-directory-tree target-dir :validate t))
                     (format t "~%Vendoring: ~A -> ~A~%" git-url target-dir)
                     (force-output)
                     (u:run-program
                      (concatenate 'string "git clone "
                                   git-url " "
                                   (u:native-namestring target-dir))
                      :output t
                      :error-output t)
                     (setf acc (cons system-name acc))
                     (vend (cdr deps) acc)))))
      (vend deps '()))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SOJRN Bootstrap

(defun bootstrap (&key (force nil))
  "Bootstrap :sojrn by setting up .sbclrc symlink that ensures ocicl is
properly configured, and then installs dependencies with ocicl."
  
  (format t "~%Bootstrapping sojrn configuration...~%~%")
  
  ;; Get the directory where this script is located (current working directory)
  (let ((clfiles-dir (merge-pathnames #P"files/common-lisp/" (u:getcwd)))
        (ocicl-dir (merge-pathnames #P"ocicl/" (u:getcwd))))

    (format t "Config file source directory: ~A~%~%" clfiles-dir)
    
    ;; Ensure ocicl directory exists
    (format t "Creating ocicl directory: ~A~%~%" ocicl-dir)
    (ensure-directories-exist ocicl-dir)

    ;; Create symlinks for config files
    (create-symlink (merge-pathnames "dot-sbclrc.lisp" clfiles-dir)
                    #P"~/.sbclrc"
                    :force force)

    ;; Vendor broken ocicl registries: `cl-cffi-gtk4' and `cl-cffi-gdk-pixbuf'
    (vendor-deps
     '(("cl-cffi-gtk4"       . "https://github.com/crategus/cl-cffi-gtk4.git")
       ("cl-cffi-gdk-pixbuf" . "https://github.com/crategus/cl-cffi-gdk-pixbuf.git")))

    (format t "~%~%Setup complete!~%")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Run Bootstrap
;;; sbcl --load bootstrap.lisp

(bootstrap :force t)
(sb-ext:quit)
