;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname aa) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; process-aatree : [AA-tree X] -> ...
; Template for processing [AA-tree X]:
#;
(define (process-aatree aa...)
  (...(tree-root aa)...)
  (...(tree-size aa)...)
  (...(tree-less-than aa)...))

; process-aanode : [AA-node X] -> ...
; Template for processing [AA-node X]:
#;
(define (process-aanode n)
  (cond
    [(string? n) ...]
    [else (...(node-value n)...)
          (...(node-level n)...)
          (...(node-left n)...)
          (...(node-right n)...)]))


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


(define INSERTED-NOTHING (make-tree "leaf" 0 <))
(define INSERTED-6 (make-tree (make-node 6 1 "leaf" "leaf") 1 <))
(define INSERTED-6-2
  (make-tree (make-node 2 1 "leaf" (make-node 6 1 "leaf" "leaf")) 2 <))
(define INSERTED-6-2-8 (make-tree (make-node 6 2 (make-node 2 1 "leaf" "leaf")
                                             (make-node 8 1 "leaf" "leaf"))
                                  3 <))
(define INSERTED-6-2-8-16
  (make-tree (make-node 6 2 (make-node 2 1 "leaf" "leaf")
                        (make-node 8 1 "leaf" (make-node 16 1 "leaf" "leaf")))
             4 <))
(define INSERTED-6-2-8-16-10
  (make-tree (make-node 6 2
                        (make-node 2 1 "leaf" "leaf")
                        (make-node 10 2
                                   (make-node 8 1 "leaf" "leaf")
                                   (make-node 16 1 "leaf" "leaf")))
             5 <))
(define INSERTED-6-2-8-16-10-1
  (make-tree (make-node 6 2
                        (make-node 1 1 "leaf" (make-node 2 1  "leaf" "leaf"))
                        (make-node 10 2
                                   (make-node 8 1 "leaf" "leaf")
                                   (make-node 16 1 "leaf" "leaf"))) 6 <))

;; Examples (FILL THESE IN):

;; Define the example [AA-tree Number] that has only the
;; number 0 in it, using < as the less-than operation.
(define zero (make-node 0 0 "leaf" "leaf"))
(define AA-ZERO (make-tree zero 1 <))

;; There is only one [AA-tree Number] that has the
;; numbers 1, 2, and 3 in it, using < as the less-than
;; operation. Define it.
(define AA-123 (make-tree (make-node 2 1
                                     (make-node 1 0 "leaf" "leaf")
                                     (make-node 3 0 "leaf" "leaf")) 3 <))
                          

;; Similarly, there is only one that has the strings
;; "one", "two", and "three" in it, using `string<?` as
;; the comparison operation. Define it.
(define AA-STRING-123 (make-tree (make-node "two" 1
                                            (make-node "one" 0 "leaf" "leaf")
                                            (make-node "three" 0 "leaf" "leaf"))
                                 3 string<?)) 

;; There are two [AA-tree Number]s that have the numbers
;; 1, 2, 3, and 4 in them (when using <). Define them
;; both. The constraint that all “leaves” have level 0
;; means that many of the trees that you might at first
;; think are AA trees really are not.
(define AA-1/1 (make-node 1 0 "leaf" "leaf"))
(define AA-4/1 (make-node 4 0 "leaf" "leaf"))
(define AA-3/1 (make-node 3 1 "leaf" AA-4/1))
(define AA-2/1 (make-node 2 1 AA-1/1 AA-3/1))
;; This is an AA-tree
(define AA-1234/1 (make-tree AA-2/1 4 <))


(define AA-1/2 (make-node 1 0 "leaf" "leaf"))
(define AA-4/2 (make-node 4 1 "leaf" "leaf"))
(define AA-2/2 (make-node 2 1 AA-1/2 "leaf"))
(define AA-3/2 (make-node 3 2 AA-2/2 AA-4/2))
;; This is not an AA-tree (node-val 4 is a leaf but has level 1)
(define AA-1234/2 (make-tree AA-3/2 4 <))

