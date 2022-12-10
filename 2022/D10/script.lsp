;;;; Advent of Code Day 8: Treehouse hunt
(load "../common.lsp")

(defvar X 1)
;;; techincally cycle starts at 0 but this represents
;;; the running of the current "first cycle"
(defvar cycle 0)
(defvar sum 0)

;;; p1
(defvar checks '(20 60 100 140 180 220))

;;; p2
(defvar CRT "")

(defun check-cycle ()
    ;; p1
    (when (not (eq nil (position (+ cycle 1) checks)))
        (setq sum (+ sum (* X (+ cycle 1)))))

    ;; p2
    (format t "~d ~d~%" (rem cycle 40) X)
    (if (not (eq nil (position (rem cycle 40) (list (- X 1) X (+ X 1)))))
        (setq CRT (concatenate 'string CRT "#"))
        (setq CRT (concatenate 'string CRT ".")))
)

(dolist (command *input*)
    (if (equal "noop" command)
        (progn (check-cycle)(incf cycle))
        (progn (check-cycle)(incf cycle)
               (check-cycle)(incf cycle)
               (setq X (+ X (parse-integer (nth 1 (split-str command #\SPACE)))))))
)

;;; p1
(format t "~d~%" sum)


;;; p2
(format t "~a~%~a~%~a~%~a~%~a~%~a~%"
    (subseq CRT 0 40)
    (subseq CRT 40 80)
    (subseq CRT 80 120)
    (subseq CRT 120 160)
    (subseq CRT 160 200)
    (subseq CRT 200 240))
