;; Packages
(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar srw/my-packages
  '(better-defaults
    flycheck ;; syntax checker
    py-autopep8
	yaml-mode
	solarized-theme
	smex
    markdown-mode
	adoc-mode
	fzf
    multi-term
	clojure-mode
	auto-complete
	cider
	paredit
	base16-theme
	magit
	ansible
	editorconfig
	evil
	evil-leader
	evil-commentary
	jinja2-mode
	ir-black-theme))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      srw/my-packages)

;; Settings
(setq inhibit-startup-message t)
(setq visible-bell nil)

(define-key global-map (kbd "RET") 'newline-and-indent)
(global-visual-line-mode t)

;; Hooks
(add-hook 'markdown-mode-hook
		  (auto-fill-mode))

;; Disable blinking cursor
(blink-cursor-mode 0)

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Source Code Pro")
  (set-face-attribute 'default nil :height 140)

  ;; Add homebrew installed packages to load-path
  (let ((default-directory "/usr/local/share/emacs/site-lisp/"))
    (normal-top-level-add-subdirs-to-load-path))

  ;; Toggle fullscreen mode
  (global-set-key [s-return] 'toggle-frame-fullscreen)

  ;; Allow hash command
  (global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#"))))

;; Language specifics
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default tab-width 4 indent-tabs-mode t)

;; Org mode settings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/org/ngts.org"
							 "~/org/home.org"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))



;; Make sure everything is in utf-8
(set-language-environment "UTF-8")
(set-buffer-file-coding-system 'utf-8)

;; Use auto-complete mode always
(global-auto-complete-mode)

;; Use evil mode always
(global-evil-leader-mode)
(evil-mode t)
(evil-leader/set-leader ",")
(evil-leader/set-key "f" 'fzf)

;; Evil commentary
(evil-commentary-mode)

;; Set up fzf
;; Add the fzf dir to the PATH
;; (setenv "PATH" (concat
				;; (getenv "HOME") "/.fzf/bin:" (getenv "PATH")))
;; (setq exec-path
	  ;; (append
	   ;; '((concat (getenv "HOME") "/.fzf/bin") exec-path)))

;; Smex
(autoload 'smex "smex"
  "Smex is a M-x enhancement for Emacs")

(global-set-key (kbd "M-x") 'smex)

;; Open files in an existing frame instead of a new frame each time
(setq ns-pop-up-frames nil)

;; Compile bindings
(global-set-key (kbd "C-c C-k") 'compile)

;; Make sure line numbers are not on
(global-linum-mode 0)

;; Stop any bells
(setq ring-bell-function 'ignore)

;; Mouse control (BAD!)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)

;; Theming
(load-theme 'base16-tomorrow-dark t)
