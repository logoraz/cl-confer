;;;; Notes/Examples from Object-Oriented Programming in Common Lisp
;;;; by Sonya E. Keene
(defpackage :confer/libraries/notes/clos-locks
  (:use :cl)
  (:export ))
(in-package :confer/libraries/notest/clos-locks)


;;; Classes
;;; Class precedence Rules
;; 1. A class always has precedence over its superclass.
;; 2. Each class definition sets the precedence order of its direct superclasses.

(defclass lock ()
  ((name ; name of the slot (of type symbol or list)
    :initarg :name  ; slot option to initialize the class instance provided :name keyword
    :reader lock-name) ; slot option to read the value of this slot, 'lock-name' is setup as a method.
   )
  (:documentation "The foundation of all locks."))

(defclass null-lock (lock)
  ()
  (:documentation "A lock that is always free."))

(defclass simple-lock (lock)
  (owner :initform nil
         :accessor lock-owner)
  (:documentation "A lock that is either free or busy."))


;;; Constructors

(defun make-null-lock (name)
  (make-instance 'null-lock :name name))

(defun make-simple-lock (name)
  (make-instance 'simple-lock :name name))


;;; Interface (Generic Functions via defgeneric)

(defgeneric seize (lock)
  (:documentation
   "Seizes the lock.
Returns the lock when the operation succeeds.
Some locks simply wait until they can succeed, while
other locks return NIL if they fail."))

(defgeneric release (lock &optional failure-mode)
  (:documentation
   "Releases the lock if it is currently owned by this process.
Returns T if the operation succeeds.
If unsuccessful and failure-mode is :no-error, returns NIL.
If unsuccessful and failure-mode is :error, signals an error.
The default for failure-mode is :no-error"))


;;; Methods
;; Rule of method applicability:
;; A method is applicable if each of its specialized parameters is satisfied
;; by the corresponding argument to the general function.
;; in the case below '(l null-lock) is the specialized parameter.

;; null-locks
(defmethod seize ((l null-lock))
  l) ;; return lock, no waiting

(defmethod release ((l null-lock) &optional failure-mode)
  (declare (ignore failure-mode)) ;; never fails for null locks
  t)

;; simple-locks

#+(or)
(defmethod check-for-mylock ((l simple-lock) process)
  (when (eql (lock-owner l) process)
    (error "Can't seizze ~A because you already own it." l)))

#+(or)
(defmethod seize ((l simple-lock))
  (check-for-mylock l *current-process*)
  (do ()
      ((setf-if (lock-owner l) nil *current-process*))
    (process-wait "Seizing lock"
                  #'(lambda () (null (lock-owner l))))))


;;; Specialized Methods
(defmethod print-object ((l lock) stream)
  (format stream "#<~S ~A ~D>"
          (type-of l)
          (if (slot-boundp l 'name)
              (lock-name l)
              "(no name)")
          (sys:%pointer l))
  l)

(defmethod describe ((l lock))
  (format t "~&~S is a lock of type ~S names ~A."
          l (type-of l)
          (if (slot-boundp l 'name)
              (lock-name l)
              "(no name)"))
  (values))

(defmethod describe :after ((l simple-lock))
  (let ((owner (lock-owner l)))
    (format t (if owner
                  "~&It is now owned by process ~A. ~%"
                  "~&It is now free. ~%")
            owner)))


;;; Ordered Locks

(defclass ordered-lock-mixin ()
  ((level :initarg :level
          :reader lock-level
          :type integer))
  (:documentation "Avoids deadlock by checking lock order."))

;; aggregate classes
(defclass ordered-lock (ordered-lock-mixin simple-lock)
  (:documentation 
   "Avoids deadlock by ensuring that a process seizes locks
in a specific order. When seizing, waits if the lock is busy."))

(defclass ordered-null-lock (ordered-lock-mixin null-lock)
  (:documentation
   "Avoids deadlock by ensuring that a process seizes locks
in a specific order.  Does not actually seize anything, but
does check that the lock ordering is obeyed."))

;; Constructors
(defun make-ordered-null-lock (name level)
  (make-instance 'ordered-null-lock :name name :level level))

(defun make-ordered-lock (name level)
  (make-instance 'ordered-lock :name name :level level))

(defmethod describe :after ((l ordered-lock-mixin))
  (format t "~&Its lock level is ~D." (lock-level l)))

