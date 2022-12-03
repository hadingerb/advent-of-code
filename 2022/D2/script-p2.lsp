;;;; Advent of Code Day 2: Rock Paper Sissors
(load "../common.lsp")

;;; p2
(defvar A 1)
(defvar B 2)
(defvar C 3)

(defvar X 0)
(defvar Y 3)
(defvar Z 6)

;;; outcome of match
(defvar them 0)
(defvar out 0)
(defun outcome(them_str result)
    (setq them (symbol-value (intern them_str)))
    (cond ( (string= result "X") (setq out (rem (- them 1) 3)))
          ( (string= result "Y") (setq out them))
          ( (string= result "Z") (setq out (rem (+ them 1) 3)))
    )
    (when (eq out 0) (setq out 3))
    (return-from outcome out)
)

(defvar score 0)
(loop for result in *input* do
  (setq score (+ score (outcome (subseq result 0 1) (subseq result 2))))
  (setq score (+ score (symbol-value (intern (subseq result 2)))))
)

(write score)
(terpri)
