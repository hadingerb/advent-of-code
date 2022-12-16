;;;; Advent of Code Day 8: Treehouse hunt
(load "../common.lsp")

(defstruct beacon
  (x 0 :type integer)
  (y 0 :type integer))

(defstruct sensor
  (x 0 :type integer)
  (y 0 :type integer)
  (closest-beacon nil :type beacon)
  (distance-to-beacon 0 :type integer))

(defvar beacons '())
(defvar sensors '())
;; just outside of sensor paths

(dolist (line *input*)
    (let* ((cleansed-line (substitute #\SPACE #\= (substitute #\SPACE #\, (substitute #\SPACE #\: line))))
        (parts (split-str cleansed-line #\SPACE))
        (sens-x (parse-integer (nth 3  parts))) (sens-y (parse-integer (nth 6  parts)))
        (beac-x (parse-integer (nth 13 parts))) (beac-y (parse-integer (nth 16 parts)))
        (beac (make-beacon
            :x beac-x
            :y beac-y))
        (sens (make-sensor
            :x sens-x
            :y sens-y
            :closest-beacon beac
            :distance-to-beacon (+ (abs (- sens-x beac-x)) (abs (- sens-y beac-y))))))

        (setq beacons (cons beac beacons))
        (setq sensors (cons sens sensors))
    )
)


;(defvar orig-min-val 0)
;(defvar orig-max-val 20) 
(defvar orig-min-val 0)
(defvar orig-max-val 4000000) 

;(defvar scan-y 10)
(defvar scan-y 2000000)
(defvar min-val orig-max-val)
(defvar max-val orig-min-val)

;;; get range to search
(dolist (sens sensors)
  (setq min-val (min min-val (- (sensor-x sens) (sensor-distance-to-beacon sens))))
  (setq max-val (max max-val (+ (sensor-x sens) (sensor-distance-to-beacon sens)))) 
)

(defvar non-beacons 0)


(loop for y from scan-y to scan-y do
    (loop for x from min-val to max-val do
        (tagbody
            (dolist (beac beacons)
                (when (and (eq (beacon-x beac) x) (eq (beacon-y beac) y))
                    (go skip)))

            (dolist (sens sensors)
                (let ((dist-x-sens (+ (abs (- (sensor-x sens) x)) (abs (- (sensor-y sens) y)))))
                    (when (<= dist-x-sens (sensor-distance-to-beacon sens))
                        (progn (incf non-beacons) (go skip)))))
            skip
        )
    )
)
(write non-beacons)(terpri)

(setq min-val orig-min-val)
(setq max-val orig-max-val)

(defun freq (x y) (+ (* x orig-max-val) y))

(dolist (sens sensors)
    (let ((sens-x (sensor-x sens)) (sens-y (sensor-y sens)))
        (loop for diff-x from 0 to (+ (sensor-distance-to-beacon sens) 1) do
            (let* ((diff-y (- (+ (sensor-distance-to-beacon sens) 1) diff-x)))
;(format t "~d ~d ~d ~d~%" sens-x sens-y diff-x diff-y)
;; validated up to here
                (let ((x (+ sens-x diff-x)) (y (+ sens-y diff-y)))
;(format t "~d ~d~%" x y)
                    (tagbody
                    (dolist (sens-check sensors)
                        (when (<= (+ (abs (- (sensor-x sens-check) x)) (abs (- (sensor-y sens-check) y))) (sensor-distance-to-beacon sens-check)) (go skip-val)))
                    (when (and (<= min-val x max-val) (<= min-val y max-val)) (progn (format t "Result: ~d ~d ~d~%" x y (freq x y)) (exit)))
                    skip-val))
                (let ((x (+ sens-x diff-x)) (y (- sens-y diff-y)))
;(format t "~d ~d~%" x y)
                    (tagbody
                    (dolist (sens-check sensors)
                        (when (<= (+ (abs (- (sensor-x sens-check) x)) (abs (- (sensor-y sens-check) y))) (sensor-distance-to-beacon sens-check)) (go skip-val)))
                    (when (and (<= min-val x max-val) (<= min-val y max-val)) (progn (format t "Result: ~d ~d ~d~%" x y (freq x y)) (exit)))
                    skip-val))
                (let ((x (- sens-x diff-x)) (y (+ sens-y diff-y)))
;(format t "~d ~d~%" x y)
                    (tagbody
                    (dolist (sens-check sensors)
                        (when (<= (+ (abs (- (sensor-x sens-check) x)) (abs (- (sensor-y sens-check) y))) (sensor-distance-to-beacon sens-check)) (go skip-val)))
                    (when (and (<= min-val x max-val) (<= min-val y max-val)) (progn (format t "Result: ~d ~d ~d~%" x y (freq x y)) (exit)))
                    skip-val))
                (let ((x (- sens-x diff-x)) (y (- sens-y diff-y)))
;(format t "~d ~d~%" x y)
                    (tagbody
                    (dolist (sens-check sensors)
                        (when (<= (+ (abs (- (sensor-x sens-check) x)) (abs (- (sensor-y sens-check) y))) (sensor-distance-to-beacon sens-check)) (go skip-val)))
                    (when (and (<= min-val x max-val) (<= min-val y max-val)) (progn (format t "Result: ~d ~d ~d~%" x y (freq x y)) (exit)))
                    skip-val))
            )
        )
    )
)
