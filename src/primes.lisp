(defvar mmax (parse-integer (cadr *posix-argv*)))

(defvar nums (make-array mmax :initial-element nil))

;; 0 and 1 are not primes
(setf (aref nums 0) t)
(setf (aref nums 1) t)

;; Computing prime numbers
(loop for i from 2 to (sqrt mmax) by 1 do
      (when (not (aref nums i))
        (loop for j from (* i 2) to (- mmax 1) by i do
              (setf (aref nums j) t))))

;; Counting prime numbers
(defvar total 0)
(loop for i from 0 to (- mmax 1) do
      (when (not (aref nums i))
          (incf total)))

(print total)
