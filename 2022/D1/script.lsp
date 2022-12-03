;;;; Advent of Code Day 1: Elf with largest calorie count and how many calories
(load "../common.lsp")

(defvar max_cal '())
(defvar current_cal 0)

(loop for calorie_count in *input* do
    (cond ( (= (length calorie_count) 0)
            (setq max_cal (append max_cal (list current_cal)))
            (setq current_cal 0)
            (when (eq calorie_count nil) (return 0)))
          (t (setq current_cal (+ current_cal (parse-integer calorie_count))))
    )
) 

(defvar sorted_cals (sort max_cal '>))

(write (car sorted_cals))
(terpri)
(write (+ (car sorted_cals) (+ (car (cdr sorted_cals)) (car (cdr (cdr sorted_cals))))))
(terpri)
