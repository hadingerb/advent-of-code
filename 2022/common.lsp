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

;;; Takes a string and a single character delimeter
(defun split-str (str del)
    (let ((idx (position del str)))
        (when (eq idx nil) (return-from split-str (list str)))
        (return-from split-str (cons (subseq str 0 idx) (split-str (subseq str (+ idx 1)) del)))
    )
)

;; to return multiple things (eventually will probably want)
;; values
;; multiple-value-bind

(defvar *input* (read-file-lines "input.txt"))
