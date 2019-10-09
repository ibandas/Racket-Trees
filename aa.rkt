;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname aa) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;;;;;;;;;;;;;;;;;;;;;;;
;; Persistent AA trees ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

#|
An AA tree is a form of binary search tree that
maintains the overall shape of the tree (and thus good
algorithmic properties) during insert operations.

Here's the data definition:
|#

; An [AA-tree X] is (make-tree [AA-node X] Nat [Bin-pred X])
(define-struct tree [root size less-than])
;
; where
;
; A [Bin-pred X] is [X X -> Boolean]
; interp. a total order (less-than predicate) on X.
;
; An [AA-node X] is one of:
;   - "leaf"
;   - (make-node X Nat [AA-node X] [AA-node X])
(define-struct node [value level left right])
; INVARIANTS:
;  - `less-than` is a strict, total order (elaborated
; below),
;  - the values are ordered according to the binary
; search tree property (for each node's value, all
; left-descendants are strictly less and all
; right-descendants are strictly greater, and
;  - the AA level invariant (described further below).


#|
The less-than operation for comparing values must be a
strict comparison. That is, it must be the case that,
for any two values `x1` and `x2` that are both `X`s,
exactly most one of these two expressions can be #true:

  (less-than x1 x2)
  (less-than x2 x1)

This ensures that one can compare any two elements in
the tree with a `cond` expression like this one:
|#

#;
(cond
 [(less-than x1 x2) ...]  ;; x1 < x2
 [(less-than x2 x1) ...]  ;; x1 > x2
 [else              ...]) ;; x1 == x2

#|
As compared to an ordinary binary search tree, each AA
tree node carries an additional natural number, its
level. There are several rules that govern the
relationship between the values of the level field of a
parent and its children. We collectively call these
rules the AA level invariant. They are:

Rule 0) The level of a leaf node counts as 0.

Rule 1) The level of a left child is one less than the
level of the parent.

Rule 2) The level of a right child is either the same as
its parent or one less. If it is the same, then the
right child of the right child must be one less (so no
two consecutive right children can have the same level).
|#


;; Examples (FILL THESE IN):

;; Define the example [AA-tree Number] that has only the
;; number 0 in it, using < as the less-than operation.
(define AA-ZERO "...")

;; There is only one [AA-tree Number] that has the
;; numbers 1, 2, and 3 in it, using < as the less-than
;; operation. Define it.
(define AA-123 "...")

;; Similarly, there is only one that has the strings
;; "one", "two", and "three" in it, using `string<?` as
;; the comparison operation. Define it.
(define AA-STRING-123 "...")

;; There are two [AA-tree Number]s that have the numbers
;; 1, 2, 3, and 4 in them (when using <). Define them
;; both. The constraint that all “leaves” have level 0
;; means that many of the trees that you might at first
;; think are AA trees really are not.
(define AA-1234/1 "...")
(define AA-1234/2 "...")

;; Define an [AA-tree Number] that has at least 6 numbers in it.
;; Use < as the comparison function.
(define AA-OF-SIX "...")


#|
The first function we are going to design is a lookup
function. It should look in the tree only in places that
might have the number. In other words, be sure that the
function you write takes advantage of the binary search
tree invariant.
|#


; lookup : [AA-tree X] X -> Boolean
; Determine whether `x` occurs in `tree`
(define (lookup tree x)
  "...")


#|
Our next goal is to design an insertion function.

Start by designing a function that inserts a number into
a given tree without regard for the AA level invariant,
paying attention only to the binary search tree
invariant. It should insert the new value in place of
some notional “leaf” and leave all of the other node’s
levels alone. The new node should have level 1.
|#

; insert-wrong : [AA-node X] X [X X -> Boolean] -> [AA-node X]
; Inserts `value` into `node` using `less-than` without
; regard to the AA level invariant.
(define (insert-wrong node value less-than)
  "...")


