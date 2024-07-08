;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (require 'lsp-ui)
;; (add-hook 'lsp-mode-hook #'lsp-ui-mode)

;; (global-set-key (kbd "C-c i") 'symbols-outline-show)
;; (with-eval-after-load 'symbols-outline
;;   ;; By default the ctags backend is selected
;;   (unless (executable-find "ctags")
;;     ;; Use lsp-mode or eglot as backend
;;     (setq symbols-outline-fetch-fn #'symbols-outline-lsp-fetch))
;;   (setq symbols-outline-window-position 'right)
;;   (symbols-outline-follow-mode))

;; (use-package symbols-outline
;;   :ensure t
;;   :config
;;   ;; (map! :leader
;;   ;; (:prefix ("i" . "symbols-outline")
;;   ;;          "i" #'symbols-outline-show))
;;   map! :n "C-c C-i" #'symbols-outline-show

;;   (unless (executable-find "ctags")
;;     ;; Use lsp-mode or eglot as backend
;;     (setq symbols-outline-fetch-fn #'symbols-outline-lsp-fetch))
;;   (setq symbols-outline-window-position 'left)
;;   (symbols-outline-follow-mode))

;; (map! :map lsp-mode-map
;;       :n "C-c C-l" #'Custom-goto-parent)

(ac-config-default)

(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))

;; (global-set-key (kbd "C-c i") 'symbols-outline-show)
;; (with-eval-after-load 'symbols-outline
;;   ;; By default the ctags backend is selected
;;   (unless (executable-find "ctags")
;;     ;; Use lsp-mode or eglot as backend
;;     (setq symbols-outline-fetch-fn #'symbols-outline-lsp-fetch))
;;   (setq symbols-outline-window-position 'left)
;;   (symbols-outline-follow-mode))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-pine)
;; (load-theme 'doom-pine t)

(map! :leader :desc "Sample description" :n "C-c" #'aya-create)

(map! :after python
      :map python-mode-map
      :prefix "C-x C-p"
      "f" #'python-pytest-file)

(map! :after cpp
      :map cpp-mode-map
      :prefix "C-x C-p"
      "f" #'cpp-highlight-buffer)

(use-package! lsp-bridge
  :config
  (setq lsp-bridge-enable-log nil)
  (setq lsp-bridge-enable-hover-diagnostic t)
  (global-lsp-bridge-mode))

(defun vertical-split-definition ()
  "Go to definition in a vertical split."
  (interactive)
  (let ((current-window (selected-window)))
    ;; Split the window vertically
    (split-window-right)
    ;; Move to the newly created window
    (other-window 1)
    ;; Call the function to go to the definition
    (evil-goto-definition)
    ;; Switch back to the original window
    (select-window current-window)))

(defun horizontal-split-definition ()
  "Go to definition in horizontal split."
  (interactive)
  (let ((current-window (selected-window)))
    ;; Split the window horizontally
    (split-window-below)
    ;; Move to the newly created window
    (other-window 1)
    ;; Call the function to go to the definition
    (evil-goto-definition)
    ;; Switch back to the original window
    (select-window current-window)))

(map!
 :n "M-g v"
 #'vertical-split-definition)

(map!
 :n "M-g h"
 #'horizontal-split-definition)

(defun my/lsp-bridge-diagnostics-at-point ()
  "Display error message at point in a mini-buffer"
  (interactive)
  (when-let ((overlay (lsp-bridge-diagnostic-overlay-at-point)))
    (let* ((diagnostic-display-message (overlay-get overlay 'display-message))
           (diagnostic-message (overlay-get overlay 'message)))
      (message "Diagnostic display message: %s\nMessage: %s"
               diagnostic-display-message diagnostic-message)
      ))
  (message "No diagnostic found"))

(global-set-key (kbd "C-c d") 'my/lsp-bridge-diagnostics-at-point)

(setq debug-on-error t)
