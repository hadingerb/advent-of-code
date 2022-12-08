;;;; Advent of Code Day 5: Moving Crates
(load "../common.lsp")

(defvar towers_trans '())
(defvar towers '())
(defvar moves '())

(d/list (line *input*)
    (when (not (eq nil (position #\[ line)))
        (let ((line_parts (coerce line 'list))
            (tower_trans '()))
            (loop for idx from 1 to (length line_parts) by 4 do
                (setq tower_trans (cons (nth idx line_parts) tower_trans)))
            (setq towers_trans (cons tower_trans towers_trans))))
    (when (eq #\m (nth 0 (coerce line 'list)))
        (let* ((move-str (split-str line #\SPACE))
            (move (coerce move-str 'list)))
            (setq moves (append moves (list 
                (cons (parse-integer (nth 1 move))
                    (cons (parse-integer (nth 3 move))
                        (list (parse-integer (nth 5 move))))))))))
)

(dolist (tower (transpose towers_trans))
  (setq towers (append towers (list (reverse (remove #\SPACE tower)))))
)

(defvar towers-p1 (copy-list towers))
(defvar towers-p2 (copy-list towers))

(defun crane (part twrs)
    (dolist (move moves)
        (let ((tower-old (nth (- (nth 1 move) 1) twrs))
            (tower-new (nth (- (nth 2 move) 1) twrs)))
            (if (equal part "p1")
                ;; p1
                (loop for idx from 1 to (nth 0 move) do
                    (when (not (eq 0 (length tower-old)))
                        (progn
                            (setq tower-new (cons (car tower-old) tower-new))
                            (setq tower-old (cdr tower-old)))))
                ;; p2
                (let ((num-to-move (min (length tower-old) (nth 0 move))))
                    (setq tower-new (append (subseq tower-old 0 num-to-move) tower-new))
                    (setq tower-old (subseq tower-old num-to-move))
                )
            )
            (update-nth twrs (- (nth 1 move) 1) tower-old)
            (update-nth twrs (- (nth 2 move) 1) tower-new)
    ))
    (return-from crane twrs)
)

(dolist (tower (crane "p1" towers-p1)) (write (car tower)))
(terpri)
(dolist (tower (crane "p2" towers-p2)) (write (car tower)))
(terpri)
