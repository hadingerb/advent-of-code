;;;; Advent of Code Day 8: Treehouse hunt
(load "../common.lsp")

(defvar visited-positions '())
;; p1
;(defvar rope '((0 0) (0 0)))
;; p2
(defvar rope '((0 0) (0 0) (0 0) (0 0) (0 0) (0 0) (0 0) (0 0) (0 0) (0 0)))

(defun move-rope (prev cur direction)
    (let ((difference (mapcar #'- prev cur)))
       (cond ((equal difference '(-2 0)) (setq cur (mapcar #'+ cur '(-1 0)))); prev 2 up (move cur up)          12
            ((equal difference '(2 0))   (setq cur (mapcar #'+ cur '(1 0)))); prev 2 down (move cur down)       6
            ((equal difference '(0 -2))  (setq cur (mapcar #'+ cur '(0 -1)))); prev two left (move cur left)    9
            ((equal difference '(0 2))   (setq cur (mapcar #'+ cur '(0 1)))); prev two right (move cur right)   3
            ((or (equal difference '(-2 -1)) (equal difference '(-1 -2))); prev to top left                     10,11
                (setq cur (mapcar #'+ cur '(-1 -1))))
            ((or (equal difference '(-2 1)) (equal difference '(-1 2))); prev to top right                      1,2
                (setq cur (mapcar #'+ cur '(-1 1))))
            ((or (equal difference '(2 -1)) (equal difference '(1 -2))); prev to bottom left                    7,8
                (setq cur (mapcar #'+ cur '(1 -1))))
            ((or (equal difference '(2 1)) (equal difference '(1 2))); prev to bottom right                     4,5
                (setq cur (mapcar #'+ cur '(1 1))))
            ((or (equal difference '(-2 -2)) (equal difference '(1 2))); prev to bottom right                   10.5
                (setq cur (mapcar #'+ cur '(-1 -1))))
            ((or (equal difference '(-2 2)) (equal difference '(1 2))); prev to bottom right                    1.5
                (setq cur (mapcar #'+ cur '(-1 1))))
            ((or (equal difference '(2 -2)) (equal difference '(1 2))); prev to bottom right                    7.5
                (setq cur (mapcar #'+ cur '(1 -1))))
            ((or (equal difference '(2 2)) (equal difference '(1 2))); prev to bottom right                     4.5
                (setq cur (mapcar #'+ cur '(1 1))))

            )
    )
    cur
)

(dolist (action *input*)
    (let* ((action-parts (split-str action #\SPACE))
        (direction (nth 0 action-parts))
        (amount (parse-integer (nth 1 action-parts))))

        (loop for n from 1 to amount do 
            (cond ((equal "U" direction) (update-nth rope 0 (mapcar #'+ (nth 0 rope) '(-1 0)))); move head up
                ((equal "D" direction)   (update-nth rope 0 (mapcar #'+ (nth 0 rope) '(1 0)))); move head down
                ((equal "L" direction)   (update-nth rope 0 (mapcar #'+ (nth 0 rope) '(0 -1)))); move head left
                ((equal "R" direction)   (update-nth rope 0 (mapcar #'+ (nth 0 rope) '(0 1))))); move head right

            (loop for m from 1 to (- (length rope) 1) do
               (update-nth rope m (move-rope (nth (- m 1) rope) (nth m rope) direction)) 
            )
            ;;(format t "~a~%" rope)
            (setq visited-positions (cons (nth (- (length rope) 1) rope) visited-positions))
        )
    )
)

(defvar unique-positions (remove-duplicates (reverse visited-positions) :test #'equal))
(write (length unique-positions)) (terpri)


