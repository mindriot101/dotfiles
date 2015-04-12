;; Packages

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(when (< emacs-major-version 24)
  ;; For important compatibility libraries
  (add-to-list 'package-archives
               '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Install packages
(defvar srw/my-packages '(better-defaults
                          paredit
                          magit
                          smex
                          ido-ubiquitous
                          idle-highlight-mode
                          find-file-in-project
                          multi-term
                          monokai-theme
                          ir-black-theme))

(dolist (p srw/my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Theming
(load-theme 'monokai t)

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Menlo")
  (set-face-attribute 'default nil :height 140)

  ;; Toggle fullscreen mode
  (global-set-key [s-return] 'toggle-frame-fullscreen))
