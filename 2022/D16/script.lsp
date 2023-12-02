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

(defun flow-to-add (open-valves)
    (let ((flow 0))
        (dolist (open-valv open-valves)
            (setq flow (+ flow (valve-rate (gethash open-valv valves)))))
        flow))

;;; p1
(defun open-valve (valv open-valves time-left)
    ;; if valve has no rate or already opened, do nothing
    (if (or (zerop (valve-rate (gethash valv valves))) (not (eq nil (position valv open-valves :test 'equal))))
        (values 0 open-valves time-left)
        (values (flow-to-add open-valves) (cons valv open-valves) (decf time-left)))
)

(defun navigate (valv open-valves visited-valves time-left)
    (setq visited-valves (remove-duplicates (cons valv visited-valves) :test 'equal))
    ;; if time has run out, return 0
    (when (zerop time-left) (return-from navigate 0))

    ;; attempt to open current valve
    (multiple-value-bind (new-flow open-valves time-left) (open-valve valv open-valves time-left)
        ;; if time ran out after opening pipe, return
        (when (zerop time-left) (return-from navigate new-flow))
        ;;move
        (setq new-flow (+ new-flow (flow-to-add open-valves)))
        (decf time-left)

        ;; when all valves are open, or all valves have been visited, just sit and keep them open
        (when (or (eq (length open-valves) (length openable-valves)) (eq (length visited-valves) num-valves))
            (return-from navigate (+ new-flow (navigate valv open-valves visited-valves time-left))))

        ;; where are we moving to? try to visit unvisited valves if possible
        (let* ((subdir-flow 0)
            (neighbors (valve-leads-to (gethash valv valves)))
            (unvisited-neighbors (set-difference neighbors visited-valves :test 'equal)))
            (dolist (v (if (not (zerop (length unvisited-neighbors))) unvisited-neighbors neighbors))
                (setq subdir-flow (max subdir-flow (navigate v open-valves visited-valves time-left))))
            (return-from navigate (+ new-flow subdir-flow)))
    ))

;;; p2
(defun no-rate (valv)
  (eq 0 (valve-rate (gethash valv valves)))
)

(defun navigate-ele (valv-me valv-ele prev-valv-me prev-valv-ele open-valves visited-valves time-left)
    (setq visited-valves (remove-duplicates (cons valv-me (cons valv-ele visited-valves)) :test 'equal))
    (when (zerop time-left) (return-from navigate-ele 0))

    (let ((new-flow (flow-to-add open-valves)) (stay-me t) (stay-ele t))
    ;;; me
        ;; if valve rate 0 or valve already open, move
        (if (or (zerop (valve-rate (gethash valv-me valves))) (not (eq nil (position valv-me open-valves :test 'equal))))
            (setq stay-me nil)
            ;; if valve closed and useful, open
            (setq open-valves (cons valv-me open-valves)))
    ;;; ele
        ;; if valve rate 0 or valve already open, move
        (if (or (zerop (valve-rate (gethash valv-ele valves))) (not (eq nil (position valv-ele open-valves :test 'equal))))
            (setq stay-ele nil)
            ;; if valve closed and useful, open
            (setq open-valves (cons valv-ele open-valves)))
        (decf time-left)

        (when (zerop time-left) (return-from navigate-ele new-flow))

        ;; when all valves are open, or all valves have been visited, just sit and keep them open
        (when (or (eq (length open-valves) (length openable-valves)) (eq (length visited-valves) num-valves))
            (return-from navigate-ele (+ new-flow (navigate-ele valv-me valv-ele valv-me valv-ele open-valves visited-valves time-left))))

        (let* ((subdir-flow 0)
            (neighbors-me (valve-leads-to (gethash valv-me valves)))
            (neighbors-ele (valve-leads-to (gethash valv-ele valves)))

            (unvisited-neighbors-me (set-difference neighbors-me visited-valves :test 'equal))
            (unvisited-neighbors-ele (set-difference neighbors-ele visited-valves :test 'equal))

;            (unvisited-flow-me (remove-if 'no-rate unvisited-neighbors-me))
;            (unvisited-flow-ele (remove-if 'no-rate unvisited-neighbors-ele))

            (will-visit-me (cond (stay-me (list valv-me))
;                            ((not (zerop (length unvisited-flow-me))) unvisited-flow-me)
                            ((not (zerop (length unvisited-neighbors-me))) unvisited-neighbors-me)
                            ((not (eq 1 (length neighbors-me))) (remove prev-valv-me neighbors-me :test 'equal))
                            (t neighbors-me)))
            (will-visit-ele (cond (stay-ele (list valv-ele))
;                            ((not (zerop (length unvisited-flow-ele))) unvisited-flow-ele)
                            ((not (zerop (length unvisited-neighbors-ele))) unvisited-neighbors-ele)
                            ((not (eq 1 (length neighbors-ele))) (remove prev-valv-ele neighbors-ele :test 'equal))
                            (t neighbors-ele)))

            (visit-pairs (combinations will-visit-me will-visit-ele t t)))
            (dolist (v-pair visit-pairs)
                (setq subdir-flow (max subdir-flow (navigate-ele (car v-pair) (car (cdr v-pair)) valv-me valv-ele open-valves visited-valves time-left))))
            (return-from navigate-ele (+ new-flow subdir-flow))))
)


;(write (navigate "AA" '() '() 30))(terpri)
(write (navigate-ele "AA" "AA" nil nil '() '() 26))(terpri)
