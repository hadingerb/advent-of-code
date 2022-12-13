;;;; Advent of Code Day 8: Treehouse hunt
(load "../common.lsp")

(defvar elevation-map (make-hash-table :test 'equal))

(defvar start-node nil)
(defvar end-node nil)
(defvar a-s '())

(defstruct node
    (value #\a :type character)
    (neighbors '() :type list)
    (distance-from-S #xFFFFFFFF :type integer))


;; read input as a hashmap with neighbors
(loop for row from 0 to (- (length *input*) 1) do
    (let ((elements (coerce (nth row *input*) 'list)))
        (loop for col from 0 to (- (length elements) 1) do
            (let* (
                (up    (if (not (eq 0 row))                        (format nil "~d-~d" (- row 1) col) nil))
                (down  (if (not (eq (- (length *input*) 1) row))   (format nil "~d-~d" (+ row 1) col) nil))
                (left  (if (not (eq 0 col))                        (format nil "~d-~d" row (- col 1)) nil))
                (right (if (not (eq (- (length elements) 1) col))  (format nil "~d-~d" row (+ col 1)) nil))
                (element (nth col elements))
                (key (format nil "~d-~d" row col))
                (element-node (make-node :value element :neighbors (remove nil (list up down left right)))))
                    (setf (gethash key elevation-map) element-node)
                    (when (eq #\S element) (setq start-node key))
                    (when (eq #\E element) (setq end-node key))
                    (when (or (eq #\S element) (eq #\a element)) (setq a-s (cons key a-s))))))
)

(setf (node-value (gethash start-node elevation-map)) #\a)
(setf (node-value (gethash end-node elevation-map)) #\z)

(defun elevation-dijkstra (elev-map s-node)
    (setf (node-distance-from-S (gethash s-node elev-map)) 0)
    (let ((to-search (list s-node)))
        (loop while (not (zerop (length to-search))) do
            (let* ((n (gethash (car to-search) elev-map))
                (cur-steps (node-distance-from-S n)))
                (dolist (neighbor (node-neighbors n))
                    (let* ((nei-n (gethash neighbor elev-map))
                        (difference (- (char-code (node-value nei-n)) (char-code (node-value n)))))
                            (when (and (<= difference 1) (> (node-distance-from-S nei-n) (+ cur-steps 1)))
                                (progn
                                    (setf (node-distance-from-S (gethash neighbor elev-map)) (+ cur-steps 1))
                                    (setq to-search (append to-search (list neighbor))))))))
            (setq to-search (cdr to-search))))
    (node-distance-from-S (gethash end-node elev-map))
)

(write (elevation-dijkstra elevation-map start-node)) (terpri)

(defvar steps '())
(dolist (a a-s)
    (loop for row from 0 to (- (length *input*) 1) do
        (let ((elements (coerce (nth row *input*) 'list)))
            (loop for col from 0 to (- (length elements) 1) do
                (setf (node-distance-from-S (gethash (format nil "~d-~d" row col) elevation-map)) #xFFFFFFFF))))
    (setq steps (cons (elevation-dijkstra elevation-map a) steps))
)
(write (car (sort steps '<)))(terpri)
