;;;; Common library for useful functions

#||
This is how you block comment :)
||#

;;; read file into list
(defun read-file-lines (file)
  (with-open-file (stream file)
    (loop for line = (read-line stream nil)
      while line
      collect line
    )
  )
)

;;; Takes a string and a single character delimeter
(defun split-str (str del)
    (let ((idx (position del str)))
        (when (eq idx nil) (return-from split-str (list str)))
        (return-from split-str (cons (subseq str 0 idx) (split-str (subseq str (+ idx 1)) del)))
    )
)

;;; Transpose list of lists
(defun transpose (lst)
    (let ((lst_trans '()))
        (loop for idx from 0 to (- (length (nth 0 lst)) 1) do
            (let ((sublst '()))
                (loop for idx2 from 0 to (- (length lst) 1) do
                    (setq sublst (cons (nth idx (nth idx2 lst)) sublst)))
                (setq lst_trans (cons (reverse sublst) lst_trans))))
        (return-from transpose lst_trans))
)

;;; in place edit of element in list
(defun update-nth (lst n val)
  (setf (elt lst n) val) lst
)

;; sort pairs (only pairs of strings (D16)
(defun sorted-pairs (p1 p2)
    (equal (sort p1 'string<) (sort p2 'string<))
)

;;; all possible combinations of two lists (of strings)
(defun combinations (lst1 lst2 remove-same remove-dupes)
    (let ((combos '()))
        (dolist (el1 lst1)
            (dolist (el2 lst2)
                (tagbody
                (when (and (equal el1 el2) remove-same) (go skip))
                (setq combos (append combos (list (list el1 el2))))
                skip)))
        (if remove-dupes (remove-duplicates combos :test 'sorted-pairs) combos))
)

;;; my first copied code off of stack-overflow :(
(defun hash-keys (hash-map)
  (loop for key being the hash-keys of hash-map collect key))

(defstruct dijk-result
    (distance #xFFFFFFFF :type integer)
    (prev-node "" :type string))
(defun dijkstra (hash-map s-node search-key)
    ;; setup initial return map
    (let ((ret-hash-map (make-hash-table :test 'equal)))
    (setf (gethash s-node ret-hash-map) (make-dijk-result :distance 0 :prev-node ""))
    (dolist (h-key (hash-keys hash-map))
        (setf (gethash h-key ret-hash-map) (make-dijk-result :distance #xFFFFFFFF :prev-node "")))

    (let ((to-search (list s-node)))
        (loop while (not (zerop (length to-search))) do

            (let* ((n (car to-search))
                    (orig-map-item (gethash n hash-map))
                    (dijk-map-item (gethash n ret-hash-map))
                (cur-steps (dijk-result-distance dijk-map-item)))

                (dolist (neighbor (search-key orig-map-item))
                    (let* ((nei-n (gethash neighbor ret-hash-map))
                        (when (> (dijk-result-distance nei-n) (+ cur-steps 1))
                            (progn
                                (setf (dijk-result-distance nei-n) (+ cur-steps 1))
                                (setq (dijk-result-prev-node nei-n) n)
                                (setq to-search (append to-search (list neighbor)))))))))
            (setq to-search (cdr to-search))))
    (node-distance-from-S (gethash end-node elev-map)))
)

(defvar *input* (read-file-lines "input.txt"))

