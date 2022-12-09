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

;;; Transpose list of lists
(defun transpose (lst)
    (let ((lst_trans '()))
        (loop for idx from 0 to (- (length (nth 0 lst)) 1) do
            (let ((sublst '()))
                (loop for idx2 from 0 to (- (length lst) 1) do
                    (setq sublst (cons (nth idx (nth idx2 lst)) sublst)))
                (setq lst_trans (cons (reverse sublst) lst_trans))))
        (return-from transpose lst_trans))
)

(defun update-nth (lst n val)
  (setf (elt lst n) val) lst
)

(defvar *input* (read-file-lines "input.txt"))
