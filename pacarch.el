;;; pacarch.el --- Pacman in Emacs

;; Filename: pacarch.el
;; Description: Pacman in Emacs
;; Author: KiteAB <kiteabpl@outlook.com>
;; Maintainer: KiteAB <kiteabpl@outlook.com>
;; Copyright (C) 2020, KiteAB, all rights reserved.
;; Created: 2020-11-10 20:41:29
;; Version: 0.1
;; Last-Updated: 2020-11-10 20:41:39
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
;; `pacarch-executable-files'
;; `pacarch-noconfirm'
;;
;; All of the above can customize by:
;;      M-x customize-group RET awesome-tray RET
;;

;;; TODO
;; <TODO(KiteAB)> Continue writing pacarch-install-package-from-aur function [Tue Nov 10 21:29:19 2020]
;;
;;

;;; Code:
(defgroup pacarch nil
  "Pacman in Emacs."
  :prefix "pacarch-"
  :group 'applications)

(defcustom pacarch-enforce-display-error t
  "Used for `pacarch-is-arch-distros' function.
Whether the `error' function."
  :type 'boolean
  :group 'pacarch)

(defcustom pacarch-enforce-upgrade nil
  "`t` is for 'pacman -Syy' and `nil` is for 'pacman -Sy'."
  :type 'boolean
  :group 'pacarch)

(defcustom pacarch-executable-files '("pacman"
                                      "yay")
  "First value is Pacman name.
Second value is AURTOOL name."
  :type 'list
  :group 'pacarch)

(defcustom pacarch-noconfirm nil
  "Add a '--noconfirm' argument or not.
Not propose to amend!"
  :type 'boolean
  :group 'pacarch)


(defun pacarch-is-executable-file-exists (file)
  "Is executable files in `pacarch-executable-files' is exist?
If not, then return error or warning by `pacarch-enforce-display-error'."
  (if (not (executable-find file))
      (if pacarch-enforce-display-error
          (error "[PacArch/ERROR] Not in a Arch Linux distributions!")
        (message "[PacArch/WARNING] Not in a Arch Linux distributions."))))

(defun pacarch-install-package-from-aur ()
  "Install package from Arch User Repository."
  )

(provide 'pacarch)

;;; pacarch.el ends here
