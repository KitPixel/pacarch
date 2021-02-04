;;; pacarch.el --- Pacman in Emacs  -*- lexical-binding: t; -*-

;; Filename: pacarch.el
;; Description: Pacman in Emacs
;; Author: KiteAB <kiteabpl@outlook.com> (https://kiteab.ga)
;; Maintainer: KiteAB <kiteabpl@outlook.com> (https://kiteab.ga)
;; Copyright (C) 2021, KiteAB, all rights reserved.
;; Created: 2020-11-10 20:41:29
;; Last-Updated: 2021-01-20 21:15:49
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
;; `pacarch-enforce-upgrade-srcs'
;; `pacarch-pacman-filename'
;; `pacarch-output-buffer-name'
;;
;; All of the above can customize by:
;;      M-x customize-group RET pacarch RET
;;

;;; TODO
;;
;;
;;

;;; Require

;;; Code:

(defgroup pacarch nil
  "Pacman in Emacs."
  :prefix "pacarch-"
  :group 'applications)

(defcustom pacarch-enforce-display-error t
  "Used for `pacarch-is-executable-file-exists' function.
Whether the `error' function."
  :type 'boolean
  :group 'pacarch)

(defcustom pacarch-enforce-upgrade-srcs nil
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
  (pacarch--is-aurtool)
  (pacarch--is-executable-file-exists pacarch-pacman-filename)
  (shell-command (concat "echo "
                         "\""
                         (pacarch--get-passwd)
                         "\" | "
                         "sudo -S "
                         pacarch-pacman-filename
                         " -S "
                         (pacarch--get-pkgname pacarch-pacman-filename)
                         " --noconfirm"
                         " &")
                 pacarch-output-buffer-name nil)
  (switch-to-buffer-other-window pacarch-output-buffer-name))

(defun pacarch--is-aurtool ()
  "Is `pacarch-pacman-filename' equal an arch user repository tool?"
  (if (or (string= pacarch-pacman-filename "yay")
          (string= pacarch-pacman-filename "yaourt"))
      (if pacarch-enforce-display-error
          (error "[PacArch/ERROR] PacArch.el not support manage package use AURTOOL yet!")
        (message "[PacArch/WARNING] PacArch.el not support manage package use AURTOOL yet!"))))

(defun pacarch--is-executable-file-exists (file)
  "Is executable files in `pacarch-pacman-filename' is exist?
If not, then return error or warning by `pacarch-enforce-display-error'."
  (if (not (executable-find file))
      (if pacarch-enforce-display-error
          (error (concat "[PacArch/ERROR] " file "not found!"))
        (message "[PacArch/WARNING] " file "not found!"))))

(defun pacarch--get-passwd ()
  "Get password for current user."
  (read-passwd "[PacArch] Password: "))

(defun pacarch--get-pkgname (exefile)
  "Get package name from mini-buffer."
  (read-from-minibuffer (concat "[PacArch] Package name you want to install use " exefile ": ")))

(defun pacarch-upgrade-srcs ()
  "Upgrade sources in '/etc/pacman.conf'."
  (interactive)
  (pacarch--is-aurtool)
  (pacarch--is-executable-file-exists pacarch-pacman-filename)
  (if pacarch-enforce-upgrade-srcs
      (shell-command (concat "echo "
                             "\""
                             (pacarch--get-passwd)
                             "\" | "
                             "sudo -S "
                             pacarch-pacman-filename
                             " -Syy "
                             "--noconfirm"
                             " &")
                     pacarch-output-buffer-name nil)
    (shell-command (concat "echo "
                           "\""
                           (pacarch--get-passwd)
                           "\" | "
                           "sudo -S "
                           pacarch-pacman-filename
                           " -Sy "
                           "--noconfirm"
                           " &")
                   pacarch-output-buffer-name nil))
  (switch-to-buffer-other-window pacarch-output-buffer-name))

(defun pacarch-upgrade-pkgs ()
  "Upgrade packages."
  (interactive)
  (pacarch--is-aurtool)
  (pacarch--is-executable-file-exists pacarch-pacman-filename)
  (shell-command (concat "echo "
                         "\""
                         (pacarch--get-passwd)
                         "\" | "
                         "sudo -S "
                         pacarch-pacman-filename
                         " -Su "
                         "--noconfirm"
                         " &")
                 pacarch-output-buffer-name nil)
  (switch-to-buffer-other-window pacarch-output-buffer-name))

(defun pacarch-upgrade-srcs-and-pkgs ()
  "Upgrade sources and packages."
  (interactive)
  (pacarch--is-aurtool)
  (pacarch--is-executable-file-exists pacarch-pacman-filename)
  (let ((passwd (pacarch--get-passwd)))
    (if pacarch-enforce-upgrade-srcs
        (shell-command (concat "echo "
                               "\""
                               passwd
                               "\" | "
                               "sudo -S "
                               pacarch-pacman-filename
                               " -Syyu "
                               "--noconfirm"
                               " &")
                       pacarch-output-buffer-name nil)
      (shell-command (concat "echo "
                             "\""
                             passwd
                             "\" | "
                             "sudo -S "
                             pacarch-pacman-filename
                             " -Syu "
                             "--noconfirm"
                             " &")
                     pacarch-output-buffer-name nil)))
  (switch-to-buffer-other-window pacarch-output-buffer-name))

(provide 'pacarch)

;;; pacarch.el ends here
