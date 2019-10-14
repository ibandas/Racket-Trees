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
          (...(alpaca-sire alpaca)...)
          (...(alpaca-dam alpaca)...)]))
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
; Given an alpaca, they would like to find out the names
; of all the female-line ancestors of the given alpaca, in
; a list from youngest to oldest.
; Examples:
(check-expect (get-female-line "unknown") '())
(check-expect (get-female-line IRENE) FEMALE-LINE-OF-IRENE)
; Strategy: structural decomposition
(define (get-female-line alpacatree)
  (cond
    [(string? alpacatree) '()]
    [else (cons (alpaca-name alpacatree)
                (get-female-line (alpaca-dam alpacatree)))]))

(check-expect (get-female-line ANNA) (list "Louisiana Baby 1"))
(check-expect (get-female-line ANN)
              (cons "Louisiana Baby 7" FEMALE-LINE-OF-IRENE))

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
; Strategy: structural decomposition
(define (pedigree-error? alpacatree)
  (cond
    [(string? alpacatree) #false]
    [else (or (dob-error? alpacatree)
              (parents-error? alpacatree)
              (pedigree-error? (alpaca-dam alpacatree))
              (pedigree-error? (alpaca-sire alpacatree)))]))
;
(check-expect (pedigree-error? LOU) #true)
(check-expect (pedigree-error? LOUI) #true)
(check-expect (pedigree-error? LOUIS) #true)
(check-expect (pedigree-error? ANNA) #false)
;
; dob-error?: AlpacaTree -> Boolean
; Determines whether there is a problem with its date of birth
; Examples:
(check-expect (dob-error? "unknown") #false)
(check-expect (dob-error? ANNABELL) #true)
(check-expect (dob-error? IRENE) #false)
; Strategy: structural decomposition
(define (dob-error? alpacatree)
  (cond
    [(string? alpacatree) #false]
    [else (or (date-earlier? alpacatree (alpaca-dam alpacatree))
              (date-earlier? alpacatree (alpaca-sire alpacatree)))]))
;
; date-earlier?: AlpacaTree AlpacaTree -> Boolean
; Determines whether the first alpaca's dob
; is earlier than the second's
; Examples:
(check-expect (date-earlier? ANNA JERICHO) #false)
(check-expect (date-earlier? ANNABELL ANNA) #true)
; Strategy: structural decomposition
(define (date-earlier? alpaca1 alpaca2)
  (cond
    [(or (string? alpaca1)
         (string? alpaca2))
     #false]
    [else (or (< (date-year (alpaca-dob alpaca1))
                 (date-year (alpaca-dob alpaca2)))
              (and (= (date-year (alpaca-dob alpaca1))
                      (date-year (alpaca-dob alpaca2)))
                   (< (date-month (alpaca-dob alpaca1))
                      (date-month (alpaca-dob alpaca2))))
              (and (= (date-year (alpaca-dob alpaca1))
                      (date-year (alpaca-dob alpaca2)))
                   (= (date-month (alpaca-dob alpaca1))
                      (date-month (alpaca-dob alpaca2)))
                   (< (date-day (alpaca-dob alpaca1))
                      (date-day (alpaca-dob alpaca2)))))]))
;
(check-expect (date-earlier? LOUI SYLVAN) #true)
(check-expect (date-earlier? LOUISA ANNABELL) #true)
;
; parents-error?: AlpacaTree -> Boolean
; Determines whether there is an error with the order of its parents
; Examples:
(check-expect (parents-error? "unknown") #false)
(check-expect (parents-error? IRENE) #false)
(check-expect (parents-error? LOU) #true)
; Strategy: structural decompositon
(define (parents-error? alpacatree)
  (cond
    [(or (string? alpacatree)
         (string? (alpaca-dam alpacatree))
         (string? (alpaca-sire alpacatree)))
     #false]
    [else (or (string=? "female" (alpaca-sex (alpaca-sire alpacatree)))
              (string=? "male" (alpaca-sex (alpaca-dam alpacatree))))]))

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

; A Maybe-name is one of:
; - String
; - #false

; oldest-ancestor: AlpacaTree -> Maybe-name
; Given an alpaca's pedigree record,
; returns its oldest known ancestor's name,
; or returns #false if there is no known ancestor.
; Examples:
(check-expect (oldest-ancestor IRENE) "Dana Andrews")
(check-expect (oldest-ancestor JERICHO) #false)
(check-expect (oldest-ancestor "unknown") #false)
; Strategy: structural decompositon
(define (oldest-ancestor alpacatree)
  (cond
    [(string? alpacatree) #false]
    [else
     (if (string=? (alpaca-name alpacatree)
                   (alpaca-name (earliest-date alpacatree)))
         #false
         (alpaca-name (earliest-date alpacatree)))]))

; earliest-date: AlpacaTree -> AlpacaTree
; Resumes an alpacatree, returns the alpacatree with ealiest dob,
; including itself
; Examples:
(check-expect (earliest-date IRENE) DANA-ANDREWS)
(check-expect (earliest-date JERICHO) JERICHO)
(check-expect (earliest-date ANNA) JERICHO)
(check-expect (earliest-date LOUISAN) DANA-ANDREWS)
; Strategy: structural decompositon
(define (earliest-date alpacatree)
  (cond
    [(and (string? (alpaca-dam alpacatree))
          (string? (alpaca-sire alpacatree)))
     alpacatree]
    [(string? (alpaca-dam alpacatree))
     (earliest-date (alpaca-sire alpacatree))]
    [(string? (alpaca-sire alpacatree))
     (earliest-date (alpaca-dam alpacatree))]
    [else
     (compare-date (alpaca-dam alpacatree)
                   (alpaca-sire alpacatree)
                   (earliest-date (alpaca-dam alpacatree))
                   (earliest-date (alpaca-sire alpacatree)))]))

; compare-date: AlpacaTree AlpacaTree AlpacaTree AlpacaTree -> Alpacatree
; Takes four alpaca (two alpacas and their oldest ancestors),
; returns the oldest one among them
; Examples:
(check-expect (compare-date IRENE ANNA "unknown" "unknown") IRENE)
(check-expect (compare-date IRENE ANNA "unknown" JERICHO) JERICHO)
(check-expect (compare-date IRENE ANNA DANA-ANDREWS "unknown") DANA-ANDREWS)
(check-expect (compare-date IRENE ANNA DANA-ANDREWS JERICHO) DANA-ANDREWS)
; Strategy: structural decompositon
(define (compare-date alpacatree1 alpacatree2 alpacatree3 alpacatree4)
  (cond
    [(and (string? alpacatree3)
          (string? alpacatree4))
     (if (date-earlier? alpacatree1 alpacatree2)
         alpacatree1
         alpacatree2)]
    [(string? alpacatree3)
     (if (date-earlier? alpacatree1 alpacatree4)
         alpacatree1
         alpacatree4)]
    [(string? alpacatree4)
     (if (date-earlier? alpacatree3 alpacatree2)
         alpacatree3
         alpacatree2)]
    [else
     (if (date-earlier? alpacatree3 alpacatree4)
         alpacatree3
         alpacatree4)]))
;
(check-expect (compare-date ANNA IRENE "unknown" "unknown") IRENE)
(check-expect (compare-date JERICHO ANNA "unknown" IRENE) JERICHO)
(check-expect (compare-date IRENE DANA-ANDREWS ANNA "unknown") DANA-ANDREWS)
(check-expect (compare-date ANNA IRENE JERICHO DANA-ANDREWS) DANA-ANDREWS)

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
; Strategy: structural decomposition
(define (all-ancestors/sorted alpacatree)
  (cond
    [(string? alpacatree) '()]
    [else
     (cons alpacatree
           (merge-alpacas (all-ancestors/sorted (alpaca-dam alpacatree))
                          (all-ancestors/sorted (alpaca-sire alpacatree))))]))

; merge-alpacas: List-of-Alpaca List-of-Alpaca -> List-of-Alpaca
; Given two sorted lists of alpaca trees,
; merges them into a single sorted list of alpaca trees.
; Examples:
(check-expect (merge-alpacas (list  IRENE
                                    INDEPENDENCE)
                             (list SYLVAN
                                   JERICHO
                                   DANA-ANDREWS))
              SORTED-ANCESTORS-OF-IRENE)
; Strategy: structural decomposition
(define (merge-alpacas loa1 loa2)
  (cond
    [(and (empty? loa1) (empty? loa2)) '()]
    [(empty? loa1) loa2]
    [(empty? loa2) loa1]
    [else
     (if (date-earlier? (first loa1) (first loa2))
         (cons (first loa2) (merge-alpacas loa1 (rest loa2)))
         (cons (first loa1) (merge-alpacas loa2 (rest loa1))))]))
;
(check-expect (merge-alpacas (list SYLVAN
                                   JERICHO
                                   DANA-ANDREWS)
                             (list  IRENE
                                    INDEPENDENCE))
              SORTED-ANCESTORS-OF-IRENE)
(check-expect (merge-alpacas '() SORTED-ANCESTORS-OF-IRENE)
              SORTED-ANCESTORS-OF-IRENE)