#|
Next, find two example AA-nodes and numbers such that,
when passed to `insert-wrong`, each returns a tree that
is not an AA-tree. One of the examples should violate
the constraint that the left child is one level lower
than its parent and the other should violate the
contraint that the right-right grandchild is (at least)
one level below the parent.

Add these two examples as test cases.
|#


#|

The invariant-preserving version of AA tree insert looks
very much like incorrect one, except that, each time it
recursively processes a node, it performs two additional
operations, a “skew” and a “split,” on the result before
returning it.

In order to define those operations we first need to
define two helper functions, `rotate-left` and
`rotate-right`.

The `rotate-left` function adjusts the nodes in a binary
tree in a way that preserves the ordering but changes
the levels. Specifically, if you have a tree with three
nodes (A, B, C) at the top and four subtrees (t1, t2,
t3, t4) below them in this shape:

       B
      / \
     /   \
    A     C
   / \   / \
  t1 t2 t3 t4

then applying a left rotation produces the this tree:

        C
       / \
      B   t4
     / \
    A   t3
   / \
  t1 t2

If the input tree satisfies the binary search tree
invariant, then so does this output tree. As you can
see, in the original tree, we had A < B < C and that
also holds in the new tree. Verify for yourself that the
elements of the subtrees (t1, t2, t3, t4) are okay. For
example, you know that the elements of t2 must all be
bigger than A and less than B from their position in the
first tree. Is that the case in the second? Does that
work for the other subtrees?

The `rotate-right` function does the same thing, but in
the other direction. Show what a right rotation looks
like on this (same) tree:


       B
      / \
     /   \
    A     C
   / \   / \
  t1 t2 t3 t4

Design the `rotate-right` and `rotate-left` functions.
|#

; rotate-right : [AA-node X] -> [AA-node X]
; ASSUMPTION: `n` is not "leaf" and `(node-left n)` is not "leaf"
#;
(define (rotate-right n) "...")

; rotate-left : [AA-node X] -> [AA-node X]
; ASSUMPTION: `n` is not "leaf" and `(node-right n)` is not "leaf"
#;
(define (rotate-left n) "...")


#|
After finishing the rotation functions we're ready to
design `split` and `skew`.

Skewing detects and repairs violations of AA Rule 1,
which says that every node’s left child must have a
level that is one less than its own. In particular, if
the given node is not a leaf and has the same level as
its left child then `skew` performs a right rotation on
it (possibly creating a Rule 2 violation).

Splitting detects and repairs violations of AA Rule 2,
which says that a right child at the same level must in
turn have a right child at a level one less. If the
given node is not a leaf and has the same level as its
right child and right–right grandchild, then `split`
performs a left rotation and increments the level of the
resulting node (the original right child).

Be careful not to violate AA Rule 0, which says that the
invisible leaves have level 0.
|#


#|
Finally, we're ready to design `insert`. For the first
step, look at the PDF slides here:

  http://faculty.ycp.edu/~dbabcock/PastCourses/cs350/lectures/AATrees.pdf

They show a series of trees that you get (and the skews
and splits) by inserting the numbers (in order): 6, 2,
8, 16, 10, and 1. Write each of those down as test cases
(i.e., write them down as [AA-node X]s) and then finish
the design of `insert`.

Note that when you write test cases, you are not allowed
to compare functions (or structures that have functions
inside them) with check-expect. So for example, this
will raise an error:

  (check-expect (make-tree "leaf" 0 <) (make-tree "leaf" 0 <))

To avoid this problem, write test cases that check only
the root and size fields of your trees (by calling
selectors on the result of insert).
|#

(define INSERTED-NOTHING
  "...")
(define INSERTED-6
  "...")
(define INSERTED-6-2
  "...")
(define INSERTED-6-2-8
  "...")
(define INSERTED-6-2-8-16
  "...")
(define INSERTED-6-2-8-16-10
  "...")
(define INSERTED-6-2-8-16-10-1
  "...")

; insert : [AA-tree X] X -> [AA-tree X]
; Inserts `x` into `tree`.
