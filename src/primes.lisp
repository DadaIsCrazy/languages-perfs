(defvar mmax (parse-integer (cadr *posix-argv*)))

(defun for-step (f i j s)
  (if (>= i j)
      ()
    (progn
      (funcall f i)
      (for-step f (+ i s) j s))))


(defvar nums (make-array mmax :initial-element nil))

;; 0 and 1 are not primes
(setf (aref nums 0) t)
(setf (aref nums 1) t)

;; Computing prime numbers
(for-step (lambda (i)
            (if (aref nums i)
                ()
                (for-step (lambda (j) (setf (aref nums j) t)) (* i 2) mmax i)
                ))
          2 (sqrt mmax) 1)

;; Counting prime numbers
(defvar total 0)
(for-step (lambda (i) (if (aref nums i)
                          ()
                        (incf total))) 0 (- mmax 1) 1)

(format t "~D" total)
