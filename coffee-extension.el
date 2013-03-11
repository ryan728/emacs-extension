(add-hook 'coffee-mode-hook 'my-coffee-customizations)

(defun my-coffee-customizations ()
  "set up my personal customizations for coffee mode"
  (define-key coffee-mode-map (kbd "C-c C-j") 'switch-to-javascript))

(defun switch-to-javascript ()
  "switch to corresponding javascript file"
  (interactive)
  (switch-to-corresponding-file "%s.js"))
