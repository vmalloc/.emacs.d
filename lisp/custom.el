;;; custom.el --- customize stuff
;;; Commentary:
;;; Code:

(add-to-list 'load-path "~/.emacs.d/packages/tomorrow-theme/GNU Emacs")
(add-to-list 'custom-theme-load-path "~/.emacs.d/packages/tomorrow-theme/GNU Emacs")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-revert-verbose nil)
 '(blink-cursor-mode t)
 '(c-basic-offset 4)
 '(c-default-style "bsd")
 '(comment-padding nil)
 '(company-backends
   (quote
    (company-elisp company-bbdb company-nxml company-css company-eclim company-xcode company-cmake
                   (company-dabbrev-code company-gtags company-keywords)
                   company-oddmuse company-files company-dabbrev)))
 '(company-idle-delay 0)
 '(company-minimum-prefix-length 2)
 '(cua-enable-cua-keys nil)
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (tomorrow-night-bright)))
 '(custom-safe-themes
   (quote
    ("5ee12d8250b0952deefc88814cf0672327d7ee70b16344372db9460e9a0e3ffc" default)))
 '(dabbrev-case-replace nil)
 '(default-frame-alist (quote ((font . "Ubuntu Mono 12"))))
 '(desktop-save-mode t)
 '(diff-switches "-u")
 '(dired-isearch-filenames t)
 '(doc-view-continuous t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(eldoc-idle-delay 0.1)
 '(electric-layout-mode t)
 '(emmet-indentation 2)
 '(emmet-preview-default nil)
 '(fill-column 80)
 '(flycheck-clang-language-standard "c++1y")
 '(flyspell-auto-correct-binding [(control 39)])
 '(frame-background-mode (quote dark))
 '(glasses-separate-parentheses-p nil)
 '(glasses-uncapitalize-p t)
 '(global-auto-complete-mode t)
 '(global-auto-revert-mode t)
 '(global-auto-revert-non-file-buffers t)
 '(global-ede-mode t)
 '(global-hl-line-mode t)
 '(global-visual-line-mode t)
 '(guide-key/guide-key-sequence
   (quote
    ("C-x r" "C-x v" "C-x 8" "C-c p" "C-c C-a" "C-c C-b" "C-c C-c" "C-c C-e" "C-c C-s" "C-c C-t")))
 '(guide-key/idle-delay 0.0)
 '(guide-key/popup-window-position (quote bottom))
 '(guide-key/recursive-key-sequence-flag t)
 '(helm-M-x-fuzzy-match t)
 '(helm-ff-transformer-show-only-basename nil)
 '(helm-move-to-line-cycle-in-source t)
 '(helm-swoop-speed-or-color t)
 '(helm-yank-symbol-first t)
 '(highlight-symbol-idle-delay 0)
 '(history-length 500)
 '(ibuffer-expert t)
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
           (name 25 25 :left :elide)
           " "
           (size 6 -1 :right)
           " "
           (mode 10 10 :left :elide)
           " "
           (filename-and-process -1 60 :left :elide))
     (mark " "
           (name 30 -1)
           " " filename))))
 '(ibuffer-show-empty-filter-groups nil)
 '(ido-enable-flex-matching t)
 '(ido-everywhere t)
 '(ido-max-prospects 128)
 '(ido-mode (quote both) nil (ido))
 '(ido-use-faces nil)
 '(imenu-auto-rescan t)
 '(indent-tabs-mode nil)
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(inhibit-startup-echo-area-message (user-login-name))
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(kill-whole-line t)
 '(lazy-highlight-initial-delay 0)
 '(mouse-wheel-progressive-speed nil)
 '(org-export-latex-listings (quote minted))
 '(org-export-latex-packages-alist (quote (("" "minted" nil))))
 '(org-replace-disputed-keys t)
 '(org-src-fontify-natively t)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/"))))
 '(package-check-signature nil)
 '(projectile-use-git-grep t)
 '(recentf-max-saved-items 1000)
 '(recentf-mode t)
 '(save-place t nil (saveplace))
 '(scroll-bar-mode nil)
 '(scroll-conservatively 10000)
 '(scroll-margin 5)
 '(scroll-preserve-screen-position t)
 '(semantic-default-submodes
   (quote
    (global-semantic-idle-scheduler-mode global-semanticdb-minor-mode)))
 '(semantic-mode t)
 '(show-paren-delay 0)
 '(show-paren-mode t)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(undo-tree-auto-save-history t)
 '(undo-tree-history-directory-alist (quote (("." . "~/.emacs.d/undodir"))))
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(uniquify-separator ":")
 '(visual-order-cursor-movement t)
 '(winner-mode t nil (winner)))

(setq ido-ignore-buffers `("^\\*.*\\*$" . ,ido-ignore-buffers))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "#eaeaea")))))

;;; custom.el ends here
