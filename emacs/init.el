(setq make-backup-files nil)
(setq-default indent-tabs-mode nil)
(setq x-select-enable-clipboard t)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;------------------------------------------------------------------------------
;; Set load path
;;------------------------------------------------------------------------------
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (let* ((my-lisp-dir "~/.emacs.d/site-lisp/")
        (default-directory my-lisp-dir))
        (setq load-path (cons my-lisp-dir load-path))
        (normal-top-level-add-subdirs-to-load-path)))

;;------------------------------------------------------------------------------
;; Uniquify
;;------------------------------------------------------------------------------
(require 'uniquify)

;;------------------------------------------------------------------------------
;; Custom set variables
;;------------------------------------------------------------------------------
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(c-insert-tab-function (quote tab-to-tab-stop))
 '(c-offsets-alist (quote ((substatement . 0) (substatement-open . 0) (substatement-label . 0))))
 '(ecb-options-version "2.40")
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))

;;------------------------------------------------------------------------------
;; ECB
;;------------------------------------------------------------------------------
;; (require 'ecb)

;;------------------------------------------------------------------------------
;; Theme
;;------------------------------------------------------------------------------
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'solarized-dark t)

;;------------------------------------------------------------------------------
;; Haskell Mode
;;------------------------------------------------------------------------------
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;;------------------------------------------------------------------------------
;; YASnippet
;;------------------------------------------------------------------------------
(add-to-list 'load-path "/usr/share/emacs/site-lisp/yas")
(require 'yasnippet)
;; (yas/initialize)
(yas/load-directory "/usr/share/emacs/site-lisp/yas/snippets")

;;------------------------------------------------------------------------------
;; Org-Mode
;;------------------------------------------------------------------------------
(require 'org-install)

;;------------------------------------------------------------------------------
;; Evil-Mode
;;------------------------------------------------------------------------------
(require 'evil)
(evil-mode 1)
(setq evil-default-cursor t)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
