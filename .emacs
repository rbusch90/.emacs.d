;; Universal necessities
(add-to-list 'load-path "~/.emacs.d/")
(setq inhibit-splash-screen 1)
(delete-selection-mode 1)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(global-linum-mode t)
(show-paren-mode t)
(column-number-mode t)

;;; Move Auto-Saves to their own backup directory
(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))

;; Persistent *scratch* buffer
(defvar persistent-scratch-filename 
    "~/.emacs.d/persistent-scratch"
    "Location of *scratch* file contents for persistent-scratch.")
(defvar persistent-scratch-backup-directory 
    "~/.emacs.d/persistent-scratch-backups/"
    "Location of backups of the *scratch* buffer contents for
    persistent-scratch.")
(defun make-persistent-scratch-backup-name ()
  "Create a filename to backup the current scratch file by
  concatenating PERSISTENT-SCRATCH-BACKUP-DIRECTORY with the
  current date and time."
  (concat 
   persistent-scratch-backup-directory 
   (replace-regexp-in-string 
     (regexp-quote " ") "-" (current-time-string))))
(defun save-persistent-scratch ()
  "Write the contents of *scratch* to the file name
  PERSISTENT-SCRATCH-FILENAME, making a backup copy in
  PERSISTENT-SCRATCH-BACKUP-DIRECTORY."
  (with-current-buffer (get-buffer "*scratch*")
    (if (file-exists-p persistent-scratch-filename)
        (copy-file persistent-scratch-filename
                   (make-persistent-scratch-backup-name)))
    (write-region (point-min) (point-max) 
                  persistent-scratch-filename)))
(defun load-persistent-scratch ()
  "Load the contents of PERSISTENT-SCRATCH-FILENAME into the
  scratch buffer, clearing its contents first."
  (if (file-exists-p persistent-scratch-filename)
      (with-current-buffer (get-buffer "*scratch*")
        (delete-region (point-min) (point-max))
        (shell-command (format "cat %s" persistent-scratch-filename) (current-buffer)))))
(load-persistent-scratch)
(push #'save-persistent-scratch kill-emacs-hook)
(setq initial-scratch-message ";; This is a pimped out scratch buffer that persists across sessions. --russellb")

;; Python schtuff
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))


;; C++ schtuff
(add-hook 'c++-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))

;; Groovy
(load "groovy-mode.el")
(add-to-list 'auto-mode-alist '("\\.groovy\\'" . groovy-mode))

;; Mathematica schtuff
;; Can be commented out on machines where we don't run Mathematica
(load-library "mathematica")
;; Mathematica command-line executable directory is variable, so line may change
(setq mathematica-command-line "/Applications/Mathematica\ 9.app/Contents/MacOS/MathKernel")
