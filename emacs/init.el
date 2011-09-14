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
 '(c-basic-offset 4)
 '(c-insert-tab-function (quote tab-to-tab-stop))
 '(c-offsets-alist (quote ((substatement . 0) (substatement-open . 0) (substatement-label . 0))))
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))

;;------------------------------------------------------------------------------
;; ECB
;;------------------------------------------------------------------------------
;;(require 'ecb)

;;------------------------------------------------------------------------------
;; Color Theme
;;
;; Color Theme Tango 2
;; 05ed82ef54947c8830e77c147a57f9325e833378
;; http://github.com/wfarr/color-theme-tango-2/
;;------------------------------------------------------------------------------
(require 'color-theme)
(require 'color-theme-tango-2)
(add-to-list 'color-themes '(color-theme-tango-2 "Tango 2"
                             "Will Farrington <will@railsmachine.com>"))
(eval-after-load "color-theme" '(color-theme-tango-2))

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
(yas/initialize)
(yas/load-directory "/usr/share/emacs/site-lisp/yas/snippets")
