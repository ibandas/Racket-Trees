;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname alpaca-genealogy) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;;;;;;;;;;;;;;;;;;;
;; Alpaca Pedgrees ;;
;;;;;;;;;;;;;;;;;;;;;

#|
The Alpaca Owners and Breeders Association needs your
help! They're having trouble using the database of
detailed pedigree records that they keep for all
registered alpacas.

But first, some background. For every alpaca in the
registry, they keep several different pieces of
information:

- name
- sex
- date of birth
- fleece color
- sire (father), if known
- dam (mother), if known

Unsurprisingly, AOBA uses DrRacket to store and query
the alpaca registry, with the following data
definitions:
|#

; A KnownAlpaca is (make-alpaca String Sex Date Color AlpacaTree AlpacaTree)

; An AlpacaTree is one of:
;  - (make-alpaca String Sex Date Color AlpacaTree AlpacaTree)
;  - "unknown"
(define-struct alpaca [name sex dob color sire dam])
; process-alpaca: AlpacaTree -> ...
; Template for processing Alpaca
#;
(define (process-alpaca alpacatree ...)
  (cond
    [(string? alpacatree) ...]
    [else (...(alpaca-name alpaca)...)
          (...(alpaca-sex alpaca)...)
          (...(alpaca-dob alpaca)...)
          (...(alpaca-color alpaca)...)
          (...(process-alpaca (alpaca-sire alpaca) ...) ...)
          (...(process-alpaca (alpaca-dam alpaca) ...) ...)]))
;
; where
;
; A Sex is one of:
;  - "female"
;  - "male"
;
; A Date is (make-date Year Month Day)
(define-struct date [year month day])
;   where
; Year is an Integer in [1900, 2019]
; Month is an Integer in [1, 12]
; Day is an Integer in [1, 31]


;; Here are some example alpacas:

(define DANA-ANDREWS
  (make-alpaca "Dana Andrews"
               "female"
               (make-date 1996 8 14)
               "silver"
               "unknown"
               "unknown"))
(define JERICHO
  (make-alpaca "Jericho de Chuchata"
               "male"
               (make-date 1997 11 23)
               "black"
               "unknown"
               "unknown"))
(define SYLVAN
  (make-alpaca "MA Sylvan"
               "male"
               (make-date 2001 5 16)
               "black"
               "unknown"
               "unknown"))
(define INDEPENDENCE
  (make-alpaca "MFA Independence"
               "female"
               (make-date 2002 7 2)
               "black"
               JERICHO
               DANA-ANDREWS))
(define IRENE
  (make-alpaca "Irene of Acorn Alpacas"
               "female"
               (make-date 2007 5 21)
               "silver"
               SYLVAN
               INDEPENDENCE))

(define ANNA
  (make-alpaca "Louisiana Baby 1"
               "male"
               (make-date 2012 8 25)
               "white"
               JERICHO
               "unknown"))

(define ANN
  (make-alpaca "Louisiana Baby 7"
               "male"
               (make-date 2019 5 8)
               "grey"
               JERICHO
               IRENE))
(define ANNABELL
  (make-alpaca "Louisiana Baby 11"
               "male"
               (make-date 2010 4 10)
               "silver"
               ANNA
               IRENE))
(define LOU
  (make-alpaca "Louisiana Baby 13"
               "female"
               (make-date 2013 7 19)
               "black"
               INDEPENDENCE
               SYLVAN))
(define LOUI
  (make-alpaca "Louisiana Baby 17"
               "female"
               (make-date 2001 4 21)
               "grey"
               SYLVAN
               INDEPENDENCE))
(define LOUIS
  (make-alpaca "Louisiana Baby 17"
               "female"
               (make-date 2020 7 7)
               "white"
               ANNA
               LOU))
(define LOUISA
  (make-alpaca "Louisiana Baby 20"
               "female"
               (make-date 2010 4 1)
               "grey"
               ANNABELL
               INDEPENDENCE))
(define LOUISAN
  (make-alpaca "Louisiana Baby 23"
               "female"
               (make-date 2019 9 8)
               "silver"
               "unknown"
               INDEPENDENCE))
#|
Add two more example alpacas.

(Come back here later and add more example values that
you think would make good test cases as you design the
rest of the functions for this homework assignment.)
|#


#|
AOBA would like a program to make a rather simple query:
Given an alpaca, they would like to find out the names
of all the female-line ancestors of the given alpaca, in
a list from youngest to oldest. Because we are computer
scientists, we consider every alpaca to be a member of
its own female line, *even male alpacas*. So for
example, given `IRENE` from above, it should return the
list
|#
(define FEMALE-LINE-OF-IRENE
  (list "Irene of Acorn Alpacas"
        "MFA Independence"
        "Dana Andrews"))
#|
which contains Irene's name, her mother's name, and her
grandmother's name, and then stops because her great
grandmother is unknown. Design the function female-line.
|#

