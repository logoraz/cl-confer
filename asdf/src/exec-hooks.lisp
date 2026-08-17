(in-package :sojrn-asdf-system)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Configure Executable runtime PATH

#+linux
(defmethod perform ((o load-op) (c sojrn-exec-system))
  (uiop:register-image-restore-hook #'configure-guix-cffi-path nil))

#+windows
(defmethod perform ((o load-op) (c sojrn-exec-system))
  (uiop:register-image-restore-hook #'configure-windows-cffi-path nil))

;;; Close foreign libraries before saving image (avoids double-loading on restart)
(defmethod perform :before ((o program-op) (c sojrn-exec-system))
  (loop :for lib :in (cffi:list-foreign-libraries :loaded-only t)
        :do (cffi:close-foreign-library lib)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Enable SBCL core compression for executables

#+sb-core-compression
(defmethod perform ((o image-op) (c sojrn-exec-system))
  (uiop:dump-image (output-file o c) :executable t :compression t))
