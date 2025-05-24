(defpackage #:confer/libraries/juego-clos/main
  (:use #:cl)
  (:export #:*hans-drives-and-pays?*
           #:*invoke-tariffs?*
           #:make-cool-hans
           #:make-biatcho-hans
           #:make-goofball-hans
           #:make-erk))
(in-package #:confer/libraries/juego-clos/main)


(defvar *hans-drives-and-pays?* "YES: Hans happily drives and Pays for ERKS meal!"
  "Paramter (boolean) set to determine if hans drives AND pays.")

(defvar *invoke-tariffs?* "NO: Hans will not invoke tarrifs."
"Paramter (boolean) set to determine if hans is allowed to invoke tarrifs")


;;Define Classes

(defclass person ()
  ((name :initarg :name))
  (:documentation "The foundation of all persons."))

(defclass hans (person)
  ((mood :initarg :mood
         :accessor hans-mood))
  (:documentation "The foundation of all hans instances"))

(defclass erk (person)
  ((mood :initarg :mood
         :accessor erk-mood))
  (:documentation "The foundation of all erk instances"))

;; Define Class constructors

(defun make-cool-hans (name &key (mood "happy") &allow-other-keys)
  "Make a COOL HANS instance."
  (make-instance 'hans :name name :mood mood))

(defun make-biatcho-hans (name &key (mood "biatcho") &allow-other-keys)
  "Make a COOL HANS instance."
  (make-instance 'hans :name name :mood mood))

(defun make-goofball-hans (name &key (mood "goofball") &allow-other-keys)
  "Make a COOL HANS instance."
  (make-instance 'hans :name name :mood mood))

(defun make-erk (name &key (mood "Common Lisp") &allow-other-keys)
  (make-instance 'erk :name name :mood mood))


;; Define Interface to cool hans

(defgeneric coolify (person)
  (:documentation "
Gives Person a Snickers to zap him out of being a DIVA."))

(defgeneric biatchar (person)
  (:documentation "
Turns Person into a BIATCHO and presumes its typical mood
of choking down MACHISMECCOS (leche de siete Machos)"))


;; Specialized Methods