; get-female-line: AlpacaTree -> List-of String
; Given an alpaca, return a list of the names of its female-line
; of ancestors from youngest to oldest
(check-expect (get-female-line "unknown") '())
(check-expect (get-female-line IRENE) FEMALE-LINE-OF-IRENE)
(check-expect (get-female-line ANNA) (list "Louisiana Baby 1"))
(check-expect (get-female-line ANN)
              (cons "Louisiana Baby 7" FEMALE-LINE-OF-IRENE))
; Strategy: Structural Decomposition
(define (get-female-line alpacatree)
  (cond
    [(string? alpacatree) '()]
    [else (cons (alpaca-name alpacatree)
                (get-female-line (alpaca-dam alpacatree)))]))

#|
Many breeders raise alpacas for their fleece, which
comes in a wide variety of colors and may be made into a
wide variety of textiles. Some breeders are interested
in breeding alpacas with new colors and patterns, and to
do so, they need to understand how fleece colors and
patterns are inherited.

You can help them by designing a function `has-color?`
that takes an alpaca pedigree tree and a color, and
reports whether or not that fleece color appears
anywhere in the tree.
|#

; has-color?: AlpacaTree String -> Boolean
; Takes an alpaca pedigree tree and a color, and
; reports whether or not that fleece color appears
; anywhere in the tree.
; Example:
(check-expect (has-color? IRENE "white") #false)
(check-expect (has-color? IRENE "silver") #true)
(check-expect (has-color? IRENE "black") #true)
; Strategy: structural decomposition
(define (has-color? alpacatree color)
  (cond
    [(string? alpacatree) #false]
    [else (or (string=? (alpaca-color alpacatree) color)
              (has-color? (alpaca-dam alpacatree) color)
              (has-color? (alpaca-sire alpacatree) color))]))

#|
AOBA is worried about fraud in their registry.
Eventually they'll send investigators into the field,
but first they'd like to run a simple sanity check on
the database. Given the pedigree record for an alpaca,
there are two simple errors that you can find:

Some alpaca in the tree has a birthday before one of his
or her parents.

Some alpaca in the tree has a male alpaca listed as dam
or a female alpaca listed as sire.

Design a function `pedigree-error?` that returns #true
if a given alpaca has one of those two obvious errors
anywhere in his or her pedigree, and #false otherwise.
|#
; pedigree-error?: AlpacaTree -> Boolean
; Returns #true if a given alpaca has one of those
; two obvious errors anywhere in his or her pedigree,
; and #false otherwise.
; Examples:
(check-expect (pedigree-error? ANNABELL) #true)
(check-expect (pedigree-error? IRENE) #false)
(check-expect (pedigree-error? LOU) #true)
(check-expect (pedigree-error? LOUI) #true)
(check-expect (pedigree-error? LOUIS) #true)
(check-expect (pedigree-error? ANNA) #false)
; Strategy: Structural Decomposition
(define (pedigree-error? alpacatree)
  (cond
    [(string? alpacatree) #false]
    [else (or (dob-error? alpacatree)
              (parents-sex-error? (alpaca-dam alpacatree) "male")
              (parents-sex-error? (alpaca-sire alpacatree) "female")
              (pedigree-error? (alpaca-dam alpacatree))
              (pedigree-error? (alpaca-sire alpacatree)))]))


; dob-error?: KnownAlpaca -> Boolean
; Determines whether there is an error with an alpaca's
; given date of birth compared to parent's date of birth
(check-expect (dob-error? ANNABELL) #true)
(check-expect (dob-error? IRENE) #false)
; Strategy: Structural Decomposition + Function Composition
(define (dob-error? alpacatree)
  (or (date-earlier? alpacatree (alpaca-dam alpacatree))
      (date-earlier? alpacatree (alpaca-sire alpacatree))))

; date-earlier?: AlpacaTree AlpacaTree -> Boolean
; Determines whether the first alpaca's dob
; is earlier than the second's
(check-expect (date-earlier? ANNA JERICHO) #false)
(check-expect (date-earlier? ANNABELL ANNA) #true)
(check-expect (date-earlier? LOUI SYLVAN) #true)
(check-expect (date-earlier? LOUISA ANNABELL) #true)
; Strategy: Function Composition
(define (date-earlier? alpaca1 alpaca2)
  (cond
    [(or (string? alpaca1)
         (string? alpaca2))
     #false]
    [else (date-helper (alpaca-dob alpaca1) (alpaca-dob alpaca2))]))


; date-helper : Date Date -> Boolean
; Determines whether the first date of birth is
; earlier than the second date of birth, or not
(check-expect (date-helper (make-date 1990 10 30) (make-date 2000 11 12))
              #true)
(check-expect (date-helper (make-date 2000 11 12) (make-date 1990 10 30))
              #false)
(check-expect (date-helper (make-date 2000 10 12) (make-date 2000 11 30))
              #true)
(check-expect (date-helper (make-date 2000 11 30) (make-date 2000 10 12))
              #false)
(check-expect (date-helper (make-date 2000 10 12) (make-date 2000 10 30))
              #true)
(check-expect (date-helper (make-date 2000 10 30) (make-date 2000 10 12))
              #false)
(check-expect (date-helper (make-date 2000 10 30) (make-date 2000 10 30))
              #false)
; Strategy: Function Composition
(define (date-helper dob1 dob2)
  (or (< (date-year dob1) (date-year dob2))
      (and (= (date-year dob1) (date-year dob2))
           (< (date-month dob1) (date-month dob2)))
      (and (= (date-year dob1) (date-year dob2))
           (= (date-month dob1) (date-month dob2))
           (< (date-day dob1) (date-day dob2)))))


; parents-sex-error?: AlpacaTree String -> Boolean
; Given an Alpaca and Sex, and checks to see if they match
(check-expect (parents-sex-error? "unknown" "male") #false)
(check-expect (parents-sex-error? IRENE "female") #true)
(check-expect (parents-sex-error? LOU "female") #true)
(check-expect (parents-sex-error? JERICHO "male") #true)
; Strategy: Function Composition
(define (parents-sex-error? alpacatree sex)
  (cond
    [(string? alpacatree)
     #false]
    [else (string=? (alpaca-sex alpacatree) sex)]))

#|
For all other problems in this assignment, you may
assume that all alpaca records are valid, in the sense
that `pedigree-error?` answers false for them. In the
next problem, for example, it will save you trouble if
you don't have to consider the possibility that any
alpaca's date of birth could precede its parents'.

Tracing back an alpaca's ancestry as far as possible is
a point of pride in the alpaca-raising community. Design
a function `oldest-ancestor` that, given an alpaca's
pedigree record, returns its oldest known ancestor's
name, or returns #false if there is no known ancestor.

Hint: You will need this data definition to write
`oldest-ancestor`'s signature:
|#

; A Maybe-Name is one of:
; - String
; - #false

; oldest-ancestor: KnownAlpaca -> Maybe-Name
; Given an alpaca's pedigree record,
; returns its oldest known ancestor's name,
; or returns #false if there is no known ancestor.
(check-expect (oldest-ancestor IRENE) "Dana Andrews")
(check-expect (oldest-ancestor JERICHO) #false)
; Strategy: structural decomposition
(define (oldest-ancestor alpaca)
  (cond
    [(and (string? (alpaca-dam alpaca)) (string? (alpaca-sire alpaca))) #false]
    [else (alpaca-name (first (reverse (all-ancestors/sorted alpaca))))]))

#|
AOBA also wants a way to list all the known ancestors of
a given alpaca (including the given alpaca) in reverse
birth order. For example, for Irene, the result would
be:
|#
(define SORTED-ANCESTORS-OF-IRENE
  (list IRENE
        INDEPENDENCE
        SYLVAN
        JERICHO
        DANA-ANDREWS))
#|
Design a function `all-ancestors/sorted` to perform this task.

Hint: In order to do so, you will need a data definition for
a list of alpacas (the conventional one will do), and you
will likely need a helper function `merge-alpacas` that, given
two sorted lists of alpaca trees, merges them into a single
sorted list of alpaca trees. See HTDP/2e section 23.5 for how
to design a template for this:

https://htdp.org/2019-02-24/part_four.html#%28part._sec~3atwo-inputs~3adesign%29
|#

; A List-of-Alpaca is one of:
; - '()
; - (cons AlpacaTree List-of-Alpaca)

; all-ancestors/sorted: AlpacaTree -> List-of-Alpaca
; Lists all the known ancestors of a given alpaca
; (including the given alpaca) in reverse birth order.
; Examples:
(check-expect (all-ancestors/sorted IRENE)
              SORTED-ANCESTORS-OF-IRENE)
; Strategy: Structural Decomposition + Function Composition
(define (all-ancestors/sorted alpacatree)
  (cond
    [(string? alpacatree) '()]
    [else
     (cons alpacatree
           (merge-alpacas (all-ancestors/sorted (alpaca-dam alpacatree))
                          (all-ancestors/sorted (alpaca-sire alpacatree))))]))

; merge-alpacas: List-of-AlpacaTree List-of-AlpacaTree -> List-of-AlpacaTree
; Given two sorted lists of AlpacaTrees,
; merges them into a single sorted list of AlpacaTrees.
(check-expect (merge-alpacas '() SORTED-ANCESTORS-OF-IRENE)
              SORTED-ANCESTORS-OF-IRENE)
(check-expect (merge-alpacas (list  IRENE INDEPENDENCE)
                             (list SYLVAN JERICHO DANA-ANDREWS))
              SORTED-ANCESTORS-OF-IRENE)
(check-expect (merge-alpacas (list SYLVAN JERICHO DANA-ANDREWS)
                             (list  IRENE INDEPENDENCE))
              SORTED-ANCESTORS-OF-IRENE)
; Strategy: Structural Decomposition + Function Composition
(define (merge-alpacas loa1 loa2)
  (cond
    [(and (empty? loa1) (empty? loa2)) '()]
    [(empty? loa1) loa2]
    [(empty? loa2) loa1]
    [else
     (if (date-earlier? (first loa1) (first loa2))
         (cons (first loa2) (merge-alpacas loa1 (rest loa2)))
         (cons (first loa1) (merge-alpacas loa2 (rest loa1))))]))