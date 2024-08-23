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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dark+)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq display-fill-column-indicator-mode t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(require 'evil-leader)
(global-evil-leader-mode)


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
;;
;; (use-package! corfu
;;   :hook (doom-first-input . global-corfu-mode)
;;   :config
;;   (setq
;;    corfu-auto-delay 0.02
;;    corfu-auto-prefix 1
;;    corfu-sort-function nil
;;    ))
(use-package! corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.00)
  (corfu-auto-prefix 1)
  (corfu-preview-current nil)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match t)
  (corfu-cycle t)
  (corfu-preselect-first t)
  (corfu-echo-documentation 0.25)

  :config
  (global-corfu-mode))

(use-package! cape
  :after corfu
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(use-package! cape
  :defer t
  :init
  ;; Add useful defaults completion sources from cape
  (dolist (completion-source '(cape-file cape-dabbrev cape-keyword cape-elisp-symbol))
    (add-to-list 'completion-at-point-functions completion-source)))


(use-package! corfu-popupinfo
  :after corfu
  :config
  (corfu-popupinfo-mode))

;; Ensure tree-sitter and related modes are enabled
(use-package! tree-sitter
  :hook (prog-mode . tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode))

(use-package! tree-sitter-langs
  :after tree-sitter)

;; Configure evil-textobj-tree-sitter
;; (use-package! evil-textobj-tree-sitter
;;   :config
;;   (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))
;;   (define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer")))

(use-package! evil-textobj-tree-sitter
  ;; :defer 1
  ;; :after tree-sitter
  :config
  (define-key evil-outer-text-objects-map "m" (evil-textobj-tree-sitter-get-textobj "import"
                                                '((python-mode . [(import_statement) @import])
                                                  (go-mode . [(import_spec) @import])
                                                  (rust-mode . [(use_declaration) @import]))))
  (define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
  (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))
  (define-key evil-outer-text-objects-map "c" (evil-textobj-tree-sitter-get-textobj "class.outer"))
  (define-key evil-inner-text-objects-map "c" (evil-textobj-tree-sitter-get-textobj "class.inner"))
  (define-key evil-outer-text-objects-map "C" (evil-textobj-tree-sitter-get-textobj "comment.outer"))
  (define-key evil-inner-text-objects-map "C" (evil-textobj-tree-sitter-get-textobj "comment.outer"))
  (define-key evil-outer-text-objects-map "o" (evil-textobj-tree-sitter-get-textobj "loop.outer"))
  (define-key evil-inner-text-objects-map "o" (evil-textobj-tree-sitter-get-textobj "loop.inner"))
  (define-key evil-outer-text-objects-map "a" (evil-textobj-tree-sitter-get-textobj "conditional.outer"))
  (define-key evil-inner-text-objects-map "a" (evil-textobj-tree-sitter-get-textobj "conditional.inner"))
  (define-key evil-inner-text-objects-map "r" (evil-textobj-tree-sitter-get-textobj "parameter.inner"))
  (define-key evil-outer-text-objects-map "r" (evil-textobj-tree-sitter-get-textobj "parameter.outer"))
  (defun meain/goto-and-recenter (group &optional previous end query)
    (interactive)
    (evil-textobj-tree-sitter-goto-textobj group previous end query)
    (recenter 7))
  (define-key evil-normal-state-map (kbd "]r") (lambda () (interactive) (meain/goto-and-recenter "parameter.inner")))
  (define-key evil-normal-state-map (kbd "[r") (lambda () (interactive) (meain/goto-and-recenter "parameter.inner" t)))
  (define-key evil-normal-state-map (kbd "]R") (lambda () (interactive) (meain/goto-and-recenter "parameter.inner" nil t)))
  (define-key evil-normal-state-map (kbd "[R") (lambda () (interactive) (meain/goto-and-recenter "parameter.inner" t t)))
  (define-key evil-normal-state-map (kbd "]a") (lambda () (interactive) (meain/goto-and-recenter "conditional.outer")))
  (define-key evil-normal-state-map (kbd "[a") (lambda () (interactive) (meain/goto-and-recenter "conditional.outer" t)))
  (define-key evil-normal-state-map (kbd "]A") (lambda () (interactive) (meain/goto-and-recenter "conditional.outer" nil t)))
  (define-key evil-normal-state-map (kbd "[A") (lambda () (interactive) (meain/goto-and-recenter "conditional.outer" t t)))
  (define-key evil-normal-state-map (kbd "]c") (lambda () (interactive) (meain/goto-and-recenter "class.outer")))
  (define-key evil-normal-state-map (kbd "[c") (lambda () (interactive) (meain/goto-and-recenter "class.outer" t)))
  (define-key evil-normal-state-map (kbd "]C") (lambda () (interactive) (meain/goto-and-recenter "class.outer" nil t)))
  (define-key evil-normal-state-map (kbd "[C") (lambda () (interactive) (meain/goto-and-recenter "class.outer" t t)))
  (define-key evil-normal-state-map (kbd "]f") (lambda () (interactive) (meain/goto-and-recenter "function.outer")))
  (define-key evil-normal-state-map (kbd "[f") (lambda () (interactive) (meain/goto-and-recenter "function.outer" t)))
  (define-key evil-normal-state-map (kbd "]F") (lambda () (interactive) (meain/goto-and-recenter "function.outer" nil t)))
  (define-key evil-normal-state-map (kbd "[F") (lambda () (interactive) (meain/goto-and-recenter "function.outer" t t))))

;; (setq lsp-headerline-breadcrumb-mode t)
(after! lsp-mode
  ;; Enable the breadcrumb
  (setq lsp-headerline-breadcrumb-enable t)
  ;; Optionally, further customize the appearance
  (setq lsp-headerline-breadcrumb-icons-enable nil)
  ;; Enable the mode globally
  (add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode))

;; (use-package evil-leader
;;   :config
;;   (global-evil-leader-mode))

;; (use-package fancy-narrow
;;   :commands (fancy-narrow-to-region fancy-widen)
;;   :config
;;   (fancy-narrow-mode 1))

;; (use-package evil-textobj-tree-sitter
;;   :after tree-sitter)

;; (use-package emacs
;;   :after (evil-leader fancy-narrow)
;;   :commands (meain/fancy-narrow-to-thing)
;;   :config
;;   (defun meain/fancy-narrow-to-thing (thing)
;;     (interactive)
;;     (if (buffer-narrowed-p) (fancy-widen))
;;     (let ((range (evil-textobj-tree-sitter--range 1 (list (intern thing)))))
;;       (fancy-narrow-to-region (car range) (cdr range))))

;;   (evil-leader/set-key
;;     "n n" (lambda () (interactive) (fancy-widen))
;;     "n f" (lambda () (interactive) (meain/fancy-narrow-to-thing "function.outer"))
;;     "n c" (lambda () (interactive) (meain/fancy-narrow-to-thing "class.outer"))
;;     "n C" (lambda () (interactive) (meain/fancy-narrow-to-thing "comment.outer"))
;;     "n o" (lambda () (interactive) (meain/fancy-narrow-to-thing "loop.outer"))
;;     "n i" (lambda () (interactive) (meain/fancy-narrow-to-thing "conditional.outer"))
;;     "n a" (lambda () (interactive) (meain/fancy-narrow-to-thing "parameter.outer"))))

;; (global-lsp-bridge-mode)
;; ;; mapping keybindinds for lsp-bridge
;; (map! :leader
;;       (:prefix-map ("g" . "lsp-bridge")
;;        :desc "Find definition" "d" #'lsp-bridge-find-def
;;        :desc "Find implementation" "i" #'lsp-bridge-find-impl
;;        :desc "Find references" "r" #'lsp-bridge-find-references
;;        :desc "Rename" "R" #'lsp-bridge-rename
;;        :desc "Restart LSP Bridge" "p" #'lsp-bridge-restart-process
;;        :desc "Kill all process" "k" #'lsp-bridge-kill-process))
;;       :desc "Find references ripgrep" "g" #'consult-ripgrep-at-point))

;; ;; Automatically use python-ts-mode for python and cython files
;; (after! python
;;   (add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
;;   (add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-ts-mode))
;;   (add-to-list 'auto-mode-alist '("\\.pxi\\'" . python-ts-mode)))

;; (use-package! lsp-bridge
;;   :config
;;   (setq lsp-bridge-enable-log nil)
;;   ;; (setq lsp-bridge-python-multi-lsp-server 'basedpyright_ruff)
;;   (setq lsp-bridge-user-multi-server-dir "/codemill/shrimali/base")
;;   (setq lsp-bridge-user-langserver-dir "/codemill/shrimali/base")
;;   (setq lsp-bridge-python-multi-lsp-server 'pyright-background-analysis_ruff)
;;   ;; (setq lsp-bridge-python-command "/usr/local/bin/python3")
;;   (global-lsp-bridge-mode))

; (defun my/execute-with-split (split-fn)
;;   "Execute the current command, but in a new split created by SPLIT-FN."
;;   (let ((this-command-keys (this-command-keys))
;;         (this-command this-command)
;;         (this-original-command this-original-command))
;;     (funcall split-fn)
;;     (setq this-command this-original-command)
;;     (setq this-original-command nil)
;;     (let ((last-nonmenu-event 13))  ; Simulate RET key
;;       (apply 'execute-kbd-macro this-command-keys))))

;; (defun my/execute-with-horizontal-split ()
;;   "Execute the current command in a new horizontal split."
;;   (interactive)
;;   (my/execute-with-split 'split-window-below))

;; (defun my/execute-with-vertical-split ()
;;   "Execute the current command in a new vertical split."
;;   (interactive)
;;   (my/execute-with-split 'split-window-right))

;; ;; Global keybindings
;; (global-set-key (kbd "C-u") 'my/execute-with-horizontal-split)
;; (global-set-key (kbd "C-e") 'my/execute-with-vertical-split)

;; ;; For Doom Emacs, you might prefer to use `map!` instead:
;; ;; (map! :map global-map
;; ;;       "C-x" #'my/execute-with-horizontal-split
;; ;;       "C-s" #'my/execute-with-vertical-split)

;; ;; Optional: Add leader key bindings for Doom Emacs
;; (map! :leader
;;       :desc "Execute in horizontal split" "w x" #'my/execute-with-horizontal-split
;;       :desc "Execute in vertical split" "w s" #'my/execute-with-vertical-split)

(use-package! magit-todos
  :after magit
  :config
  (setq magit-todos-keyword-suffix "\\(?:([^)]+)\\)?:?") ; make colon optional
  (define-key magit-todos-section-map "j" nil))

(use-package consult
  :ensure t)

(use-package embark
  :ensure t)

(defun search-current-function ()
  "Search within the current function using `consult-line`."
  (interactive)
  (save-restriction
    (narrow-to-defun)
    (consult-line)))

(defun lsp-narrow-to-class ()
  "Narrow to the region of the current class using `lsp-mode`."
  (interactive)
  (when-let ((symbols (lsp--get-document-symbols)))
    (let ((class (cl-find-if (lambda (sym)
                               (and (eq (lsp:document-symbol-kind sym) 5) ; 5 is the kind for classes
                                    (lsp--point-in-range-p (point) (lsp:range (lsp:document-symbol-range sym)))))
                             symbols)))
      (when class
        (let* ((range (lsp:document-symbol-range class))
               (start (lsp--position-to-point (lsp:range-start range)))
               (end (lsp--position-to-point (lsp:range-end range))))
          (narrow-to-region start end))))))

(defun search-current-class-lsp ()
  "Search within the current class using `consult-line` and `lsp-mode`."
  (interactive)
  (save-restriction
    (lsp-narrow-to-class)
    (consult-line)))

(map! :leader
      :desc "Search in current function" "s f" #'search-current-function
      :desc "Search in current class" "s c" #'search-current-class)

(after! evil
    (map! :n "C-SPC" #'er/expand-region))

(use-package! lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-update-mode 'line
        lsp-ui-doc-enable nil))  ;; Disable the hover documentation popup

(use-package! lsp-treemacs
  :after lsp
  :config
  ;; Enable the error list automatically
  (lsp-treemacs-sync-mode 1)
  ;; Optionally bind a key to toggle the error list
  (map! :leader
        :desc "Toggle LSP Error List" "o e" #'lsp-treemacs-errors-list))

;; Function to go to definition in a popup using popwin
;; (defun my/lsp-goto-definition-popup ()
;;   "Go to definition in a popup window."
;;   (interactive)
;;   (let ((buffer (current-buffer)))
;;     (popwin:display-buffer
;;      (lambda (buf)
;;        (with-current-buffer buffer
;;          (lsp-find-definition)
;;          (current-buffer)))
;;      :height 0.3 :width 0.3 :position 'bottom)))

;; (defun my/lsp-goto-definition-popup ()
;;   "Go to definition in a popup window."
;;   (interactive)
;;   (let ((buffer (current-buffer)))
;;     (lsp-find-definition)
;;     (let ((def-buffer (current-buffer)))
;;       (when (not (eq buffer def-buffer))
;;         (display-buffer def-buffer '((display-buffer-pop-up-window)))))))

;; Function to go to definition in a horizontal split
(defun my/lsp-goto-definition-horizontal-split ()
  "Go to definition in a horizontal split."
  (interactive)
  (let ((buffer (current-buffer)))
    (split-window-below)
    (other-window 1)
    (with-current-buffer buffer
      (lsp-find-definition))))

;; Function to go to definition in a vertical split
(defun my/lsp-goto-definition-vertical-split ()
  "Go to definition in a vertical split."
  (interactive)
  (let ((buffer (current-buffer)))
    (split-window-right)
    (other-window 1)
    (with-current-buffer buffer
      (lsp-find-definition))))

(map! :leader
      ;; :desc "Goto definition in popup" "g d p" #'my/lsp-goto-definition-popup
      :desc "Goto definition in horizontal split" "g d h" #'my/lsp-goto-definition-horizontal-split
      :desc "Goto definition in vertical split" "g d v" #'my/lsp-goto-definition-vertical-split)

(defun my/lsp-show-diagnostics-in-popup ()
  "Show diagnostics for the current line in a popup buffer."
  (interactive)
  (let ((diagnostics (lsp-diagnostics))
        (buffer-name "*LSP Diagnostics*"))
    (if diagnostics
        (let ((line-diagnostics (seq-filter
                                 (lambda (diag)
                                   (eq (line-number-at-pos)
                                       (lsp-diagnostic-line diag)))
                                 diagnostics)))
          (if line-diagnostics
              (let ((buffer (get-buffer-create buffer-name)))
                (with-current-buffer buffer
                  (erase-buffer)
                  (insert (string-join (mapcar #'lsp-diagnostic-message line-diagnostics) "\n"))
                  (goto-char (point-min)))
                (pop-to-buffer buffer))
            (message "No diagnostics at current line")))
      (message "No diagnostics available."))))

(defun my/flycheck-show-diagnostics-in-popup ()
  "Show Flycheck diagnostics for the current line in a popup buffer."
  (interactive)
  (let ((errors (flycheck-overlay-errors-at (point)))
        (buffer-name "*Flycheck Diagnostics*"))
    (if errors
        (let ((buffer (get-buffer-create buffer-name)))
          (with-current-buffer buffer
            (erase-buffer)
            (insert (string-join (mapcar #'flycheck-error-message errors) "\n"))
            (goto-char (point-min)))
          (pop-to-buffer buffer))
      (message "No diagnostics at current line"))))

(map! :leader
      :desc "Show LSP diagnostics in popup" "d l" #'my/lsp-show-diagnostics-in-popup
      :desc "Show flycheck diagnostics in popup" "d f" #'my/flycheck-show-diagnostics-in-temp-buffer)

;; (defun show-diagnostics-for-current-line ()
;;   "Show diagnostics for the current line in a popup window."
;;   (interactive)
;;   (let* ((flymake-diags (flymake-diagnostics (point)))
;;          (lsp-diags (lsp--get-line-diagnostics))
;;          (buf (get-buffer-create "*Line Diagnostics*")))
;;     (with-current-buffer buf
;;       (erase-buffer)
;;       (if (or flymake-diags lsp-diags)
;;           (progn
;;             (when flymake-diags
;;               (insert "Flymake diagnostics:\n")
;;               (dolist (diag flymake-diags)
;;                 (insert (format "%s: %s\n"
;;                                 (flymake-diagnostic-severity diag)
;;                                 (flymake-diagnostic-text diag))))
;;               (insert "\n"))
;;             (when lsp-diags
;;               (insert "LSP diagnostics:\n")
;;               (dolist (diag lsp-diags)
;;                 (insert (format "%s: %s\n"
;;                                 (lsp-diagnostic-severity diag)
;;                                 (lsp-diagnostic-message diag))))))
;;         (insert "No diagnostics for current line."))
;;       (goto-char (point-min)))
;;     (display-buffer buf)))

;; (defun show-diagnostics-for-current-line ()
;;   "Show diagnostics for the current line in a popup window."
;;   (interactive)
;;   (let* ((flymake-diags (flymake-diagnostics (point)))
;;          (lsp-diags (lsp--get-buffer-diagnostics))
;;          (line (line-number-at-pos))
;;          (buf (get-buffer-create "*Line Diagnostics*")))
;;     (with-current-buffer buf
;;       (erase-buffer)
;;       (if (or flymake-diags lsp-diags)
;;           (progn
;;             (when flymake-diags
;;               (insert "Flymake diagnostics:\n")
;;               (dolist (diag flymake-diags)
;;                 (insert (format "%s: %s\n"
;;                                 (flymake-diagnostic-severity diag)
;;                                 (flymake-diagnostic-text diag))))
;;               (insert "\n"))
;;             (when lsp-diags
;;               (insert "LSP diagnostics:\n")
;;               (dolist (diag lsp-diags)
;;                 (when (= (lsp-diagnostic-line diag) (1- line))
;;                   (insert (format "%s: %s\n"
;;                                   (lsp--severity-string (lsp-diagnostic-severity diag))
;;                                   (lsp-diagnostic-message diag)))))))
;;         (insert "No diagnostics for current line."))
;;       (goto-char (point-min)))
;;     (display-buffer buf)))

;; (defun show-diagnostics-for-current-line ()
;;   "Show diagnostics for the current line in a popup window."
;;   (interactive)
;;   (let* ((flymake-diags (flymake-diagnostics (point)))
;;          (lsp-diags (lsp-diagnostics))
;;          (current-line (line-number-at-pos))
;;          (buf (get-buffer-create "*Line Diagnostics*")))
;;     (with-current-buffer buf
;;       (erase-buffer)
;;       (if (or flymake-diags lsp-diags)
;;           (progn
;;             (when flymake-diags
;;               (insert "Flymake diagnostics:\n")
;;               (dolist (diag flymake-diags)
;;                 (insert (format "%s: %s\n"
;;                                 (flymake-diagnostic-severity diag)
;;                                 (flymake-diagnostic-text diag))))
;;               (insert "\n"))
;;             (when lsp-diags
;;               (insert "LSP diagnostics:\n")
;;               (maphash (lambda (_file diags)
;;                          (dolist (diag diags)
;;                            (let ((lsp-line (1+ (lsp-diagnostic-position diag))))
;;                              (when (= lsp-line current-line)
;;                                (insert (format "%s: %s\n"
;;                                                (lsp-diagnostic-severity diag)
;;                                                (lsp-diagnostic-message diag)))))))
;;                        lsp-diags)))
;;         (insert "No diagnostics for current line."))
;;       (goto-char (point-min)))
;;     (display-buffer buf)))

;; (defun show-diagnostics-for-current-line ()
;;   "Show diagnostics for the current line in a popup window."
;;   (interactive)
;;   (let* ((flymake-diags (flymake-diagnostics (point)))
;;          (lsp-diags (lsp--get-buffer-diagnostics))
;;          (current-line (line-number-at-pos))
;;          (buf (get-buffer-create "*Line Diagnostics*")))
;;     (with-current-buffer buf
;;       (erase-buffer)
;;       (if (or flymake-diags lsp-diags)
;;           (progn
;;             (when flymake-diags
;;               (insert "Flymake diagnostics:\n")
;;               (dolist (diag flymake-diags)
;;                 (insert (format "%s: %s\n"
;;                                 (flymake-diagnostic-severity diag)
;;                                 (flymake-diagnostic-text diag))))
;;               (insert "\n"))
;;             (when lsp-diags
;;               (insert "LSP diagnostics:\n")
;;               (dolist (diag lsp-diags)
;;                 (let* ((range (gethash "range" diag))
;;                        (start (gethash "start" range))
;;                        (lsp-line (1+ (gethash "line" start))))
;;                   (when (= lsp-line current-line)
;;                     (insert (format "%s: %s\n"
;;                                     (gethash "severity" diag)
;;                                     (gethash "message" diag))))))))
;;         (insert "No diagnostics for current line."))
;;       (goto-char (point-min)))
;;     (display-buffer buf)))

(defun show-diagnostics-for-current-line ()
  "Show diagnostics for the current line in a popup window."
  (interactive)
  (let* ((flymake-diags (when (bound-and-true-p flymake-mode)
                          (flymake-diagnostics (point))))
         (lsp-diags (when (bound-and-true-p lsp-mode)
                      (lsp--get-buffer-diagnostics)))
         (flycheck-diags (when (bound-and-true-p flycheck-mode)
                           (flycheck-overlay-errors-at (point))))
         (current-line (line-number-at-pos))
         (buf (get-buffer-create "*Line Diagnostics*")))
    (with-current-buffer buf
      (erase-buffer)
      (if (or flymake-diags lsp-diags flycheck-diags)
          (progn
            (when flymake-diags
              (insert "Flymake diagnostics:\n")
              (dolist (diag flymake-diags)
                (insert (format "%s: %s\n"
                                (flymake-diagnostic-severity diag)
                                (flymake-diagnostic-text diag))))
              (insert "\n"))
            (when lsp-diags
              (insert "LSP diagnostics:\n")
              (dolist (diag lsp-diags)
                (let* ((range (gethash "range" diag))
                       (start (gethash "start" range))
                       (lsp-line (1+ (gethash "line" start))))
                  (when (= lsp-line current-line)
                    (insert (format "%s: %s\n"
                                    (gethash "severity" diag)
                                    (gethash "message" diag))))))
              (insert "\n"))
            (when flycheck-diags
              (insert "Flycheck diagnostics:\n")
              (dolist (err flycheck-diags)
                (insert (format "%s: %s\n"
                                (flycheck-error-level err)
                                (flycheck-error-message err))))))
        (insert "No diagnostics for current line."))
      (goto-char (point-min)))
    (display-buffer buf)))


(map! :leader
      :desc "Show line diagnostics"
      "c L" #'show-diagnostics-for-current-line)
