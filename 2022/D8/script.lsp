;;;; Advent of Code Day 8: Treehouse hunt
(load "../common.lsp")

(defvar *trees* '())

(dolist (trees *input*)
    (let ((trees-list (coerce trees 'list))
        (trees-int '()))

        (dolist (tree trees-list)
            (setq trees-int (cons (digit-char-p tree) trees-int))
        )
        (setq *trees* (cons trees-int *trees*)))
)
(defvar *trees-trans* (transpose *trees*))

;; p1
(defvar visible (- (+ (* 2 (length *trees*)) (* 2 (length (nth 0 *trees*)))) 4))
;;; returns true if any tree in path is taller than given tree
(defun scan-all-less (tree trees)
    (when (eq 1 (length trees)) (return-from scan-all-less (>= (nth 0 trees) tree)))
    (or (>= (nth 0 trees) tree) (scan-all-less tree (subseq trees 1)))
)

;; p2
(defvar scenic-score-hi 0)
(defun ss (tree trees)
    (when (eq 0 (length trees)) (return-from ss 0))
    (when (>= (nth 0 trees) tree)(return-from ss 1))
    (+ 1 (ss tree (subseq trees 1)))
)

;; general
(loop for row from 1 to (- (length *trees*) 2) do
    (loop for col from 1 to (- (length *trees-trans*) 2) do
        (let* ((tree (nth col (nth row *trees*)))
            (col-trans (- (length *trees-trans*) (+ col 1)))
            (row-before (subseq (nth row *trees*) 0 col))
            (row-after (subseq (nth row *trees*) (+ col 1)))
            (col-above (subseq (nth col-trans *trees-trans*) 0 row))
            (col-below (subseq (nth col-trans *trees-trans*) (+ row 1))))

            ;; p1
            (when (or
                    (or (not (scan-all-less tree row-before))
                        (not (scan-all-less tree row-after))); scan row
                    (or (not (scan-all-less tree col-above))
                        (not (scan-all-less tree col-below)))); scan col

                        (incf visible))

            ;; p2
            (setq scenic-score-hi (max scenic-score-hi 
                (* (ss tree (reverse row-before)) (ss tree row-after) (ss tree (reverse col-above)) (ss tree col-below))))
    ))
)

(format t "~d~%" visible)
(format t "~d~%" scenic-score-hi)
