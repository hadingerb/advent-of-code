;;;; Advent of Code Day 8: Treehouse hunt
(load "../common.lsp")


;;; possible values: " " -- empty, "#" -- rock, "o" -- sand, "+" -- start
(defstruct cell
    (value " " :type string)
    (l nil :type string)
    (m nil :type string)
    (r nil :type string))

;;; setup
(defvar rock-walls '())
(defvar min-width 999999)
(defvar max-width 0)
(defvar max-height 0)

;;; build initial map (all empty)
(defvar cave-map (make-hash-table :test 'equal))

;;; print out
(defun print-map (m)
    (loop for y from 0 to max-height do
        (loop for x from min-width to max-width do
            (format t "~a" (cell-value (gethash (format nil "~d-~d" x y) cave-map))))
        (terpri)
    )
)

;;; read in input for walls and max width/height
(defun get-walls (line)
    (let ((parts (split-str line #\SPACE)) (corners '()))
        (loop for idx from 0 to (length parts) by 2 do
            (let* ((pair (nth idx parts)) (pair-parts (split-str pair #\,))
                    (x (parse-integer (nth 0 pair-parts))) (y (parse-integer (nth 1 pair-parts))))
                (setq corners (cons (list x y) corners))
                (setq min-width (min min-width x))
                (setq max-width (max max-width x))
                (setq max-height (max max-height y))
        ))
        corners
    )
)

(dolist (line *input*)
    (setq rock-walls (cons (get-walls line) rock-walls))
)

(loop for y from 0 to (+ max-height 2) do
    (loop for x from 0 to (* max-width 2) do
        (setf (gethash (format nil "~d-~d" x y) cave-map)
            (make-cell :value " "
                    :l (format nil "~d-~d" (- x 1) (+ y 1))
                    :m (format nil "~d-~d" x (+ y 1))
                    :r (format nil "~d-~d" (+ x 1) (+ y 1))))
))

(dolist (wall rock-walls)
    (loop for corner from 0 to (- (length wall) 2) do
        (let* ((x-fir (nth 0 (nth corner wall)))
            (x-sec (nth 0 (nth (+ corner 1) wall)))
            (y-fir (nth 1 (nth corner wall)))    
            (y-sec (nth 1 (nth (+ corner 1) wall)))
            (x-min (min x-fir x-sec)) (x-max (max x-fir x-sec))
            (y-min (min y-fir y-sec)) (y-max (max y-fir y-sec)))

            (loop for x from x-min to x-max do
                (loop for y from y-min to y-max do
                    (setf (cell-value (gethash (format nil "~d-~d" x y) cave-map)) "#")
)))))

;;; p2
(loop for x from 0 to (* max-width 2) do
    (setf (cell-value (gethash (format nil "~d-~d" x (+ max-height 2)) cave-map)) "#")
)

(defvar sand 0)

(defun move-sand (key)
    ;; print where sand is now
    (let ((element (gethash key cave-map)))
        (let ((left (cell-l element))
            (middle (cell-m element))
            (right  (cell-r element)))
            ;; when full
            (when (and (equal key "500-0") (equal "o" (cell-value element))) (return-from move-sand nil))

            (setf (cell-value element) "o")
            ;(print-map cave-map)
            ;(sleep 0.02)


            ;; if at bottom, return false
            (when (eq nil (gethash middle cave-map)) (return-from move-sand nil))
            (cond ((equal " " (cell-value (gethash middle cave-map)))
                    (progn (setf (cell-value element) " ") (move-sand middle)))
                ((equal " " (cell-value (gethash left cave-map)))
                    (progn (setf (cell-value element) " ") (move-sand left)))
                ((equal " " (cell-value (gethash right cave-map)))
                    (progn (setf (cell-value element) " ") (move-sand right)))
                (t t))
    ))
)

(write (+ max-height 2)) (terpri)

(loop while (move-sand "500-0") do
  (incf sand)
)
(write sand) (terpri)