; lookup: [AA-Tree X] X -> Boolean
; Determine whether `x` occurs in `tree`
; Strategy: Structural Decomposition
(check-expect (lookup AA-1234/2 3) #true)
(check-expect (lookup AA-1234/2 1) #true)
(check-expect (lookup AA-1234/2 10) #false)
(check-expect (lookup AA-1234/2 100) #false)
(check-expect (lookup AA-STRING-123 "two") #true)
(check-expect (lookup AA-STRING-123 "ninety") #false)
(check-expect (lookup AA-STRING-123 "one") #true)
(define (lookup tree x)
  (lookupnode (tree-root tree) x (tree-less-than tree)))


; lookupnode: [AA-Node X] X [Bin-pred X] -> Boolean
; Helper function to traverse the BST for the node
; Strategy: Function Composition
(check-expect (lookupnode "leaf" 5 <) #false)
(check-expect (lookupnode AA-3/2 3 <) #true)
(check-expect (lookupnode AA-3/2 100 <) #false)
(check-expect (lookupnode AA-3/2 1 <) #true)
(check-expect (lookupnode AA-3/2 4 <) #true)
(define (lookupnode n x less-than)
  (cond
    [(string? n) #false]
    [else (cond
            [(less-than (node-value n) x)
             (lookupnode (node-right n) x less-than)]
            [(less-than x (node-value n))
             (lookupnode (node-left n) x less-than)]
            [else #true])]))


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
(check-expect (insert-wrong (make-node 6 2 (make-node 2 1 "leaf" "leaf")
                                       (make-node 8 1 "leaf" "leaf")) 16 <)
              (make-node 6 2 (make-node 2 1 "leaf" "leaf")
                         (make-node 8 1 "leaf"
                                    (make-node 16 1 "leaf" "leaf"))))
(check-expect (insert-wrong (make-node 6 2 (make-node 2 1 "leaf" "leaf")
                                       (make-node 8 1 "leaf" "leaf")) 1 <)
              (make-node 6 2
                         (make-node 2 1 (make-node 1 1 "leaf" "leaf") "leaf")
                         (make-node 8 1 "leaf" "leaf")))
(check-expect (insert-wrong (make-node 6 2 (make-node 2 1 "leaf" "leaf")
                                       (make-node 8 1 "leaf" "leaf")) 8 <)
              (make-node 6 2 (make-node 2 1 "leaf" "leaf")
                         (make-node 8 1 "leaf" "leaf")))
; Strategy: structural decomposition
(define (insert-wrong node value less-than)
  (cond
    [(string? node)
     (make-node value 1 "leaf" "leaf")]
    [else
     (if (lookupnode node value less-than)
         node
         (if (less-than value (node-value node))
             (make-node (node-value node)
                        (node-level node)
                        (insert-wrong (node-left node) value less-than)
                        (node-right node))
             (make-node (node-value node)
                        (node-level node)
                        (node-left node)
                        (insert-wrong (node-right node) value less-than))))]))
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


        A
       / \
      t1  B
         / \
        t2  C
           / \
          t3 t4

Design the `rotate-right` and `rotate-left` functions.
|#

; Definitions for test cases concerned with
; (rotate-right) and (skew)
(define one (make-node 1 1 "leaf" "leaf"))
(define two (make-node 2 3 one "leaf"))
(define three (make-node 3 3 two "leaf"))

; rotate-right : [AA-node X] -> [AA-node X]
; ASSUMPTION: `n` is not "leaf" and `(node-left n)` is not "leaf"
; Rotates the tree towards the right while keeping
; BST and AA integrity
(check-expect (rotate-right three) (make-node 2 3
                                              (make-node 1 1 "leaf" "leaf")
                                              (make-node 3 3 "leaf" "leaf")))
(check-expect (rotate-right "leaf") "leaf")
(check-expect (rotate-right one) one)
; Strategy: Structural Decompisition + Function Composition
(define (rotate-right n)
  (if (string? n)
      "leaf"
      (if (string? (node-left n))
          n
          (make-node (node-value (node-left n))
                     (node-level n)
                     (node-left (node-left n))
                     (make-node (node-value n)
                                (node-level n)
                                (node-right (node-left n))
                                (node-right n))))))


; Definitions for test cases concerned with
; (rotate-left) and (split)
(define eight (make-node 8 3 "leaf" "leaf"))
(define seven (make-node 7 3 "leaf" eight))
(define six (make-node 6 3 "leaf" seven))
(define five (make-node 5 4 "leaf" six))
(define four (make-node 4 5 "leaf" five))

; rotate-left: [AA-Node X] -> [AA-Node X]
; ASSUMPTION: `n` is not "leaf" and `(node-right n)` is not "leaf"
; Rotates the tree towards the left while keeping
; BST and AA integrity
(check-expect (rotate-left "leaf") "leaf")
(check-expect (rotate-left eight) eight)
(check-expect (rotate-left six) (make-node 7 4 (make-node 6 3 "leaf" "leaf")
                                           (make-node 8 3 "leaf" "leaf")))
; Strategy: Structural Decomposition
(define (rotate-left n)
  (if (string? n)
      "leaf"
      (if (string? (node-right n))
          n
          (make-node (node-value (node-right n))
                     (+ 1 (node-level n))
                     (make-node (node-value n)
                                (node-level n)
                                (node-left n)
                                (node-left (node-right n)))
                     (node-right (node-right n))))))
                            
#|
After finishing the rotation functions we're ready to
design `split` and `skew`.

Skewing detects and repairs violations of AA Rule 1,
which says that every node’s left child must have a
level that is one less than its own. In particular, if
the given node is not a leaf and has the same level as
its left child then `skew` performs a right rotation on
it (possibly creating a Rule 2 violation).

|#

; skew: [AA-Node X] -> [AA-Node X]
; Performs a skew on the subtree
(check-expect (skew one) one)
(check-expect (skew three) (make-node 2 3
                                      (make-node 1 1 "leaf" "leaf")
                                      (make-node 3 3 "leaf" "leaf")))
(check-expect (skew (make-node 4 4 three "leaf"))
              (make-node 2 3
                         (make-node 1 1 "leaf" "leaf")
                         (make-node 3 3 "leaf" "leaf")))
; Strategy: Structural Decomposition + Function Composition
(define (skew n)
  (cond
    [(string? (node-left n)) n] 
    [(< (node-level (node-left n)) (node-level n)) (skew (node-left n))]
    [else (rotate-right n)]))

#|

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

; split: [AA-Node X] -> [AA-Node X]
; Performs a split on the subtree
(check-expect (split eight) eight)
(check-expect (split six) (make-node 7 4 (make-node 6 3 "leaf" "leaf")
                                     (make-node 8 3 "leaf" "leaf")))
(check-expect (split four) (make-node 7 4 (make-node 6 3 "leaf" "leaf")
                                      (make-node 8 3 "leaf" "leaf")))
; Strategy: Structural Decomposition + Function Composition
(define (split n)
  (cond
    [(or (string? (node-right n)) (string? (node-right (node-right n)))) n]
    [(or (< (node-level (node-right n)) (node-level n))
         (< (node-level (node-right (node-right n))) (node-level n)))
     (split (node-right n))]
    [else (rotate-left n)]))


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

; NOTE: Moved INSERTED defintions higher to be used
; for other test cases too

; create-tree: [AA-Tree X] X -> [AA-Tree X]
; Creates a tree out of the node returned from the insert of the value,
; adds 1 to the size of the tree due to the insert,
; and uses the same comparison
(check-expect (tree-size (create-tree INSERTED-NOTHING 6))
              (tree-size INSERTED-6))
(check-expect (tree-root (create-tree INSERTED-NOTHING 6))
              (tree-root INSERTED-6))
(check-expect (tree-size (create-tree INSERTED-6 2))
              (tree-size INSERTED-6-2))
(check-expect (tree-root (create-tree INSERTED-6 2))
              (tree-root INSERTED-6-2))
(check-expect (tree-root (create-tree INSERTED-6-2 8))
              (tree-root INSERTED-6-2-8))
(check-expect (tree-size (create-tree INSERTED-6-2 8))
              (tree-size INSERTED-6-2-8))
(check-expect (tree-size (create-tree INSERTED-6-2-8 16))
              (tree-size INSERTED-6-2-8-16))
(check-expect (tree-size (create-tree INSERTED-6-2-8-16 10))
              (tree-size INSERTED-6-2-8-16-10))
(check-expect (tree-size (create-tree INSERTED-6-2-8-16-10 1))
              (tree-size INSERTED-6-2-8-16-10-1))
; Strategy: Structural Decomposition
(define (create-tree tree value)
  (make-tree (insert tree value) (add1 (tree-size tree)) (tree-less-than tree)))

; insert : [AA-Tree X] X -> [AA-Node X]
; Inserts `x` into `tree`.
(check-expect (insert INSERTED-NOTHING 6) (tree-root INSERTED-6))
(check-expect (insert INSERTED-6 2) (tree-root INSERTED-6-2))
(check-expect (insert INSERTED-6-2 8) (tree-root INSERTED-6-2-8))
(check-expect (insert INSERTED-6-2-8 16) (make-node 2 1 "leaf" "leaf"))
(check-expect (insert INSERTED-6-2-8-16 10) (make-node 2 1 "leaf" "leaf"))
(check-expect (insert INSERTED-6-2-8-16-10 1) (make-node 1 1 "leaf"
                                                         (make-node 2 1 "leaf"
                                                                    "leaf")))
; Strategy: Function Composition
(define (insert tree n)
  (split (skew (insert-wrong (tree-root tree) n (tree-less-than tree)))))