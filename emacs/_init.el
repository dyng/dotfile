(defun my-ensure-packages ()
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ("melpa" . "http://melpa.milkbox.net/packages/")))
  (package-initialize)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (defvar my-packages '(auto-complete
                        company
                        restclient
                        browse-kill-ring
                        auto-install
                        auto-compile
                        buffer-move
                        color-theme
                        color-theme-library
                        expand-region
                        ace-jump-mode
                        ace-jump-buffer
                        multiple-cursors
                        ido-ubiquitous
                        ibuffer-vc
                        racket-mode
                        slime
                        ac-slime
                        slime-repl
                        flycheck
                        flycheck-tip
                        flycheck-haskell
                        flycheck-hdevtools
                        nyan-mode
                        golden-ratio
                        recentf-ext
                        popwin
                        dired+
                        vlf
                        diff-hl
                        flx-ido
                        grizzl
                        dash
                        smex
                        s
                        epl
                        pkg-info
                        undo-tree
                        yasnippet
                        auto-yasnippet
                        js3-mode
                        markdown-mode
                        typed-clojure-mode
                        cljdoc
                        clj-refactor
                        clojure-cheatsheet
                        clojure-mode-extra-font-locking
                        smartparens
                        rainbow-delimiters
                        cider
                        cider-profile
                        csharp-mode
                        omnisharp
                        projectile
                        helm
                        helm-projectile
                        evil
                        god-mode
                        evil-god-state
                        powerline
                        powerline-evil
                        everything
                        haskell-mode
                        shm ;; structured haskell mode
                        ghci-completion
                        highlight-tail
                        ariadne
                        company-ghc
                        rust-mode
                        exec-path-from-shell
                        vkill
                        discover-my-major
                        utop
                        merlin
                        ocp-indent
                        tuareg))
  (let ((not-yet-installed '()))
    (mapcar (lambda (pkg) (when (not (package-installed-p pkg))
                            (push pkg not-yet-installed)))
            my-packages)
    (when (not (eq (length not-yet-installed) 0))
      (package-refresh-contents)
      (dolist (pkg not-yet-installed) (with-demoted-errors
                                        "Package install error: %S"
                                        (package-install pkg))))))

(defun my-color-theme ()
  (require 'color-theme)
  (color-theme-cyberpunk)
  (set-cursor-color "yellow"))

