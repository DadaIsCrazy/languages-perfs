#! /usr/bin/env racket
#lang racket

(define mmax 1000000000)
(define mmax_sqrt 31623)

(define nums (make-vector mmax #f))

;; 0 and 1 are not primes
(vector-set! nums 0 #t)
(vector-set! nums 1 #t)

;; Computing prime numbers
(for ([i (in-range 2 mmax_sqrt)])
  (when (eq? (vector-ref nums i) #f)
    (for ([j (in-range (* i 2) mmax i)])
      (vector-set! nums j #t))))

;; Counting prime numbers
(define total (vector-count (lambda (x) (not x)) nums))
(printf "Total: ~a\n" total)
