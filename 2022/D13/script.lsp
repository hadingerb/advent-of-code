;;;; Advent of Code Day 8: Treehouse hunt
(load "../common.lsp")

(defstruct pair
    (idx 0 :type integer)
    (left '() :type list)
    (right '() :type list))

(defun str-to-list (str)
  (read-from-string (substitute #\( #\[ (substitute #\) #\] (substitute #\SPACE #\, str))))
)

(defvar pairs '())
(defvar all-lists '())

(loop for pair-idx from 0 to (length *input*) by 3 do
    (let ((left-pair (str-to-list (nth pair-idx *input*)))
        (right-pair (str-to-list (nth (+ 1 pair-idx) *input*))))

        (setq all-lists (append all-lists (list left-pair right-pair)))

        (setq pairs (append pairs (list (make-pair
                                            :idx (+ 1 (/ pair-idx 3))
                                            :left left-pair
                                            :right right-pair)))))
)


(defun less-than (left right)
    ;; nothing in both lists
    (when (and (zerop (length left)) (zerop (length right))) (return-from less-than 0))
    ;; left list ended
    (when (and (zerop (length left)) (not (zerop (length right)))) (return-from less-than 1))
    ;; right list ended
    (when (and (zerop (length right)) (not (zerop (length left)))) (return-from less-than -1))

    ;; both lists have at least one element
    (let ((fl (car left)) (fr (car right))
          (rl (cdr left)) (rr (cdr right)))

            ;; both integers
        (cond ((and (typep fl 'integer) (typep fr 'integer)) 
                (cond ((< fl fr) 1)
                      ((> fl fr) -1)
                      (t (less-than rl rr))))
            ;; both lists
            ((and (typep fl 'list) (typep fr 'list))
                (let ((result (less-than fl fr)))
                    (and (or (zerop result) (return-from less-than result)) (less-than rl rr))))
            ;; one integer
            ((and (typep fl 'list) (typep fr 'integer))
                (let ((result (less-than fl (list fr))))
                    (and (or (zerop result) (return-from less-than result)) (less-than rl rr))))
            ((and (typep fl 'integer) (typep fr 'list))
                (let ((result (less-than (list fl) fr)))
                    (and (or (zerop result) (return-from less-than result)) (less-than rl rr))))))
)

(defun less-than-wrapper (left right)
  (>= (less-than left right) 0)
)

(defvar total 0)

;;; p1
(dolist (pr pairs)
    (when (less-than-wrapper (pair-left pr) (pair-right pr))
        (setq total (+ total (pair-idx pr))))
)
(write total) (terpri)

;;; p2
(defvar sorted-lists (sort (append all-lists (list '((2)) '((6)))) 'less-than-wrapper))
(write (* (+ 1 (position '((2)) sorted-lists :test 'equal)) (+ 1 (position '((6)) sorted-lists :test 'equal)))) (terpri)
