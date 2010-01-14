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
;; Color Theme 6.6.0
;; http://www.nongnu.org/color-theme/
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
;; Haskell Mode 2.7.0
;; http://projects.haskell.org/haskellmode-emacs/
;;==============================================================================
;;(load-library "haskell-site-file")

;;==============================================================================
;; Python Mode 5.1.0
;; https://launchpad.net/python-mode/
;;==============================================================================
;;(autoload 'python-mode "python-mode" "Python Mode." t)
;;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;;(add-to-list 'interpreter-mode-alist '("python" . python-mode))
;;(add-hook 'python-mode-hook
;;    (lambda ()
;;        (set (make-variable-buffer-local 'beginning-of-defun-function)
;;            'py-beginning-of-def-or-class)
;;        (setq outline-regexp "def\\|class ")))

;;==============================================================================
;; YASnippet 0.6.1c
;; http://code.google.com/p/yasnippet/
;;==============================================================================
;;(require 'yasnippet)
;;(yas/initialize)
;;(yas/load-directory "~/.emacs.d/site-lisp/yasnippet/snippets")
