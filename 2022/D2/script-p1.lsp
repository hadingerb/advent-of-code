;;;; Advent of Code Day 2: Rock Paper Sissors
(load "../common.lsp")

;;; p1
(defvar A 1)
(defvar B 2)
(defvar C 3)

(defvar X 1)
(defvar Y 2)
(defvar Z 3)

;;; outcome of match
(defvar out 0)
(defun outcome(them me)
    (setq out (- (symbol-value (intern me)) (symbol-value (intern them))))
        ;; draw
    (cond ( (zerop out) (return-from outcome 3))
        ;; win
        ( (or (and (plusp out) (oddp out)) (and (minusp out) (evenp out))) (return-from outcome 6))
        ;; lose
        (t (return-from outcome 0))
    )
)

(defvar score 0)
(loop for result in *input* do
  (setq score (+ score (outcome (subseq result 0 1) (subseq result 2))))
  (setq score (+ score (symbol-value (intern (subseq result 2)))))
)

(write score)
(terpri)
