;;;; Advent of Code Day unique-length: Cleaning Camp
(load "../common.lsp")

(defvar line-idx -1)

(defun populate-tree (tree)
    (let ((sum 0) (sum-tree '()))
        (loop while (eq 0 0) do
            (let* ((line (nth (incf line-idx) *input*)))
                (when (eq nil line) (return-from populate-tree (values tree (cons sum sum-tree))))
                ;; when ls, scroll through until next $
                (when (and (eq 0 (position #\$ line)) (eq 2 (search "ls" line)))
                    (progn
                        (setq line (nth (incf line-idx) *input*))
                        (when (eq nil line) (return-from populate-tree (values tree (cons sum sum-tree))))
                        (loop while (eq nil (position #\$ line)) do
                            (when (not (eq 0 (search "dir" line)))
                                ;; add size of file to current list (new element)
                                (let ((size (parse-integer (nth 0 (split-str line #\SPACE)))))
                                    (setq tree (cons size tree))
                                    (setq sum (+ sum size))
                            ))
                            (setq line (nth (incf line-idx) *input*))
                            (when (eq nil line) (return-from populate-tree (values tree (cons sum sum-tree)))))))
                ;; cd command
                ;;(setq line (nth (incf line-idx) *input*))
                (when (and (eq 0 (position #\$ line)) (eq 2 (search "cd" line)))
                    ;; only do something with cd in, cd out just return
                    (if (eq nil (search ".." line))
                        (multiple-value-bind (subtree subsum) (populate-tree '())
                            (setq tree (cons subtree tree))
                            (setq sum (+ (car subsum) sum))
                            (setq sum-tree (cons subsum sum-tree))
                        )
                        (return-from populate-tree (values tree (cons sum sum-tree)))))
            )
        )
    )
)

(multiple-value-bind (directory-tree sum-tree) (populate-tree '())
    (write directory-tree)(terpri)
    (write sum-tree)(terpri)

    (defvar sum-less-100000 0)

    (defvar sums (remove #\( (remove #\) (remove #\linefeed (format nil "~a" sum-tree)))))

    (defvar size-needed (- 30000000 (- 70000000 (parse-integer (nth 0 (split-str sums #\SPACE))))))
    (defvar cur-smallest-size 70000000)

    (dolist (sum (split-str sums #\SPACE))
        (when (> (length sum) 0)
            (let ((int (parse-integer sum)))
                (when (<= int 100000) (setq sum-less-100000 (+ sum-less-100000 int))); p1
                (when (>= int size-needed) (setq cur-smallest-size (min cur-smallest-size int))); p2
            )
        )
    )
    (write sum-less-100000)(terpri)
    (write cur-smallest-size)(terpri)
)



