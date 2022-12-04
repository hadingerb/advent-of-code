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

(defun split-str (str del)
    (loop for idx from 0 to (length str) do
        (when (eq idx (length str)) (return-from split-str (list str)))
        (let ((letter (subseq str idx (+ idx 1))))
            (when (equal letter del) (return-from split-str (cons (subseq str 0 idx) (split-str (subseq str (+ idx 1)) del))))
        )
    )
)

;; to return multiple things (eventually will probably want)
;; values
;; multiple-value-bind

(defvar *input* (read-file-lines "input.txt"))
