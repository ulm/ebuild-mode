;;; ebuild-mode.el --- a mode for editing Gentoo GNU/Linux .ebuild and .eclass files.

;; Copyright (C) 2003-2006  Gentoo Foundation

;; Author: Matthew Kennedy <mkennedy@gentoo.org>
;; Keywords: convenience

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; The commands have been grouped into lists of rough similarity.  If
;; you can think of a better way to arrange these, please let us know.
;; We map each set of keywords to the basic faces: font-lock-*-face.

;;; Code:

(defvar ebuild-mode-commands-0
  '("use" "has_version" "best_version" "use_with" "use_enable" "check_KV" "keepdir" "econf" "die" "einstall" "einfo" "ewarn" "eerror" "diropts" "dobin" "docinto" "dodoc" "doexe" "dohard" "dohtml" "doinfo" "doins" "dolib" "dolib.a" "dolib.so" "doman" "dosbin" "dosym" "emake" "exeinto" "exeopts" "fowners" "fperms" "insinto" "insopts" "into" "libopts" "newbin" "newexe" "newins" "newman" "newsbin" "prepall" "prepalldocs" "prepallinfo" "prepallman" "prepallstrip" "has" "unpack" "dopython" "dosed" "into" "doinitd" "doconfd" "doenvd" "dojar" "domo" "dodir" "ebegin" "eend" "newconfd" "newdoc" "newenvd" "newinitd" "newlib.a" "newlib.so" "hasq" "hasv" "useq" "usev"))

(defvar ebuild-mode-commands-1
  '("addread" "addwrite" "adddeny" "addpredict"))

(defvar ebuild-mode-commands-2
  '("inherit"))

(defun ebuild-mode-make-keywords-list (keywords-list face &optional prefix suffix)
  ;; based on `make-generic-keywords-list' from generic.el
  (unless (listp keywords-list)
    (error "Keywords argument must be a list of strings"))
  (cons (concat prefix "\\<"
		(regexp-opt keywords-list t)
		"\\>" suffix)
	face))

(defun ebuild-mode-tabify ()
  (save-excursion 
    (tabify (point-min) (point-max))))

(define-derived-mode ebuild-mode shell-script-mode "Ebuild"
  "Major mode for Gentoo GNU/Linux .ebuild and .eclass files"
  (font-lock-add-keywords 'ebuild-mode
   (list (ebuild-mode-make-keywords-list ebuild-commands-0 'font-lock-type-face)
         (ebuild-mode-make-keywords-list ebuild-commands-1 'font-lock-warning-face)
	 (ebuild-mode-make-keywords-list ebuild-commands-2 'font-lock-type-face)))
  (add-hook 'write-file-functions 'delete-trailing-whitespace t t)
  (add-hook 'write-file-functions 'ebuild-mode-tabify t t)
  (setq tab-width 4
        indent-tabs-mode t))

;; (add-to-list 'auto-mode-alist '("\\.ebuild\\'" . ebuild-mode))
;; (add-to-list 'auto-mode-alist '("\\.eclass\\'" . ebuild-mode))

(provide 'ebuild-mode)

;;; ebuild-mode.el ends here
