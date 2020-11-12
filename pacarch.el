;;; pacarch.el --- Pacman in Emacs

;; Filename: pacarch.el
;; Description: Pacman in Emacs
;; Author: KiteAB <kiteabpl@outlook.com>
;; Maintainer: KiteAB <kiteabpl@outlook.com>
;; Copyright (C) 2020, KiteAB, all rights reserved.
;; Created: 2020-11-10 20:41:29
;; Version: 0.2
;; Last-Updated: 2020-11-12 18:28:11
;;           By: KiteAB
;; URL: https://github.com/KitPixel/pacarch.el
;; Keywords:
;; Compatibility: GNU Emacs 27.1
;;
;; Features that might be required by this library:
;;
;;
;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Pacman in Emacs.
;;
;; I'm an Arch Linux user, but I want live in Emacs, too.
;; I want to make Pacman closer Emacs, are not terminal, so I developed this package.
;;

;;; Installation:
;;
;; Put pacarch.el to your load-path.
;; It's set in your ~/.emacs like this:
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;;
;; And the following to your ~/.emacs startup file.
;;
;; (require 'pacarch)
;;
;; No need more.

;;; Customize:
;;
;; `pacarch-enforce-display-error'
;; `pacarch-enforce-upgrade'
;; `pacarch-pacman-filename'
;; `pacarch-aurtool-filename'
;; `pacarch-output-buffer-name'
;;
;; All of the above can customize by:
;;      M-x customize-group RET pacarch RET
;;

;;; TODO
;;
;;
;;

;;; Code:
(defgroup pacarch nil
  "Pacman in Emacs."
  :prefix "pacarch-"
  :group 'applications)

(defcustom pacarch-aurtool-filename "yay"
  "AURTOOL's filename."
  :type 'string
  :group 'pacarch)

(defcustom pacarch-enforce-display-error t
  "Used for `pacarch-is-arch-distros' function.
Whether the `error' function."
  :type 'boolean
  :group 'pacarch)

(defcustom pacarch-enforce-upgrade nil
  "`t` is for 'pacman -Syy' and `nil` is for 'pacman -Sy'."
  :type 'boolean
  :group 'pacarch)

(defcustom pacarch-output-buffer-name "*PacArch Buffer*"
  "Default buffer name you want."
  :type 'string
  :group 'pacarch)

(defcustom pacarch-pacman-filename "pacman"
  "Pacman's filename."
  :type 'string
  :group 'pacarch)


(defun pacarch-install-pkg ()
  "Install package use pacman."
  (interactive)
  (pacarch-is-executable-file-exists pacarch-pacman-filename)
  (shell-command (concat "echo "
                         "\""
                         (pacarch-get-passwd)
                         "\" | "
                         "sudo -S "
                         pacarch-pacman-filename
                         " -S "
                         (pacarch-get-pkgname pacarch-pacman-filename)
                         " --noconfirm")
                 pacarch-output-buffer-name nil))

(defun pacarch-install-pkg-from-aur ()
  "Install package use AURTOOL."
  (interactive)
  (pacarch-is-executable-file-exists pacarch-aurtool-filename)
  (shell-command (concat pacarch-aurtool-filename
                         " -S "
                         (pacarch-get-pkgname pacarch-aurtool-filename)
                         " --noconfirm")
                 pacarch-output-buffer-name nil)
  (message "[PacArch] Package installed."))

(defun pacarch-is-executable-file-exists (file)
  "Is executable files in `pacarch-executable-files' is exist?
If not, then return error or warning by `pacarch-enforce-display-error'."
  (if (not (executable-find file))
      (if pacarch-enforce-display-error
          (error (concat "[PacArch/ERROR] " file "not found!"))
        (message "[PacArch/WARNING] " file "not found!"))))

(defun pacarch-get-passwd ()
  "Get password for current user."
  (read-passwd "[PacArch] Password: "))

(defun pacarch-get-pkgname (exefile)
  "Get package name from mini-buffer."
  (read-from-minibuffer (concat "[PacArch] Package name you want to install use " exefile ": ")))

(provide 'pacarch)

;;; pacarch.el ends here
