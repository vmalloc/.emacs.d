;;; init.el --- emacs config -*- lexical-binding: t; byte-compile-warnings: (not unresolved) -*-
;;; Commentary:
;;; Code:

(let ((gc-cons-threshold-original gc-cons-threshold)
      (file-name-handler-alist-original file-name-handler-alist))
  (run-with-idle-timer 0 nil (lambda () (setq inhibit-message nil
                                              file-name-handler-alist file-name-handler-alist-original
                                              gc-cons-threshold gc-cons-threshold-original))))

(setq gc-cons-threshold (* 100 1024 1024)
      file-name-handler-alist nil
      inhibit-message t
      load-prefer-newer t
      custom-file "~/.emacs.d/custom.el"
      package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (defvar use-package-enable-imenu-support)
  (setq use-package-enable-imenu-support t)
  (require 'use-package)
  (require 'bind-key))

(push "~/.emacs.d/lisp" load-path)

(require 'config-defuns-autoloads)
(require 'config-looks)

(defgroup my/customizations nil
  "Customizations"
  :group 'convenience)

(defcustom my/restricted-resources nil
  "Avoid using resource-demanding packages, which might lead to parformance degradation."
  :type 'boolean
  :group 'my/customizations)

(bind-key "<escape>" #'keyboard-escape-quit)
(bind-key "C-x r q" #'save-buffers-kill-emacs)
(unbind-key "C-x C-c")
(bind-key "<f5>" #'my/revert-buffer-no-confirmation)
(bind-key "M-<f9>" #'vc-revision-other-window)
(bind-key "<f11>" #'toggle-frame-fullscreen)
(bind-key "S-<f11>" #'whitespace-cleanup)
(bind-key "C-<f12>" #'my/magit-status-config-project)

(bind-key "C-<delete>" #'kill-word)
(bind-key "M-SPC" #'cycle-spacing)

(bind-key "C-<tab>" #'previous-buffer)
(bind-key "<mouse-8>" #'previous-buffer)
(bind-key "C-S-<iso-lefttab>" #'next-buffer)
(bind-key "<mouse-9>" #'next-buffer)

(bind-key "C-`" #'pop-to-mark-command)
(bind-key "C-M-`" #'pop-global-mark)

(bind-key "C-z" #'repeat)
(unbind-key "C-x C-z")
(bind-key "C-!" #'kill-this-buffer)
(bind-key "C-M-!" #'my/kill-buffer-other-window)

(bind-key "C-c C-<return>" #'delete-blank-lines)
(bind-key "C-c d" #'my/diff-current-buffer-with-file)
(bind-key "C-c C-;" #'my/toggle-comment-line-or-region)
(bind-key "M-s M-s" #'sort-lines)

(bind-key "C-+" #'my/increment-number-at-point)
(bind-key "C-M-+" #'my/decrement-number-at-point)

(bind-key "C-x n r" #'narrow-to-region)
(bind-key "C-x n n" #'my/narrow-or-widen-dwim)

(bind-key [remap goto-line] #'my/goto-line-with-feedback)

(bind-key "M-p" #'my/scroll-down)
(bind-key "M-n" #'my/scroll-up)

(bind-key "M-z" #'my/zap-up-to-char)
(bind-key "M-Z" #'zap-to-char)

(when (eq system-type 'darwin)
  (use-package exec-path-from-shell
    :ensure
    :config (exec-path-from-shell-initialize)))

(use-package paradox
  :ensure
  :bind (("C-x p" . paradox-upgrade-packages))
  :config
  (setq paradox-github-token t))

(use-package mwim
  :ensure
  :bind (("<home>" . mwim-beginning)
         ("<end>" . mwim-end)))

(use-package misc
  :bind ("C-$" . copy-from-above-command))

(use-package windmove
  :bind (("M-<left>" . windmove-left)
         ("M-<right>" . windmove-right)
         ("M-<up>" . windmove-up)
         ("M-<down>" . windmove-down)))

(use-package hydra
  :ensure
  :bind ("<f8>" . my/hydra-error/body)
  :config (defhydra my/hydra-error ()
            "goto-error"
            ("P" first-error "first")
            ("n" next-error "next")
            ("p" previous-error "prev")
            ("v" recenter-top-bottom "recenter")
            ("q" nil "quit")))

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(advice-add #'split-window-right :after #'my/balance-windows)
(advice-add #'split-window-below :after #'my/balance-windows)
(advice-add #'delete-window :after #'my/balance-windows)

(advice-add #'yank :after #'my/indent-yanked-region)
(advice-add #'yank-pop :after #'my/indent-yanked-region)

(fset #'yes-or-no-p #'y-or-n-p)

(remove-hook 'kill-buffer-query-functions #'process-kill-buffer-query-function)

(defun display-startup-echo-area-message () ".")

(setq auto-save-default nil
      auto-window-vscroll nil
      backup-directory-alist `((".*" . ,temporary-file-directory))
      comment-padding nil
      confirm-kill-processes nil
      diff-switches "-u"
      disabled-command-function nil
      history-length 500
      indicate-buffer-boundaries 'left
      indicate-empty-lines t
      inhibit-startup-screen t
      initial-scratch-message nil
      kill-whole-line t
      large-file-warning-threshold (* 100 1024 1024)
      mouse-wheel-progressive-speed nil
      resize-mini-windows t
      ring-bell-function 'ignore
      scroll-conservatively 10000
      scroll-margin 5
      scroll-preserve-screen-position t
      )

(setq-default comment-column 0
              fill-column 100
              fringes-outside-margins t
              indent-tabs-mode nil
              tab-width 4
              cursor-type 'bar
              )

(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

(use-package hl-line
  :config (global-hl-line-mode 1))

(use-package saveplace
  :config (save-place-mode 1))

(use-package calendar
  :defer
  :config (setq calendar-weekend-days '(5 6)))

(use-package compile
  :defer
  :hook (compilation-filter . my/colorize-compilation-buffer)
  :config (setq compilation-scroll-output 'first-error
                compilation-read-command nil))

(use-package ediff
  :defer
  :config (setq ediff-split-window-function 'split-window-horizontally))

(use-package doc-view
  :defer
  :config (setq doc-view-continuous t
                doc-view-resolution 300))

(use-package dired
  :config (setq dired-recursive-deletes 'always))

(use-package dired-aux
  :defer
  :config (setq dired-isearch-filenames t))

(use-package dired-x
  :hook (dired-mode . dired-omit-mode))

(use-package org
  :bind (("<f10>" . org-agenda)
         ("C-<f10>" . org-capture))
  :hook (org-mode . my/org-mode-hook)
  :config
  (setq org-replace-disputed-keys t
        org-src-fontify-natively t
        org-startup-indented t))

(use-package org-bullets
  :ensure
  :hook (org . org-bullets-mode))

(use-package ox-html
  :defer
  :config (setq org-html-postamble nil))

(use-package glasses
  :defer
  :config (setq glasses-separate-parentheses-p nil
                glasses-uncapitalize-p t))

(use-package imenu
  :defer
  :config (setq imenu-auto-rescan t))

(use-package tramp
  :defer
  :config (setq tramp-use-ssh-controlmaster-options nil
                tramp-default-method "scpx"
                tramp-histfile-override "/dev/null"))

(use-package uniquify
  :defer
  :config (setq uniquify-buffer-name-style 'post-forward
                uniquify-separator ":"))

(use-package server
  :if window-system
  :config (server-start))

(use-package autorevert
  :config
  (setq auto-revert-verbose nil
        global-auto-revert-non-file-buffers t)
  (global-auto-revert-mode 1))

(use-package beginend
  :ensure
  :config (beginend-global-mode 1))

(use-package bln-mode
  :ensure
  :bind (("M-[" . bln-backward-half)
         ("M-]" . bln-forward-half)))

(use-package crux
  :ensure
  :bind (("M-<return>" . crux-smart-open-line)
         ("M-S-<return>" . crux-smart-open-line-above)
         ("<f12>" . crux-cleanup-buffer-or-region)
         ("S-<f12>" . crux-find-user-init-file)
         ("C-S-<backspace>" . crux-kill-whole-line)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c C-e" . crux-eval-and-replace)
         ("C-c C-r" . crux-transpose-windows)
         ("C-^" . crux-top-join-line)))

(use-package recentf
  :config
  (setq recentf-max-saved-items 1000)
  (recentf-mode 1))

(use-package prescient
  :ensure
  :config (prescient-persist-mode 1))

(use-package wgrep
  :ensure
  :defer
  :config (setq wgrep-auto-save-buffer t))

(use-package ivy
  :ensure
  :demand
  :bind (("C-c C-s". ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window)
         :map ivy-minibuffer-map
         ("<return>" . ivy-alt-done)
         ("C-j" . ivy-done))
  :config
  (setq ivy-use-virtual-buffers t
        ivy-use-selectable-prompt t
        ivy-virtual-abbreviate 'full
        ivy-count-format "(%d/%d) "
        ivy-extra-directories '("./")
        ivy-re-builders-alist '((t . ivy--regex-ignore-order))
        ivy-initial-inputs-alist nil)
  (push '(emacs-lisp-mode . swiper-match-face-1) ivy-switch-buffer-faces-alist)
  (push '(python-mode . swiper-match-face-2) ivy-switch-buffer-faces-alist)
  (push '(c++-mode . swiper-match-face-3) ivy-switch-buffer-faces-alist)
  (ivy-mode 1))

(use-package ivy-hydra
  :ensure
  :bind (:map ivy-minibuffer-map
              ("M-o" . ivy-dispatching-done-hydra)))

(use-package ivy-prescient
  :ensure
  :after ivy
  :config
  (setq ivy-prescient-retain-classic-highlighting t)
  (ivy-prescient-mode 1))

(use-package ivy-rich
  :ensure
  :after ivy
  :config
  (setq ivy-rich-path-style 'abbrev
        ivy-rich-switch-buffer-align-virtual-buffer t)
  (ivy-rich-mode 1))

(use-package counsel
  :ensure
  :after ivy
  :bind (("C-s" . counsel-grep-or-swiper)
         ("C-x y" . counsel-yank-pop)
         ("C-x C-r" . counsel-recentf)
         ("M-i" . counsel-imenu)
         ("C-c a" . counsel-rg)
         ("C-c u" . counsel-unicode-char)
         :map counsel-mode-map
         ([remap pop-to-mark-command] . nil)
         ([remap describe-key] . nil)
         ([remap describe-function] . nil)
         ([remap describe-variable] . nil)
         ([remap describe-symbol] . nil))
  :config
  (setq counsel-find-file-ignore-regexp (concat
                                         ;; file names beginning with # or .
                                         "\\(?:\\`[#.]\\)"
                                         ;; file names ending with # or ~
                                         "\\|\\(?:[#~]\\'\\)")
        counsel-rg-base-command "rg -S --no-heading --line-number --color never %s"
        counsel-grep-base-command "rg -S --no-heading --line-number --color never %s %s")
  (counsel-mode 1))

(use-package swiper
  :ensure
  :defer)

(use-package cua-base
  :bind (:map cua-global-keymap
              ("C-<return>" . nil))
  :demand
  :config
  (setq cua-enable-cua-keys nil)
  (cua-mode 1))

(use-package paren
  :config (show-paren-mode 1))

(use-package flycheck
  :ensure
  :bind ("M-<f8>" . flycheck-list-errors)
  :hook ((prog-mode . flycheck-mode) (flycheck-mode . my/use-eslint-from-node-modules))
  :config
  (setq flycheck-indication-mode 'right-fringe
        flycheck-emacs-lisp-load-path 'inherit)
  (when window-system
    (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
      (vector #b00010000
              #b00110000
              #b01110000
              #b11110000
              #b01110000
              #b00110000
              #b00010000))))

(use-package flyspell
  :hook (rst-mode . flyspell-mode))

(use-package prog-mode
  :hook (prog-mode . my/prog-mode-hook))

(use-package eldoc
  :hook (emacs-lisp-mode . eldoc-mode))

(use-package lispy
  :ensure
  :hook ((emacs-lisp-mode . lispy-mode))
  :bind (:map lispy-mode-map-lispy
              ("M-i" . nil)
              ("C-," . nil)
              ("<M-left>" . nil)
              ("<M-right>" . nil)))

(use-package macrostep
  :ensure
  :bind (:map emacs-lisp-mode-map
              ("C-c e" . macrostep-expand)))

(use-package suggest
  :ensure
  :defer)

(use-package cc-mode
  :mode ("\\.x\\'" . c++-mode)
  :bind (:map c-mode-base-map
              ("C-c o" . ff-get-other-file)
              ("C-c f" . my/maybe-clang-format-buffer)
              ("C-c i a" . my/insert-all-special)
              ("C-c i c" . my/insert-default-ctor)
              ("C-c i d" . my/insert-virtual-dtor)
              ("C-c i p" . my/insert-copy-ctor)
              ("C-c i P" . my/insert-copy-assignment-operator)
              ("C-c i m" . my/insert-move-ctor)
              ("C-c i M" . my/insert-move-assignment-operator))
  :hook (c-mode-common . my/c-mode-common-hook)
  :config (setq c-basic-offset 4
                c-default-style "bsd"))

(use-package rtags
  :ensure
  :hook ((c-mode-common . rtags-start-process-unless-running))
  :bind (:map c-mode-base-map
              ("M-." . rtags-find-symbol-at-point)
              ("M-i" . rtags-imenu))
  :config
  (setq rtags-autostart-diagnostics t
        rtags-completions-enabled t
        rtags-display-result-backend 'ivy)
  (rtags-enable-standard-keybindings))

(use-package ivy-rtags
  :ensure
  :after rtags)

(use-package company-rtags
  :ensure
  :after company
  :config (add-to-list 'company-backends 'company-rtags))

(use-package flycheck-rtags
  :ensure
  :after rtags)

(use-package clang-format
  :ensure
  :defer)

(use-package python
  :mode (("SCons\\(truct\\|cript\\)\\'" . python-mode)
         ("slashrc\\'" . python-mode))
  :bind (:map python-mode-map
              ("C-<f8>" . my/pylint-ignore-errors-at-point)
              ("C-c C-f" . nil))
  :config
  (advice-add #'python-indent-shift-left :around #'my/python-shift-region)
  (advice-add #'python-indent-shift-right :around #'my/python-shift-region))

(use-package py-isort
  :ensure
  :after python
  :commands py-isort-buffer
  :bind (:map python-mode-map
              ("C-c i" . my/python-insert-import)
              ("C-c I" . my/py-isort-buffer))
  :config (setq py-isort-options '("-ds" "-ca")))

(use-package pyvenv
  :ensure
  :hook (hack-local-variables . my/pyvenv-activate))

(use-package anaconda-mode
  :ensure
  :hook (python-mode (python-mode . anaconda-eldoc-mode)))

(use-package company-anaconda
  :ensure
  :hook (anaconda-mode . my/company-anaconda-setup))

(use-package pipenv
  :ensure
  :hook (python-mode . pipenv-mode)
  :custom (pipenv-keymap-prefix (kbd "C-c C-e")))

(use-package go-mode
  :ensure
  :defer)

(use-package rust-mode
  :ensure
  :defer
  :bind (:map rust-mode-map
              ("C-c C-f" . nil)
              ("C-c P" . rust-promote-module-into-dir)
              ("C-c m" . my/rust-toggle-mut))
  :config (setq rust-format-on-save t))

(use-package flycheck-rust
  :ensure
  :after rust-mode
  :hook (flycheck-mode . flycheck-rust-setup))

(use-package racer
  :ensure
  :hook ((rust-mode . racer-mode)
         (racer-mode . eldoc-mode))
  :bind (:map rust-mode-map
              ("C-c h" . racer-describe)))

(use-package yaml-mode
  :ensure
  :defer)

(use-package cmake-font-lock
  :ensure
  :defer)

(use-package cmake-mode
  :ensure
  :hook (cmake-mode . cmake-font-lock-activate))

(use-package hippie-exp
  :bind ("M-/" . hippie-expand)
  :config (setq hippie-expand-try-functions-list '(yas-hippie-try-expand
                                                   try-expand-dabbrev
                                                   try-expand-dabbrev-all-buffers
                                                   try-expand-dabbrev-from-kill
                                                   try-complete-file-name-partially
                                                   try-complete-file-name
                                                   try-expand-all-abbrevs
                                                   try-complete-lisp-symbol-partially
                                                   try-complete-lisp-symbol
                                                   )))

(use-package avy
  :ensure
  :bind ("s-s" . avy-goto-word-or-subword-1))

(use-package company
  :ensure
  :config
  (setq company-minimum-prefix-length 2
        company-backends (delete 'company-clang company-backends)
        company-global-modes '(not eshell-mode)
        company-tooltip-align-annotations t)
  (global-company-mode 1))

(use-package company-prescient
  :ensure
  :config (company-prescient-mode 1))

(use-package conf-mode
  :mode "\\.pylintrc\\'"
  :mode ("Pipfile\\'" . conf-toml-mode)
  :hook (conf-mode . my/conf-mode-hook))

(use-package deadgrep
  :ensure
  :bind ("<f6>" . deadgrep))

(use-package diff-hl
  :if (not my/restricted-resources)
  :ensure
  :demand
  :bind ("C-]" . my/hydra-diff-hl/body)
  :hook ((dired-mode . diff-hl-dired-mode) (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (defhydra my/hydra-diff-hl (:hint nil)
    "git-gutter"
    ("]" diff-hl-next-hunk "next")
    ("[" diff-hl-previous-hunk "previous")
    ("r" diff-hl-revert-hunk "revert")
    ("q" nil "quit"))
  (setq diff-hl-fringe-bmp-function
        (lambda (type _pos) (if (eq type 'delete) 'diff-hl-bmp-delete 'diff-hl-bmp-change)))
  (defun diff-hl-define-bitmaps ()
    (unless (fringe-bitmap-p 'diff-hl-bmp-delete)
      (define-fringe-bitmap 'diff-hl-bmp-delete
        (vector #b10000000
                #b11000000
                #b11100000
                #b11110000)
        nil nil 'bottom)
      (define-fringe-bitmap 'diff-hl-bmp-change
        (vector #b11100000)
        nil nil '(center t))))
  (global-diff-hl-mode 1))

(use-package discover-my-major
  :ensure
  :bind ("C-h <return>" . discover-my-major))

(use-package dockerfile-mode
  :ensure
  :defer)

(use-package drag-stuff
  :ensure
  :bind (("M-S-<up>" . drag-stuff-up)
         ("M-S-<down>" . drag-stuff-down)
         ("M-S-<left>" . drag-stuff-left)
         ("M-S-<right>" . drag-stuff-right))
  :hook (drag-stuff-after-drag . my/indent-line-or-region))

(use-package easy-kill
  :ensure
  :bind ([remap kill-ring-save] . easy-kill))

(use-package emmet-mode
  :ensure
  :hook (sgml-mode web-mode)
  :config (setq emmet-indentation 2
                emmet-preview-default nil))

(use-package expand-region
  :ensure
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)))

(use-package eyebrowse
  :ensure
  :config
  (setq eyebrowse-wrap-around t
        eyebrowse-new-workspace t)
  (eyebrowse-mode 1))

(use-package gitignore-mode
  :ensure
  :defer)

(use-package helpful
  :ensure
  :bind (([remap describe-key] . helpful-key)
         ([remap describe-function] . helpful-callable)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-symbol] . helpful-symbol)))

(use-package highlight-symbol
  :ensure
  :bind (("C-\"" . highlight-symbol-at-point)
         ("C-," . highlight-symbol-prev)
         ("C-." . highlight-symbol-next))
  :config (setq highlight-symbol-colors '("highlight")))

(use-package highlight-parentheses
  :ensure
  :config (global-highlight-parentheses-mode 1))

(use-package highlight-indent-guides
  :ensure
  :hook (prog-mode . highlight-indent-guides-mode)
  :config (setq highlight-indent-guides-method 'character
                highlight-indent-guides-responsive 'stack))

(use-package volatile-highlights
  :ensure
  :config (volatile-highlights-mode 1))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  :config
  (setq ibuffer-expert t
        ibuffer-formats '((mark modified read-only " "
                                (name 25 25 :left :elide) " "
                                (size 6 -1 :right) " "
                                (mode 10 10 :left :elide) " "
                                (filename-and-process -1 60 :left :elide))
                          (mark " " (name 30 -1)
                                " " filename)))
  (add-hook 'ibuffer-mode-hook (apply-partially #'ibuffer-switch-to-saved-filter-groups "default")))

(use-package ibuf-ext
  :after ibuffer
  :config (setq ibuffer-show-empty-filter-groups nil
                ibuffer-saved-filter-groups '(("default"
                                               ("Dired" (mode . dired-mode))
                                               ("C/C++" (or
                                                         (mode . c-mode)
                                                         (mode . c++-mode)))
                                               ("Python" (mode . python-mode))
                                               ("Go" (mode . go-mode))
                                               ("Rust" (mode . rust-mode))
                                               ("Elisp" (mode . emacs-lisp-mode))
                                               ("Web" (or
                                                       (mode . sgml-mode)
                                                       (mode . web-mode)
                                                       (mode . css-mode)
                                                       (mode . js-mode)))
                                               ("Docs" (or
                                                        (mode . org-mode)
                                                        (mode . rst-mode)))
                                               ("Misc" (name . "^\\*"))
                                               ))))

(use-package magit
  :ensure
  :bind (("<f9>" . magit-status)
         ("S-<f9>" . magit-log-buffer-file)
         ("C-<f9>" . magit-blame)
         ("C-c g" . magit-dispatch-popup))
  :config
  (set-face-attribute 'magit-branch-remote nil :foreground (doom-color 'magenta))
  (setq magit-bury-buffer-function 'magit-mode-quit-window
        magit-repository-directories '(("~/dev" . 1))
        magit-tag-arguments '("--annotate")
        magit-fetch-arguments '("--prune")
        magit-log-arguments '("-n256" "--graph" "--decorate" "--show-signature")
        magit-log-section-arguments '("-n256" "--decorate" "--show-signature")
        magit-diff-refine-hunk t
        magit-section-initial-visibility-alist '((recent . show)
                                                 (unpushed . show)
                                                 (unpulled . show)))
  (unless (eq system-type 'darwin)
    (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))
  (remove-hook 'magit-pre-display-buffer-hook #'magit-save-window-configuration)
  (magit-add-section-hook 'magit-status-sections-hook
                          #'magit-insert-recent-commits
                          #'magit-insert-unpushed-to-upstream-or-recent
                          'replace)
  (magit-add-section-hook 'magit-status-sections-hook #'magit-insert-modules-overview nil 'append))

(use-package magit-gitflow
  :ensure
  :hook (magit-mode . turn-on-magit-gitflow))

(use-package magithub
  :ensure
  :after magit
  :config
  (setq magithub-preferred-remote-method 'clone_url)
  (magithub-feature-autoinject t))

(use-package git-commit
  :config
  (setq git-commit-summary-max-length fill-column)
  (global-git-commit-mode 1))

(use-package git-link
  :ensure
  :bind (("C-c G h" . git-link-homepage)
         ("C-c G c" . git-link-commit)
         ("C-c G l" . git-link)
         ("C-c G H" . my/git-link-homepage-in-browser)))

(use-package man
  :bind ("<f1>" . man)
  :config
  (set-face-attribute 'Man-overstrike nil :inherit 'font-lock-keyword-face)
  (setq Man-notify-method 'pushy))

(use-package markdown-mode
  :ensure
  :mode ("README\\.md\\'" . gfm-mode)
  :hook ((markdown-mode . auto-fill-mode)
         (markdown-mode . flyspell-mode))
  :config (setq markdown-command "cmark"))

(use-package sh-mode
  :mode ("PKGBUILD\\'" . shell-script-mode))

(use-package fish-mode
  :ensure
  :defer)

(use-package multiple-cursors
  :ensure
  :bind (("C-|" . mc/edit-lines)
         ("C-;" . mc/mark-all-like-this-dwim)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-:" . my/hydra-multiple-cursors/body))
  :config (defhydra my/hydra-multiple-cursors (:hint nil)
            "
^Up^           ^Down^         ^Miscellaneous^
---------------------------------------------
_p_:   Next    _n_:   Next    _l_: Edit lines
_P_:   Skip    _N_:   Skip    _a_: Mark all
_M-p_: Unmark  _M-n_: Unmark  _q_: Quit"
            ("l" mc/edit-lines :exit t)
            ("a" mc/mark-all-like-this-dwim :exit t)
            ("n" mc/mark-next-like-this)
            ("N" mc/skip-to-next-like-this)
            ("M-n" mc/unmark-next-like-this)
            ("p" mc/mark-previous-like-this)
            ("P" mc/skip-to-previous-like-this)
            ("M-p" mc/unmark-previous-like-this)
            ("q" nil)))

(use-package popwin
  :ensure
  :commands (popwin:display-buffer-condition popwin:display-buffer-action)
  :init (push '(popwin:display-buffer-condition popwin:display-buffer-action) display-buffer-alist)
  :config
  (push '("*Flycheck errors*" :stick t) popwin:special-display-config))

(use-package projectile
  :ensure
  :demand
  :bind (("C-c C-f" . projectile-find-file)
         ("<f7>" . projectile-compile-project)
         ("<C-f7>" . projectile-test-project)
         :map projectile-mode-map
         ("C-c p" . projectile-command-map))
  :config
  (projectile-register-project-type 'rust-cargo '("Cargo.toml")
                                    :compile "cargo check"
                                    :test "cargo test")
  (setq projectile-completion-system 'ivy)
  (fset #'projectile-kill-buffers #'my/projectile-kill-buffers)
  (advice-add #'projectile-switch-project :around #'my/projectile-disable-remove-current-project)
  (projectile-mode 1))

(use-package counsel-projectile
  :ensure
  :config
  (cl-delete-if (lambda (x) (string= (car x) "si")) counsel-projectile-key-bindings)
  (push '("s" . counsel-projectile-rg) counsel-projectile-key-bindings)
  (ivy-set-actions 'counsel-projectile-switch-project
                   '(("s" counsel-projectile-switch-project-action-rg "search project with rg")))
  (counsel-projectile-mode 1))

(use-package rainbow-delimiters
  :ensure
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package restclient
  :ensure
  :mode ("\\.http\\'" . restclient-mode))

(use-package syntax-subword
  :ensure
  :config (global-syntax-subword-mode 1))

(use-package systemd
  :ensure
  :defer)

(use-package undo-tree
  :ensure
  :config (global-undo-tree-mode 1))

(use-package web-mode
  :ensure
  :mode "\\.hbs\\'"
  :mode "\\.html\\'"
  :config (setq web-mode-code-indent-offset 2
                web-mode-markup-indent-offset 2
                web-mode-css-indent-offset 2
                web-mode-style-padding 2
                web-mode-script-padding 2
                web-mode-enable-auto-expanding t))

(use-package visual-regexp
  :ensure
  :defer)

(use-package js2-mode
  :ensure
  :config
  (setq js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil)
  :mode "\\.js\\'")

(use-package window-numbering
  :ensure
  :config (window-numbering-mode 1))

(use-package winner
  :config (winner-mode))

(use-package which-key
  :ensure
  :config
  (setq which-key-idle-delay 0.5)
  (which-key-mode 1))

(use-package whitespace-cleanup-mode
  :ensure
  :config (global-whitespace-cleanup-mode 1))

(use-package wrap-region
  :ensure
  :config
  (wrap-region-add-wrapper "|" "|" nil 'rust-mode)
  (wrap-region-global-mode 1))

(use-package langtool
  :ensure
  :bind (:map text-mode-map
              ("C-c l" . langtool-check)))

(use-package yasnippet
  :ensure
  :ensure yasnippet-snippets
  :demand
  :bind (:map yas-minor-mode-map
              ("TAB" . nil)
              ("<tab>" . nil))
  :config
  (setq yas-prompt-functions '(yas-completing-prompt) ; use normal completion
        yas-verbosity 1)
  (yas-global-mode 1))

(use-package ivy-yasnippet
  :ensure
  :bind ("C-M-/" . ivy-yasnippet))

;;; init.el ends here
