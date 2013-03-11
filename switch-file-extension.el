(defun current-file-name-without-extension ()
  (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))

(defun switch-to-corresponding-file (fileFormat)
  (let ((file-name (format fileFormat (current-file-name-without-extension))))
    (if (is-file-opened file-name)
        (switch-to-buffer (get-buffer file-name))
      (find-file file-name))))

(defun find-file (fileName)
  (if (file-exists-in-directory fileName default-directory)
      (switch-to-buffer (find-file-noselect (format "%s%s" default-directory fileName)))
   (let ((targetFile (find-file-in-directory fileName (find-src-directory))))
     (if targetFile
         (switch-to-file targetFile)
       (message "%s could not be found." fileName)))))

(defun find-file-in-directory (fileName directory)
  (if (file-exists-in-directory fileName directory)
      (format "%s%s" directory fileName)
    (let ((subDirectories (directory-dirs directory)))
      (dolist (subDirectory subDirectories)
        (let ((result (find-file-in-directory fileName subDirectory)))
          (if result
              (return result)))))))


(defun get-full-directory-path (directory)
  (expand-file-name (file-name-as-directory directory)))


(defun switch-to-file (file)
  (switch-to-buffer (find-file-noselect file)))

(defun directory-dirs (dir)
  "Find all directories in DIR."
  (unless (file-directory-p dir)
    (error "Not a directory `%s'" dir))
  (let ((dir (directory-file-name dir))
        (dirs '())
        (files (directory-files dir nil nil t)))
    (dolist (file files)
      (unless (member file '("." ".."))
        (let ((file (concat dir "/" file)))
          (when (file-directory-p file)
            (setq dirs (append (cons (get-full-directory-path file)
                                     (directory-dirs file))
                               dirs))))))
    dirs))

(defun file-exists-in-directory (fileName directory)
  (file-exists-p (format "%s%s" directory fileName)))

(defun is-directory-src (directory)
  (string-equal "src" (downcase (car (last (split-string (expand-file-name (file-name-as-directory directory)) "/") 2)))))


(defun find-src-directory ()
  (let ((current-path (expand-file-name (file-name-as-directory "."))))
    (let ((pathElements (split-string current-path "/")))
      (if (member "src" (mapcar 'downcase pathElements))
          (progn
            (setq result "")
            (dolist (pathElement pathElements)
              (setq result (format "%s%s/" result pathElement))
              (if (is-directory-src result)
                  (return result))))
        (call-interactively 'ask-for-src-directory)))))

(defun ask-for-src-directory (&optional directory)
  (interactive "DChoose source file directory.")
  directory)

(defun trace-directory (pathElements dirName currentPath)
  (let ((element (car pathElements)))
    (if element
        (if (string-equal element "")
            (trace-directory (cdr pathElements) dirName currentPath)
          (if (string-equal element dirName)
              (format "%s%s/" currentPath dirName)
            (trace-directory (cdr pathElements) dirName (format "%s%s/" currentPath element))))
      currentPath)))

(defun is-file-opened (file-name)
  (setq current-buffer-list (buffer-list))
  (setq result nil)
  (while (car current-buffer-list)
    (if  (string-match file-name (buffer-name (car current-buffer-list)))
        (setq result t))
    (setq current-buffer-list (cdr current-buffer-list)))
  result)
