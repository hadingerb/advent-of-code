;;;; Advent of Code Day 3: Rucksack sabatoge
(load "../common.lsp")

(defvar alphabet (coerce "!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" 'list))

;; part1
(defvar common_priority 0)
(dolist (sack *input*)
    ;; split compartments in half
    (let ((compartment1 (subseq sack 0 (/ (length sack) 2)))
        (compartment2 (subseq sack (/ (length sack) 2))))

        ;;(format t "~a -- ~a~%" compartment1 compartment2)
        ;; get common letter and add "priority" to score
        (let ((common (car (intersection (coerce compartment1 'list) (coerce compartment2 'list)))))
            ;;(format t "~a ~d~%" common (position common alphabet))
            (setq common_priority (+ common_priority (position common alphabet)))
        )
    )
)
(format t "~d~%" common_priority)

;; part2
(defvar group_priority_total 0)
(loop for sack_index from 0 to (length *input*) by 3 do
  ;;(format t "~a -- ~a -- ~a~%" (nth sack_index *input*) (nth (+ 1 sack_index) *input*) (nth (+ 2 sack_index) *input*))
    ;; go by every three elves and assign a sack to them
    (let* ((elf1 (nth sack_index *input*))
        (elf2 (nth (+ 1 sack_index) *input*))
        (elf3 (nth (+ 2 sack_index) *input*))
        ;; retrieve common letter
        (common_type (car (intersection (coerce elf1 'list) (intersection (coerce elf2 'list) (coerce elf3 'list))))))

        ;; validate not nil and add to score
        (when (not (equal common_type nil)) (setq group_priority_total (+ group_priority_total (position common_type alphabet))))
    )
)
(format t "~d~%" group_priority_total)
