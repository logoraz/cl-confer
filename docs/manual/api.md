# API Reference

## Package SOJRN/CORE/CONFIG-MANAGER

### `CONFIG-MANAGER` (type)
Manages a collection of config-object entries.

### `EXPAND-PATHNAME` (function)
Expand ~ and ~/ to user's home directory.

### `SYMLINK-UPDATE-NEEDED-P` (function)
Return T if LINK needs updating to point to TARGET.
Returns T if:
  - LINK doesn't exist
  - LINK exists but is not a symlink
  - LINK is a symlink but points to a different target

If DIR is true, treats TARGET as a directory path.

### `CREATE-SYMLINK` (function)
Create a symlink at LINK pointing to SRC.

Keywords:
  DIR - If true, treat SRC as a directory
  OVERWRITE - If true (default), replace existing file/symlink at LINK
  BACKUP - If true, backup existing file before overwriting (only for regular files)

Returns LINK pathname on success.
Signals an error if LINK exists and OVERWRITE is NIL.

### `ADD-CONFIGS` (function)
Add multiple config entries to MGR from SPEC.
SPEC is a list of entries, each shaped as add-config's own argument
list: (name source place &key spec type validate). Returns the names
of the configs added, in reverse of SPEC's order.

### `DEPLOY-CONFIGS` (function)
Deploy all configurations.

### `CONFIG-OBJECT` (type)
Represents a single configuration entry.

### `CONFIG-ERROR` (type)
Base condition for config-manager errors.

### `REMOVE-CONFIG` (function)
Remove a config entry by name or object.

### `SYMLINKP` (function)
Test if path is a symlink.

### `CONFIG-COUNT` (function)
Return the number of configs.

### `CLEAR-CONFIGS` (function)
Remove all config entries.

### `FIND-CONFIG` (function)
Find a config by name.

### `SYMLINK-TARGET` (function)
Return the target of symlink PATHSPEC, or NIL if not a symlink.
Uses osicat:read-link internally.

### `ADD-CONFIG` (function)
Add a config entry to the manager.

### `LIST-CONFIGS` (function)
Print the deployment plan.

### `COPY-DIRECTORY` (function)
Recursively copy directory SOURCE to DEST using pure Lisp.

Keywords:
  OVERWRITE - If true (default), overwrite existing files

Creates DEST if it doesn't exist. Copies all files and subdirectories.

## Package SOJRN

### `MAIN` (function)
Main entry point for the executable.

### `SIMPLE-TEST3` (function)
Simple iteration example illustration recursion using custom nlet macro.

### `SIMPLE-TEST2` (function)
Simple iteration example illustration recursion using labels

### `SIMPLE-TEST` (function)
Simple iteration example illustrating loop.

## Package SOJRN/UI/APP

### `SOJRN-APP` (function)
Create and run a minimal GTK4 application window with a close button.

## Package SOJRN/DEPLOYMENT

### `OUTLINE` (function)
List your Configuration Environment outline.

### `LOAD-SNAPSHOT` (function)
Load a snapshot into the current config manager.
WARNING: This replaces all current configs in mgr.

Example:
  (snapshots)            ; List available snapshots
  (load-snapshot mgr 1)  ; Load snapshot with ID 1
  (outline mgr)          ; Verify loaded configs
  (deploy mgr)           ; Deploy the loaded configs

### `SNAPSHOTS` (function)
List available configuration snapshots.

Example:
  (snapshots)

### `DEPLOY` (function)
Deploy Your Configuration Environment (without recording to database).

### `ROLLBACK` (function)
Rollback a deployment by ID.
By default, DRY-RUN is T - it will only show what would be removed.
Set DRY-RUN to NIL to actually perform the rollback.

Example:
  (rollback 1)              ; Preview what would be rolled back
  (rollback 1 :dry-run nil) ; Actually perform rollback

### `SAVE-SNAPSHOT` (function)
Save the current configuration as a named snapshot.
Snapshots let you save different configuration sets and switch between them.

Example:
  (save-snapshot mgr "workstation" :description "Full dev environment")
  (save-snapshot mgr "minimal" :description "Just shell configs")

### `HISTORY` (function)
Show recent deployment history.

Example:
  (history)        ; Show last 10 deployments
  (history :limit 5) ; Show last 5 deployments

### `DEPLOY-AND-RECORD` (function)
Deploy configurations and record to the database.
Optional NOTES can describe this deployment
(e.g., 'Initial setup', 'Added emacs config').

Example:
  (deploy-and-record mgr :notes "Initial workstation setup")

### `INIT-DB` (function)
Initialize the persistence database. Run this once before using persistence features.

Example:
  (init-db)

## Package SOJRN/UTILS/SYNTAX

### `CONCAT` (function)
Shorthand for CONCATENATE specialized for strings.

## Package SOJRN/USER-CONFIG

### `*CONFIG-SPEC*` (variable)
Default config spec, pulls from the sorjn files directory.

## Package SOJRN/CORE/PERSISTENCE

### `SAVE-CONFIG-SNAPSHOT` (function)
Save current manager configuration as a named snapshot.

### `ROLLBACK-DEPLOYMENT` (function)
Attempt to rollback a deployment by reversing its actions.
For symlinks: remove the symlink
For copies: remove the copied file (original source still exists)

If DRY-RUN is true, only report what would be done.

### `WITH-DATABASE` (function)
Execute BODY with a database connection bound to *db-connection*.
Automatically handles connection opening and closing.

### `GET-DEPLOYMENT-BY-ID` (function)
Get a deployment record with all its actions.

### `INITIALIZE-DATABASE` (function)
Initialize the database with the required schema.

### `DEPLOY-WITH-HISTORY` (function)
Deploy configurations and record in database.
Returns (values deployment-id results).

### `GET-LATEST-DEPLOYMENT` (function)
Get the most recent deployment.

### `GET-DEPLOYMENT-HISTORY` (function)
Get recent deployment history.

### `LOAD-CONFIG-SNAPSHOT` (function)
Load a snapshot into MANAGER, replacing current configs.

### `LIST-SNAPSHOTS` (function)
List available configuration snapshots.

### `RECORD-DEPLOYMENT` (function)
Record a new deployment from MANAGER, returning the deployment ID.
Call this BEFORE deploy-configs to create the deployment record,
then update action statuses as deployment proceeds.

### `*DB-PATH*` (variable)
Default path for the SQLite database.

## Package SOJRN-DOCS/GENERATOR

### `BUILD-DOCS` (function)
Documentation builder for sojrn.

## Package SOJRN/UTILS/ANSI-COLOR

### `ARROW` (function)
Return arrow string based on Unicode support.

### `COLOR` (function)
Return concatenated ANSI codes for COMMANDS.

### `STRIP-ANSI` (function)
Remove ANSI escape codes from string S.

### `*USE-UNICODE-ARROWS*` (variable)
Use Unicode arrows (→) when T and terminal supports it.

### `COLORED-STREAM` (type)
A Gray stream that adds ANSI colors to output.

