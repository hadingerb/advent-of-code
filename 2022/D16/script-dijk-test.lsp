;;;; Advent of Code Day 8: Treehouse hunt

(load "../common.lsp")

(defvar valves (make-hash-table :test 'equal))
(defvar openable-valves '())
(defstruct valve
  (rate 0 :type integer)
  (leads-to nil :type list))

(dolist (line *input*)
    (let* ((parts (split-str line #\SPACE))
        (v (nth 1 parts))
        (rate-str (nth 4 parts))
        (rate (parse-integer (subseq rate-str (+ (position #\= rate-str) 1) (position #\; rate-str))))
        (parts-rev (reverse parts))
        (valves-to '()))

        (loop while (not (search "valve" (car parts-rev))) do 
            (setq valves-to (cons (nth 0 (split-str (car parts-rev) #\,)) valves-to))
            (setq parts-rev (cdr parts-rev)))

        (setf (gethash v valves) (make-valve :rate rate :leads-to valves-to))
        (when (not (zerop rate)) (setq openable-valves (cons v openable-valves)))))

(defvar num-valves (hash-table-count valves))

(write (dijkstra valves "AA" 'valve-leads-to))(terpri)
