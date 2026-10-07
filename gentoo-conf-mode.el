;;; gentoo-conf-mode.el --- edit make.conf etc.  -*-lexical-binding:t-*-

;; Copyright 2026 Gentoo Authors

;; Author: Ulrich Müller <ulm@gentoo.org>
;; Maintainer: <emacs@gentoo.org>
;; Keywords: languages

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 2 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Minimum Emacs version:
;; GNU Emacs 26.3
;; XEmacs not supported

;;; Code:

(require 'conf-mode)
(require 'font-lock)

(defvar gentoo-conf-use-re "^[ \t]*USE=\\(\"[^\"]*\"\\)"
  "Regexp matching the USE assignment in make.conf.")

(defvar gentoo-conf-font-lock-keywords
  `((,gentoo-conf-use-re
     ;; highlight any disabled (-foo) USE flags
     ("[ \t\n\"]\\(-[^ \t\n\"]+\\)"
      (gentoo-conf-font-lock-pre-form) nil
      (1 'font-lock-warning-face t)))
    ;; whitespace before or after the equals sign
    ("^[^\"#=\n]*?\\(?:\\([ \t]+\\)=\\([ \t]+\\)?\\|=\\(?2:[ \t]+\\)\\)\
\\(?:\"\\|\\\\$\\)"
     (1 'trailing-whitespace t t)
     (2 'trailing-whitespace t t)))
  "Expressions to highlight in `gentoo-conf-mode'.")

(defun gentoo-conf-font-lock-pre-form ()
  "Pre-form function for anchored font-lock matcher."
  (put-text-property (match-beginning 0) (match-end 0)
		     'font-lock-multiline t)
  (goto-char (match-beginning 1))
  (match-end 1))

(defun gentoo-conf-use-bounds (pos)
  "Find the bounds of any USE assignment containing POS.
Return a cons cell (BEG . END) if BEG < POS < END, or nil otherwise."
  (save-excursion
    (goto-char pos)
    (when (or (search-forward "=" (line-end-position) t)
	      (search-backward "=" nil t))
      (beginning-of-line)
      (and (looking-at gentoo-conf-use-re)
	   (< (match-beginning 0) pos (match-end 0))
	   (cons (match-beginning 0) (match-end 0))))))

(defvar font-lock-beg)
(defvar font-lock-end)

(defun gentoo-conf-font-lock-extend-region ()
  "Extend the font-lock region if it overlaps the USE assignment.
If `font-lock-beg' is in the USE assignment then move it to the start;
likewise for `font-lock-end'.  Return non-nil if either variable was
changed."
  (let ((beg (gentoo-conf-use-bounds font-lock-beg))
	(end (gentoo-conf-use-bounds font-lock-end)))
    (if beg (setq font-lock-beg (car beg)))
    (if end (setq font-lock-end (cdr end)))
    (or beg end)))

;;;###autoload
(define-derived-mode gentoo-conf-mode conf-unix-mode "Conf[Gentoo]"
  "Major mode for Gentoo's make.conf and related files.
For details see `conf-mode'."
  (font-lock-add-keywords nil gentoo-conf-font-lock-keywords)
  (add-hook 'font-lock-extend-region-functions
	    #'gentoo-conf-font-lock-extend-region))

;;;###autoload
(add-to-list 'auto-mode-alist
	     '("/make\\.\\(conf\\|defaults\\)\\'" . gentoo-conf-mode))

(provide 'gentoo-conf-mode)

;; Local Variables:
;; coding: utf-8
;; End:

;;; gentoo-conf-mode.el ends here
