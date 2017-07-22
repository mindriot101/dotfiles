;;; Init file

;;; Defaults
(blink-cursor-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(dolist (m '(tooltip-mode tool-bar-mode scroll-bar-mode))
  (when (fboundp m) (funcall m -1)))
(show-paren-mode 1)
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-buffer-file-coding-system 'utf-8)
(set-default 'truncate-lines nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse t)
(setq default-show-trailing-whitespace t)
(setq tramp-default-method "sshx")
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Enable nicer window moving
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Disable visual bell
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; If computer specific file exists, source it
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; Package loading is handled through use-package
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  (use-package cl))

(setq use-package-always-ensure t)

;;; OSX
(when (eq system-type 'darwin)

  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'meta)

  (if (boundp 'mac-auto-operator-composition-mode)
      (mac-auto-operator-composotion-mode))

  (set-face-attribute 'default nil :family "Source Code Pro")

  (set-face-attribute 'default nil :height 120)

  (setq-default locate-command "mdfind")

  ;; Toggle fullscreen mode
  (global-set-key [m-return] 'toggle-frame-fullscreen)

  (when (display-graphic-p)
    (setq-default mac-emulate-three-button-mouse t)
    (global-set-key (kbd "M-`") 'other-frame)))

;; Get correct path from system shell
(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  (setq exec-path-from-shell-arguments '("-l" "-i"))
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "RUST_SRC_PATH"))

;; Editorconfig
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; fzf
(use-package fzf
  :commands fzf)

;; flycheck
(use-package flycheck
  :commands global-flycheck-mode
   :init
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; Magit
(use-package magit
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-diff-refine-hunk t))

;; Completion
(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-tooltip-align-annotations t))

;; Markdown
(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package csharp-mode
  :mode (("\\.cs\\'" . csharp-mode)))

(use-package rust-mode
  :mode "\\.rs\\'"
  :bind (("C-c C-t" . cargo-process-check)
         ("C-c C-w" . cargo-process-test)
         ("C-c C-r" . cargo-process-run))
  :config
  (setq rust-format-on-save t)
  (use-package flycheck-rust
    :after flycheck
    :commands flycheck-rust-setup
    :init
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(use-package racer
  :commands racer-mode
  :init
  (add-hook 'rust-mode-hook 'racer-mode)
  :bind (:map rust-mode-map
	      ("M-." . racer-find-definition))
  :config
  (setq racer-rust-src-path "~/.cargo/rust-src/src")
  (racer-turn-on-eldoc)
  (use-package company-racer
    :config
    (add-to-list 'company-backends 'company-racer)
    (setq company-tooltip-align-annotations t)
    :bind (:map rust-mode-map
		("M-." . racer-find-definition))))

(use-package cargo
  :commands cargo-minor-mode
  :init
  (add-hook 'rust-mode-hook 'cargo-minor-mode))

(use-package toml-mode
  :mode (("\\.toml\\'" . toml-mode)))

;; Configure C family of xlanguages
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq c-indent-level 4 c-basic-offset 4 c-default-style "linux")
	    (font-lock-add-keywords nil
				    '(("\\<\\(FIXME\\):" 1 font-lock-warning-face t)))))

;; Erlang languages
(use-package erlang)
(use-package elixir-mode
  :config
  (use-package alchemist))


;; Python
(use-package elpy
  :commands elpy-enable
  :init
  (with-eval-after-load 'python
    (elpy-enable))
  :config
  (setq-default flycheck-flake8-maximum-line-length 100)
  (setq elpy-rpc-backend "jedi")
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules)))

(use-package ein
  :defer t)

;; Lua
(use-package lua-mode)

;; Evil mode (Woo vim!)
; (use-package evil
;   :config
;   (evil-mode t)
;   (use-package evil-nerd-commenter)
;   (use-package evil-leader
;     :config
;     (global-evil-leader-mode)
;     (evil-leader/set-leader ","))
;   (use-package evil-magit))

;; Ivy completion
(use-package ivy
  :config
  (ivy-mode 1))

(use-package cider)

;; Use emacs shell
(defun eshell-here ()
  "Opens a new eshell in the current buffers cwd."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))
    (insert (concat "ls"))
    (eshell-send-input)))

(global-set-key (kbd "C-!") 'eshell-here)

(defun eshell/x ()
  "Close the eshell from eshell."
  (interactive)
  (insert "exit")
  (eshell-send-input)
  (delete-window))

;; Theming
(load-theme 'wombat)

(provide 'init)
;;; init.el ends here
