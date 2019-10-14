;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname abstraction) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; List Abstraction Practice ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~
;~ Do NOT write *any* RECURSIVE FUNCTIONS in this file. ;~
;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~

(require 2htdp/image)


;; Use `map` to write this function:

; build-straight-line : Number [List-of Number] -> [List-of Posn]
; Returns a list of positions where `x` is every x coordinate and
; each `y` coordinate is a an element of `ys`.
;
; Examples (add more):
;  - (build-straight-line 2 (list 1 2 3)) =>
;      (list (make-posn 2 1) (make-posn 2 2) (make-posn 2 3))
(check-expect (build-straight-line 2 '())
              '())
(check-expect (build-straight-line 2 '(1 2 3))
              (list (make-posn 2 1) (make-posn 2 2) (make-posn 2 3)))
; strategy: function composition
(define (build-straight-line n ys)
  (map make-posn (make-list (length ys) n) ys))


;; Use `filter` to write this function:

; pts-north : Posn [List-of Posn] -> [List-of Posn]
; Returns the positions from `ps` that are north of `p`,
; that is, whose y coordinate is greater than `p`'s y coordinate.
; Examples:
(check-expect (pts-north (make-posn 2 3) '()) '())
(check-expect (pts-north (make-posn 2 3) (list (make-posn 1 2)
                                               (make-posn 3 1)
                                               (make-posn 4 0)))
              '())
(check-expect (pts-north (make-posn 2 3) (list (make-posn 1 2)
                                               (make-posn 3 4)
                                               (make-posn 4 4)))
              (list (make-posn 3 4)
                    (make-posn 4 4)))
; Strategy: function composition
(define (pts-north p ps)
  (filter (compare-to > p) ps))
; compare-to: [X X -> Boolean] X -> [X -> Boolean]
; Creates a predicate to compare to a given value.
; Examples:
(check-satisfied (make-posn 2 3) (compare-to > (make-posn 1 2)))
; Strategy: domain knowledge
(define (compare-to compare x)
  (local [(define (pred? y)
            (compare (posn-y y) (posn-y x)))]
    pred?))


;; Use `foldr` to write this function:

; total-width : [List-of Image] -> Number
; Returns the sum of the widths of all images in `loi`.
; Examples:
(check-expect (total-width '()) 0)
(check-expect (total-width (list (circle 5 "solid" "red")
                                 (rectangle 12 4 "solid" "blue")
                                 (ellipse 5 10 "outline" "black")))
              27)
; Strategy: 
(define (total-width loi)
  (foldr + 0 (map image-width loi)))


;; The remaining exercises in this file use functions to represent
;; curves in the plane. A curve can be represented as a function that
;; accepts an x coordinate and returns a y coordinate. For example, the
;; straight, diagonal line through the origin can be represented by
(define (diagonal x) x)
;; and a parabola sitting at the origin can be represented by
(define (parabola x) (* x x))

; SOME-POSNS : [List-of Posn]
; A list to use in examples and tests.
(define SOME-POSNS
  (list (make-posn 1 0) (make-posn 1 1) (make-posn 2 2)))


;; Use `map`, `filter`, and `foldr` to write the next four functions.


; only-on-curve : [Number -> Number] [List-of Posn] -> [List-of Posn]
; Return the positions in `ps` that are on the curve described by `f`.
;
; Examples (add more):
;  - (only-on-curve diagonal SOME-POSNS) =>
;      (list (make-posn 1 1) (make-posn 2 2))
;  - (only-on-curve parabola SOME-POSNS) =>
;      (list (make-posn 1 1))
(check-expect (only-on-curve diagonal '())
              '())
(check-expect (only-on-curve diagonal SOME-POSNS)
              (list (make-posn 1 1) (make-posn 2 2)))
(check-expect (only-on-curve parabola SOME-POSNS)
              (list (make-posn 1 1)))
; Strategy: function composition
(define (only-on-curve f ps)
  (filter (my-compare-to memq? (map f (map posn-x ps))) ps))

; my-compare-to: [X X -> Boolean] X -> [X -> Boolean]
; Creates a predicate to compare to a given value.
; Examples:
(check-satisfied (make-posn 2 3) (my-compare-to > 2))
; Strategy: domain knowledge
(define (my-compare-to compare x)
  (local [(define (pred? y)
            (compare (posn-y y) x))]
    pred?))

; graph-curve : [Number -> Number] [List-of Number] -> [List-of Posn]
; Returns the list of positions on the curve `f` whose x-coordinates
; are in `xs`.
;
; Examples (add more):
;  - (graph-curve parabola (list 1 2 3)) =>
;      (list (make-posn 1 1) (make-posn 2 4) (make-posn 3 9))
(check-expect (graph-curve parabola '()) '())
(check-expect (graph-curve parabola (list 1 2 3))
              (list (make-posn 1 1) (make-posn 2 4) (make-posn 3 9)))
(check-expect (graph-curve diagonal (list 1 2 3))
              (list (make-posn 1 1) (make-posn 2 2) (make-posn 3 3)))
; Strategy: function composition
(define (graph-curve f xs)
  (map make-posn xs (map f xs)))


; flatten-posns : [List-of Posn] -> [List-of Number]
; Constructs the list consisting of all the x and y coordinates of each
; of the positions in `ps`, in the order they appear in `ps` (first x,
; first y, second x, second y, and so on).
;
; Examples (add more):
;  - (flatten-posns SOME-POSNS) =>
;      (list 1 0 1 1 2 2)
(check-expect (flatten-posns '()) '())
(check-expect (flatten-posns SOME-POSNS)
              (list 1 0 1 1 2 2))
; Strategy: function composition
(define (flatten-posns ps)
  (foldr append '() (map flat-a-posn ps)))
; flat-a-posn: Posn -> [list-of Number]
; Constructs a list of x and y coordinates of a point 'p'
(check-expect (flat-a-posn (make-posn 0 0))
              (list 0 0))
(define (flat-a-posn p)
  (list (posn-x p) (posn-y p)))


; possible-ys : [List-of [Number -> Number]]
;               Number
;               -> [List-of Number]
;
; Given a list of curves `cs`, returns the list of y coordinates passed
; through by each curve at the given x coordinate.
;
; Examples (add more):
;  - (possible-ys (list diagonal parabola) 7) =>
;      (list 7 49)
(check-expect (possible-ys '() 7) '())
(check-expect (possible-ys (list diagonal parabola) 7) (list 7 49))
; Strategy: function composition
(define (possible-ys loc x)
  (map function (make-list (length loc) x) loc))
; function: Number [Number -> Number] -> Number
(define (function x curve)
  (curve x))

