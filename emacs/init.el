(setq make-backup-files nil)

;;==============================================================================
;; Set load path
;;==============================================================================
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (let* ((my-lisp-dir "~/.emacs.d/site-lisp/")
        (default-directory my-lisp-dir))
        (setq load-path (cons my-lisp-dir load-path))
        (normal-top-level-add-subdirs-to-load-path)))

;;==============================================================================
;; Color Theme
;;
;; Color Theme Tango 2
;; 05ed82ef54947c8830e77c147a57f9325e833378
;; http://github.com/wfarr/color-theme-tango-2/
;;==============================================================================
(require 'color-theme)
(require 'color-theme-tango-2)
(add-to-list 'color-themes '(color-theme-tango-2 "Tango 2"
                             "Will Farrington <will@railsmachine.com>"))
(eval-after-load "color-theme" '(color-theme-tango-2))

;;==============================================================================
;; Haskell Mode
;;==============================================================================
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;;==============================================================================
;; YASnippet
;;==============================================================================
(yas/initialize)
(yas/load-directory "/usr/share/emacs/etc/yasnippet/snippets")
