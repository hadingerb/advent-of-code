;;;; Advent of Code Day 4: Cleaning Camp
(load "../common.lsp")

(defvar complete-overlapping 0)
(defvar partial-overlapping 0)

;;; each pairing is "AA-BB,XX-YY"
(dolist (pairing *input*)
    (let* ((pairs (split-str pairing #\,))
        (lo-fir (parse-integer (nth 0 (split-str (nth 0 pairs) #\-))))
        (hi-fir (parse-integer (nth 1 (split-str (nth 0 pairs) #\-))))
        (lo-sec (parse-integer (nth 0 (split-str (nth 1 pairs) #\-))))
        (hi-sec (parse-integer (nth 1 (split-str (nth 1 pairs) #\-)))))

        ;;(format t "~a ~a ~a ~a ~a~%" pairing lo-fir hi-fir lo-sec hi-sec)
        ;; complete
        (when (or (and (<= lo-fir lo-sec) (>= hi-fir hi-sec)) 
                    (and (<= lo-sec lo-fir) (>= hi-sec hi-fir))) 
            (setq complete-overlapping (+ complete-overlapping 1)))
        ;; partial
        (when (or (and (>= hi-fir lo-sec) (and (< lo-fir lo-sec) (< hi-fir hi-sec)))
                    (and (>= hi-sec lo-fir) (and (< lo-sec lo-fir) (< hi-sec hi-fir)))) 
            (setq partial-overlapping (+ partial-overlapping 1)))
    )
)

(format t "~d~%" complete-overlapping)
(format t "~d~%" (+ complete-overlapping partial-overlapping))
