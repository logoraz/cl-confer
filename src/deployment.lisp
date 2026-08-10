(defpackage :sojrn/deployment
  (:use :cl
        :sojrn/core/config-manager
        :sojrn/core/persistence
        :sojrn/utils/ansi-color)
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
  (:documentation "Deployment, history, and snapshot API."))

(in-package :sojrn/deployment)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Deploy config-objects (Original - no persistence)

(defun outline (mgr)
  "List your Configuration Environment outline."
  (unless *print-pretty*
    (setf *print-pretty* t))
  (let ((stream (make-instance 'colored-stream :target *standard-output*)))
    (list-configs mgr stream)))

(defun deploy (mgr)
  "Deploy Your Configuration Environment (without recording to database)."
  (unless *print-pretty*
    (setf *print-pretty* t))
  (let ((stream (make-instance 'colored-stream :target *standard-output*)))
    (deploy-configs mgr stream)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Deploy with Persistence

(defun deploy-and-record (mgr &key (notes nil))
  "Deploy configurations and record to the database.
Optional NOTES can describe this deployment
(e.g., 'Initial setup', 'Added emacs config').

Example:
  (deploy-and-record mgr :notes \"Initial workstation setup\")"
  (unless *print-pretty*
    (setf *print-pretty* t))
  (let ((stream (make-instance 'colored-stream :target *standard-output*)))
    (with-database ()
      (multiple-value-bind (deployment-id status)
          (deploy-with-history mgr :notes notes :verbose stream)
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

(defun save-snapshot (mgr name &key (description nil))
  "Save the current configuration as a named snapshot.
Snapshots let you save different configuration sets and switch between them.

Example:
  (save-snapshot mgr \"workstation\" :description \"Full dev environment\")
  (save-snapshot mgr \"minimal\" :description \"Just shell configs\")"
  (with-database ()
    (let ((id (save-config-snapshot mgr name :description description)))
      (format t "Snapshot '~A' saved with ID ~A~%" name id)
      id)))

(defun load-snapshot (mgr snapshot-id)
  "Load a snapshot into the current config manager.
WARNING: This replaces all current configs in mgr.

Example:
  (snapshots)            ; List available snapshots
  (load-snapshot mgr 1)  ; Load snapshot with ID 1
  (outline mgr)          ; Verify loaded configs
  (deploy mgr)           ; Deploy the loaded configs"
  (with-database ()
    (load-config-snapshot mgr snapshot-id)
    (format t "Loaded snapshot ~A into mgr~%" snapshot-id)
    (format t "Use (outline) to see configs, (deploy) to deploy.~%")
    mgr))

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
  (format t "  (deploy-and-record mgr :notes \"...\") - Deploy with history~%")
  (format t "  (history)                              - View past deployments~%")
  (format t "  (save-snapshot mgr \"name\")           - Save current config~%")
  (format t "  (snapshots)                            - List saved snapshots~%"))
