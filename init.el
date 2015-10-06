;;; init.el --- Where all the magic begins
;;
;; Part of the Emacs Starter Kit
;;
;; This is the first thing to get loaded.
;;

;; load Org-mode from source when the ORG_HOME environment variable is set
(when (getenv "ORG_HOME")
  (let ((org-lisp-dir (expand-file-name "lisp" (getenv "ORG_HOME"))))
    (when (file-directory-p org-lisp-dir)
      (add-to-list 'load-path org-lisp-dir)
      (require 'org))))

;; load the starter kit from the `after-init-hook' so all packages are loaded
(add-hook 'after-init-hook
 `(lambda ()
    ;; remember this directory
    (setq starter-kit-dir
          ,(file-name-directory (or load-file-name (buffer-file-name))))
    ;; only load org-mode later if we didn't load it just now
    ,(unless (and (getenv "ORG_HOME")
                  (file-directory-p (expand-file-name "lisp"
                                                      (getenv "ORG_HOME"))))
       '(require 'org))
    ;; load up the starter kit
    (org-babel-load-file (expand-file-name "starter-kit.org" starter-kit-dir))))

;;; init.el ends here

; franee customizations

;; set default dir
(setq default-directory "/opt/")

(menu-bar-mode -1)

;; show line numbers
(global-linum-mode 1)

;; remove trailing spaces on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Kills live buffers, leaves some emacs work buffers
;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-all-buffers (&optional list)
    "For each buffer in LIST, kill it silently if unmodified. Otherwise ask.
LIST defaults to all existing live buffers."
    (interactive)
    (if (null list)
        (setq list (buffer-list)))
    (while list
      (let* ((buffer (car list))
             (name (buffer-name buffer)))
        (and (not (string-equal name ""))
             (not (string-equal name "*Messages*"))
             (not (string-equal name "*Buffer List*"))
             (not (string-equal name "*buffer-selection*"))
             (not (string-equal name "*Shell Command Output*"))
             (not (string-equal name "*scratch*"))
             (/= (aref name 0) ? )
             (if (buffer-modified-p buffer)
                 (if (yes-or-no-p
                      (format "Buffer %s has been edited. Kill? " name))
                     (kill-buffer buffer))
               (kill-buffer buffer))))
          (setq list (cdr list))))
