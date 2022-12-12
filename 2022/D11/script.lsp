;;;; Advent of Code Day 8: Treehouse hunt
(load "../common.lsp")

(defvar monkeys '())
;make-hash-table))

(defvar cur-monkey 0)

;;gethash key hash-table
(dolist (monkey-data *input*)
    (let* ((value (nth 1 (split-str monkey-data #\:)))
        (parts (cdr (split-str value #\SPACE))))
        (cond ((eq 0 (search "Monkey"  monkey-data))
                (progn 
                    (setq monkeys (append monkeys (list (make-hash-table))))
                    (setq cur-monkey (parse-integer (car (split-str (nth 1 (split-str monkey-data #\SPACE)) #\:))))
                    (setf (gethash 'count-checks (nth cur-monkey monkeys)) 0)))
            ((eq 2 (search "Starting"  monkey-data))
                (let ((its '()))
                    (dolist (item parts)
                       (setq its (append its (list (parse-integer (car (split-str item #\,)))))))
                    (setf (gethash 'items (nth cur-monkey monkeys)) its)))
            ((eq 2 (search "Operation" monkey-data))
                (let ((op-parts (cdr (cdr (cdr parts)))))
                    (setf (gethash 'op (nth cur-monkey monkeys)) op-parts)))
            ((eq 2 (search "Test"      monkey-data))
                (setf (gethash 'test (nth cur-monkey monkeys)) (parse-integer (car (last parts)))))
            ((eq 4 (search "If true"   monkey-data))
                (setf (gethash 'success (nth cur-monkey monkeys)) (parse-integer (car (last parts)))))
            ((eq 4 (search "If false"  monkey-data))
                (setf (gethash 'failure (nth cur-monkey monkeys)) (parse-integer (car (last parts)))))
        )
    )
)

(defvar divisor 1)
(dolist (monkey monkeys)
  (setq divisor (* divisor (gethash 'test monkey)))
)
(write divisor) (terpri)

;;; p1 (20) p2 (10000)
(loop for rnd from 1 to 10000 do
    (dolist (monkey monkeys)
        (let ((items (gethash 'items monkey))
            (op (gethash 'op monkey))
            (test (gethash 'test monkey))
            (success (gethash 'success monkey))
            (failure (gethash 'failure monkey))

            (cur-item 0))
            (dolist (item items)
                ;; increase worry
                (if (not (eq nil (search "old" (nth 1 op))))
                        (setq cur-item (apply (symbol-function (intern (nth 0 op))) (list item item)))
                    (setq cur-item (apply (symbol-function (intern (nth 0 op))) (list item (parse-integer (nth 1 op))))))

                ;; p1
                (setf (gethash 'count-checks monkey) (+ (gethash 'count-checks monkey) 1))

                ;; get bored
; p1
;                (setq cur-item (floor (/ cur-item 3)))
; p2
                (setq cur-item (floor (rem cur-item divisor)))

                ;; check worry && move
                (let ((next-monkey 0))
                    (if (zerop (rem cur-item test))
                            (setq next-monkey success)
                        (setq next-monkey failure))
                    (setf (gethash 'items monkey) (cdr (gethash 'items monkey)))
                    (setf (gethash 'items (nth next-monkey monkeys))
                        (append (gethash 'items (nth next-monkey monkeys)) (list cur-item)))
                )
            )
        )
;        (when (zerop (rem rnd 1))(format t "rnd ~d -- ~d~%" rnd (gethash 'count-checks monkey)))
    )

)

(dolist (monkey monkeys)
    (format t "~d~%" (gethash 'count-checks monkey))
)
