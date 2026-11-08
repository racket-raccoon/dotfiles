;; Set up package.el, add MELPA, and prefer GNU ELPA for Org.
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-pinned-packages '(org . "gnu") t)
(package-initialize)

;; Settings saved through Emacs Customize, including agenda files,
;; LOGBOOK drawers for Org logs, and the package list for bootstrapping.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files '("~/org/learning.org"))
 '(org-log-into-drawer t)
 '(package-selected-packages '(evil evil-org magit org org-roam)))

;; Face settings saved through Customize (currently none).
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; On a new machine, install or upgrade Org and the selected packages.
(defun my/bootstrap-packages ()
  "Install selected packages and the GNU ELPA version of Org.
Run this from a clean Emacs process before opening an Org file."
  (interactive)
  (when (featurep 'org)
    (user-error "Run package bootstrap before opening an Org file"))
  (package-refresh-contents)
  (if (assq 'org package-alist)
      (package-upgrade 'org)
    (let ((package-install-upgrade-built-in t))
      (package-install 'org)))
  (package-install-selected-packages t))

;; Enable Vim keys and two Space-leader shortcuts when Evil is installed.
;; A copied init.el can load before packages are bootstrapped.
(when (package-installed-p 'evil)
  (require 'evil)
  (evil-mode 1)
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>fr") #'recentf-open)
  (evil-define-key 'normal 'global (kbd "<leader>:") #'execute-extended-command))

;; Use Org-aware Evil keys in Org files and agenda buffers.
(when (package-installed-p 'evil-org)
  (use-package evil-org
    :after org
    :hook (org-mode . evil-org-mode)
    :config
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys)))

;; Start calendar weeks on Monday.
(setq calendar-week-start-day 1)

;; Global Org shortcuts: store a link, open the agenda, and capture.
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Wrap Org text at word boundaries and show relative line numbers there.
(setq display-line-numbers-type 'relative)
(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook #'display-line-numbers-mode)

;; Remember recently opened files for the Space f r shortcut.
(recentf-mode 1)
