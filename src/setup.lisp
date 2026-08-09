(defpackage :sojrn/setup
  (:use :cl
        :sojrn/core/config-manager
        :sojrn/core/persistence)
  ;; Basic Setup
  (:export #:outline
           #:deploy)
  ;; Advanced Setup
  (:export #:init-db
           #:deploy-and-record
           #:history
           #:rollback
           #:save-snapshot
           #:load-snapshot
           #:snapshots)
  (:documentation "Setup script to scaffold CL configuration/environment."))

(in-package :sojrn/setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Current Configuration Setup

(defparameter *config-mgr* (make-instance 'config-manager))

(defparameter *config-spec*
  '(("SBCL Config"
     "~/Work/sojrn/files/common-lisp/dot-sbclrc.lisp" "~/.sbclrc"
     :spec :symlink :type :file)))

(add-configs *config-mgr* *config-spec*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Deploy config-objects (Original - no persistence)

(defun outline ()
  "List your Configuration Environment outline."
  (unless *print-pretty*
    (setf *print-pretty* t))
  (let ((stream (make-instance 'colored-stream :target *standard-output*)))
    (list-configs *config-mgr* stream)))

(defun deploy ()
  "Deploy Your Configuration Environment (without recording to database)."
  (unless *print-pretty*
    (setf *print-pretty* t))
  (let ((stream (make-instance 'colored-stream :target *standard-output*)))
    (deploy-configs *config-mgr* stream)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Deploy with Persistence

(defun deploy-and-record (&key (notes nil))
  "Deploy configurations and record to the database.
Optional NOTES can describe this deployment
(e.g., 'Initial setup', 'Added emacs config').

Example:
  (deploy-and-record :notes \"Initial workstation setup\")"
  (unless *print-pretty*
    (setf *print-pretty* t))
  (let ((stream (make-instance 'colored-stream :target *standard-output*)))
    (with-database ()
      (multiple-value-bind (deployment-id status)
          (deploy-with-history *config-mgr* :notes notes :verbose stream)
        (format stream "~%Deployment ID: ~A, Status: ~A~%" deployment-id status)
        (values deployment-id status)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; History & Rollback

(defun history (&key (limit 10))
  "Show recent deployment history.

Example:
  (history)        ; Show last 10 deployments
  (history :limit 5) ; Show last 5 deployments"
  (with-database ()
    (let ((deployments (get-deployment-history :limit limit)))
      (format t "~%=== Deployment History ===~%~%")
      (if (null deployments)
          (format t "(no deployments recorded)~%")
          (dolist (dep deployments)
            (format t "ID: ~A | ~A | ~A | ~A~%"
                    (getf dep :|id|)
                    (getf dep :|timestamp|)
                    (getf dep :|status|)
                    (or (getf dep :|notes|) ""))))
      (format t "~%")
      deployments)))

(defun rollback (deployment-id &key (dry-run t))
  "Rollback a deployment by ID.
By default, DRY-RUN is T - it will only show what would be removed.
Set DRY-RUN to NIL to actually perform the rollback.

Example:
  (rollback 1)              ; Preview what would be rolled back
  (rollback 1 :dry-run nil) ; Actually perform rollback"
  (with-database ()
    (multiple-value-bind (rolled-back total)
        (rollback-deployment deployment-id :dry-run dry-run)
      (if dry-run
          (format t "~%[DRY RUN] Would rollback ~A of ~A actions.~%" rolled-back total)
          (format t "~%Rolled back ~A of ~A actions.~%" rolled-back total))
      (values rolled-back total))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Snapshots - Save/Load Configuration Sets

(defun save-snapshot (name &key (description nil))
  "Save the current configuration as a named snapshot.
Snapshots let you save different configuration sets and switch between them.

Example:
  (save-snapshot \"workstation\" :description \"Full dev environment\")
  (save-snapshot \"minimal\" :description \"Just shell configs\")"
  (with-database ()
    (let ((id (save-config-snapshot *config-mgr* name :description description)))
      (format t "Snapshot '~A' saved with ID ~A~%" name id)
      id)))

(defun load-snapshot (snapshot-id)
  "Load a snapshot into the current config manager.
WARNING: This replaces all current configs in *config-mgr*.

Example:
  (snapshots)       ; List available snapshots
  (load-snapshot 1) ; Load snapshot with ID 1
  (outline)         ; Verify loaded configs
  (deploy)          ; Deploy the loaded configs"
  (with-database ()
    (load-config-snapshot *config-mgr* snapshot-id)
    (format t "Loaded snapshot ~A into *config-mgr*~%" snapshot-id)
    (format t "Use (outline) to see configs, (deploy) to deploy.~%")
    *config-mgr*))

(defun snapshots (&key (limit 20))
  "List available configuration snapshots.

Example:
  (snapshots)"
  (with-database ()
    (let ((snaps (list-snapshots :limit limit)))
      (format t "~%=== Configuration Snapshots ===~%~%")
      (if (null snaps)
          (format t "(no snapshots saved)~%")
          (dolist (snap snaps)
            (format t "ID: ~A | ~A | ~A~%    ~A~%"
                    (getf snap :|id|)
                    (getf snap :|name|)
                    (getf snap :|created_at|)
                    (or (getf snap :|description|) ""))))
      (format t "~%")
      snaps)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Database Initialization (Run once)

(defun init-db ()
  "Initialize the persistence database. Run this once before using persistence features.

Example:
  (init-db)"
  (initialize-database)
  (format t "~%Database ready. You can now use:~%")
  (format t "  (deploy-and-record :notes \"...\") - Deploy with history~%")
  (format t "  (history)                         - View past deployments~%")
  (format t "  (save-snapshot \"name\")            - Save current config~%")
  (format t "  (snapshots)                       - List saved snapshots~%"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Install/Configure Common Lisp Utilities (i.e. ocicl, ccl, etc)
;;;
;; TODO: Enable `config-manager` to install/setup Common Lisp utilities like
;; ocicl...

#+(or)
(progn
  sbcl --eval "(defconstant +dynamic-space-size+ 2048)" --load setup.lisp)
