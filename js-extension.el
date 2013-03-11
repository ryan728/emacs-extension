(add-hook 'js-mode-hook 'my-js-customizations)

(defun my-js-customizations ()
  "set up my personal customizations for javascript mode"
  (define-key js-mode-map (kbd "C-c C-c") 'switch-to-coffeescript))

(defun switch-to-coffeescript ()
  "switch to corresponding coffeescript file"
  (interactive)
  (switch-to-corresponding-file "%s.coffee"))
