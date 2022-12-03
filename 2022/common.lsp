;;;; Common library for useful functions

#||
This is how you block comment :)
||#

;;; read file into list
(defun read-file-lines (file)
  (with-open-file (stream file)
    (loop for line = (read-line stream nil)
      while line
      collect line
    )
  )
)

(defvar *input* (read-file-lines "input.txt"))
