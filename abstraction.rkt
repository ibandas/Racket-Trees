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
#;
(define (build-straight-line n ys) ...)


;; Use `filter` to write this function:

; pts-north : Posn [List-of Posn] -> [List-of Posn]
; Returns the positions from `ps` that are north of `p`,
; that is, whose y coordinate is greater than `p`'s y coordinate.
#;
(define (pts-north p ps) ...)


;; Use `foldr` to write this function:

; total-width : [List-of Image] -> Number
; Returns the sum of the widths of all images in `loi`.
#;
(define (total-width loi) ...)


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
#;
(define (only-on-curve f ps) ...)


; graph-curve : [Number -> Number] [List-of Number] -> [List-of Posn]
; Returns the list of positions on the curve `f` whose x-coordinates
; are in `xs`.
;
; Examples (add more):
;  - (graph-curve parabola (list 1 2 3)) =>
;      (list (make-posn 1 1) (make-posn 2 4) (make-posn 3 9))
#;
(define (graph-curve f xs) ...)


; flatten-posns : [List-of Posn] -> [List-of Number]
; Constructs the list consisting of all the x and y coordinates of each
; of the positions in `ps`, in the order they appear in `ps` (first x,
; first y, second x, second y, and so on).
;
; Examples (add more):
;  - (flatten-posns SOME-POSNS) =>
;      (list 1 0 1 1 2 2)
#;
(define (flatten-posns ps) ...)


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
#;
(define (possible-ys loc x) ...)

