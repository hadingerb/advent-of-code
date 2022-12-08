;;;; Advent of Code Day 6: Finding the code
(load "../common.lsp")

(defvar characters (coerce (nth 0 *input*) 'list))


(defun start-of (unique-length)

    (loop for idx from 0 to (- (length characters) unique-length) do
        (when (eq (length (subseq characters idx (+ idx unique-length)))
                  (length (remove-duplicates (subseq characters idx (+ idx unique-length)))))
            (return-from start-of (+ idx unique-length))))
)
(format t "~d -- ~d~%" (start-of 4) (start-of 14))
