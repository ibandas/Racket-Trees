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
(define-struct alpaca [name sex dob color dam sire])
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
