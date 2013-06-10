; Record Like Stobjs
; Copyright (C) 2011-2012 Centaur Technology
;
; Contact:
;   Centaur Technology Formal Verification Group
;   7600-C N. Capital of Texas Highway, Suite 300, Austin, TX 78731, USA.
;   http://www.centtech.com/
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.  This program is distributed in the hope that it will be useful but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
; more details.  You should have received a copy of the GNU General Public
; License along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA 02110-1335, USA.
;
; Original author: Jared Davis <jared@centtech.com>

(in-package "ACL2")
(include-book "cutil/defsection" :dir :system)
(include-book "misc/records" :dir :system)
(local (include-book "misc/equal-by-g" :dir :system))
(local (include-book "centaur/misc/equal-by-nths" :dir :system))
(local (include-book "local"))

; typed-array-rec.lisp
;
; IRRELEVANT.  This was a failed attempt to adapt Greve/Wilding's approach to
; typed records to arrays.  I eventually ran into problems because there doesn't
; seem to be a good analogue of EQUAL-BY-G for their typed records.  This file
; doesn't certify


; I start with a generic typed record (tr).  I've adapted this implementation
; from the COI records/defrecord book.  Greve and Wilding don't try to explain
; how this works, saying in their Workshop paper only that "The implementations
; of the functions generated by [defrecord] are obscure, but the approach
; employed to enable hypothesis-free type rules are similar to those used to
; guarantee hypothesis-free access and update rules."  It seems to make sense
; if you go through the cases, although they are certainly wizards for having
; come up with it.

(encapsulate
  (((tr-val-p *) => *)
   ((tr-val-default) => *))

  (local (defun tr-val-p (x)
           ;; Recognizer for a good typed-record value.
           (natp x)))

  (local (defun tr-val-default ()
           ;; Some good value that bad values will be fixed to.
           0))

  (defthm booleanp-of-tr-val-p
    (booleanp (tr-val-p x))
    :rule-classes :type-prescription)

  (defthm tr-val-p-of-tr-val-default
    (tr-val-p (tr-val-default))))

(defun tr-val-list-p (x)
  (declare (xargs :guard t))
  (if (atom x)
      (equal x nil)
    (and (tr-val-p (car x))
         (tr-val-list-p (cdr x)))))

(defthm true-listp-when-tr-val-list-p
  (implies (tr-val-list-p x)
           (true-listp x))
  :rule-classes :compound-recognizer)

(defun tr-val-fix (x)
  ;; Special fixing function for typed-record values.
  (declare (xargs :guard t))
  (if (tr-val-p x)
      x
    (tr-val-default)))

(defun tr-val-zp (x)
  ;; Recognizer for bad values and the default value.
  (declare (xargs :guard t))
  (equal (tr-val-fix x)
         (tr-val-default)))

(defun tr-entry-okp (x)
  (declare (xargs :guard t))
  (and (consp x)
       (tr-val-p (car x))
       (not (tr-val-zp (car x)))
       (not (tr-entry-okp (cdr x)))))

(defun tr-read (key rec)
  (declare (xargs :guard t))
  (let ((x (g key rec)))
    (if (tr-entry-okp x)
        (car x)
      (tr-val-default))))

(defun tr-write (key val rec)
  (declare (xargs :guard t))
  (let ((x (g key rec)))
    (if (tr-entry-okp x)
        (if (tr-val-zp val)
            (s key (cdr x) rec)
          (s key (cons val (cdr x)) rec))
      (if (tr-val-zp val)
          rec
        (s key (cons val x) rec)))))

(defthm tr-val-p-of-tr-read
  (tr-val-p (tr-read a r)))

(defthm tr-read-of-tr-write-same
  (equal (tr-read a (tr-write a v r))
         (tr-val-fix v)))

(defthm tr-read-of-tr-write-diff
  (implies (not (equal a b))
           (equal (tr-read a (tr-write b v r))
                  (tr-read a r))))

(defthm tr-write-of-tr-read-same
  (equal (tr-write a (tr-read a r) r)
         r))

(defthm tr-write-of-tr-write-same
  (equal (tr-write a y (tr-write a x r))
         (tr-write a y r)))

(defthm tr-write-of-tr-write-diff
  (implies (not (equal a b))
           (equal (tr-write b y (tr-write a x r))
                  (tr-write a x (tr-write b y r))))
  :rule-classes ((:rewrite :loop-stopper ((b a tr-write)))))

(in-theory (disable tr-read tr-write))


(i-am-here)

(defun my-zero () (declare (xargs :guard t)) 0)

(defattach (tr-val-p natp)
  (tr-val-default my-zero))

(tr-write :a 'a nil)
(tr-write :b 'a nil)

(tr-write :a 1 'foo)
(tr-write nil 3 (tr-write :a 1 'foo))
(tr-write nil 'a (tr-write :a 1 'foo))

(tr-read nil (tr-write :a 1 'foo))





(defund array-to-trec (n arr rec)
  ;; Store arr[0]...arr[n] into rec[0]...rec[n]
  (declare (xargs :guard (and (natp n)
                              (true-listp arr))))
  (if (zp n)
      (tr-write 0 (nth 0 arr) rec)
    (array-to-trec (- n 1) arr
                   (tr-write n (nth n arr) rec))))

(defund trec-to-array (n rec arr)
  ;; Load arr[0]...arr[n] from rec[0]...rec[n]
  (declare (xargs :guard (and (natp n)
                              (true-listp arr))))
  (if (zp n)
      (update-nth 0 (tr-read 0 rec) arr)
    (trec-to-array (- n 1) rec
                   (update-nth n (tr-read n rec) arr))))

(defund delete-trec-indices (n rec)
  ;; Delete rec[0]...rec[n] from rec
  (declare (xargs :guard (natp n)))
  (if (zp n)
      (tr-write 0 (tr-val-default) rec)
    (delete-trec-indices (- n 1)
                         (tr-write n (tr-val-default) rec))))

(defund array-trec-pair-p (arr rec len)
  ;; Recognize array/record pairs where the array has size LEN and the record
  ;; has nothing in keys 0...LEN-1.
  (declare (xargs :guard (posp len)))
  (and (true-listp arr)
       (= (len arr) len)
       (equal rec (delete-trec-indices (- len 1) rec))))



(local (in-theory (enable array-to-trec
                          trec-to-array
                          delete-trec-indices
                          array-trec-pair-p)))

(defthm tr-read-of-array-to-trec
  (equal (tr-read key (array-to-trec n arr rec))
         (if (and (natp key)
                  (<= key (nfix n)))
             (tr-val-fix (nth key arr))
           (tr-read key rec))))



(defthm len-of-trec-to-array
  (equal (len (trec-to-array n rec arr))
         (max (+ 1 (nfix n)) (len arr))))

(defthm true-listp-of-trec-to-array
  (implies (true-listp arr)
           (true-listp (trec-to-array n rec arr))))

(defthm nth-of-trec-to-array
  (equal (nth key (trec-to-array n rec arr))
         (cond ((zp key)
                (tr-read 0 rec))
               ((<= key (nfix n))
                (tr-read key rec))
               (t
                (nth key arr)))))

(defthm nth-of-trec-to-array-of-array-to-trec
  (implies (and (natp key)
                (<= key n)
                (equal (len arr1) (len arr2))
                (natp n)
                (<= n (len arr1)))
           (equal (nth key (trec-to-array n (array-to-trec n arr1 rec) arr2))
                  (tr-val-fix (nth key arr1)))))

(defthm trec-to-array-of-array-to-trec
  ;; broken
  (implies (and (force (equal (len arr1) (len arr2)))
                (force (equal n (- (len arr1) 1)))
                (force (posp (len arr1)))
                (force (true-listp arr1))
                (force (true-listp arr2)))
           (equal (trec-to-array n (array-to-trec n arr1 rec) arr2)
                  arr1))
  :hints(("Goal"
          :use ((:functional-instance
                 equal-by-nths
                 (equal-by-nths-hyp (lambda ()
                                      (and (equal (len arr1) (len arr2))
                                           (equal n (- (len arr1) 1))
                                           (true-listp arr1)
                                           (true-listp arr2))))
                 (equal-by-nths-lhs (lambda ()
                                      (trec-to-array n (array-to-trec n arr1 rec) arr2)))
                 (equal-by-nths-rhs (lambda ()
                                      arr1)))))))

(defthm trec-to-array-idempotent
  (implies (and (force (posp (len arr1)))
                (force (true-listp arr1)))
           (equal (trec-to-array n val1 (trec-to-array n val2 arr1))
                  (trec-to-array n val1 arr1)))
  :hints(("Goal"
          :use ((:functional-instance
                 equal-by-nths
                 (equal-by-nths-hyp (lambda ()
                                      (and (posp (len arr1))
                                           (true-listp arr1))))
                 (equal-by-nths-lhs (lambda ()
                                      (trec-to-array n val1 (trec-to-array n val2 arr1))))
                 (equal-by-nths-rhs (lambda ()
                                      (trec-to-array n val1 arr1))))))))


(defthm tr-val-p-of-nth-when-tr-val-list-p
  (implies (and (natp n)
                (< n (len x))
                (tr-val-list-p x))
           (tr-val-p (nth n x)))
  :hints(("Goal" :in-theory (enable nth))))


(defthm trec-to-array-of-set-index
  (implies (and (natp n)
                (natp i)
                (<= i n)
                (true-listp arr)
                ;; NEW HYP
                (tr-val-p val)
                )
           (equal (trec-to-array n (tr-write i val rec) arr)
                  (update-nth i val (trec-to-array n rec arr))))
  :hints(("Goal"
          :use ((:functional-instance
                 equal-by-nths
                 (equal-by-nths-hyp (lambda ()
                                      (and (natp n)
                                           (natp i)
                                           (<= i n)
                                           (tr-val-p val)
                                           (true-listp arr))))
                 (equal-by-nths-lhs (lambda ()
                                      (trec-to-array n (tr-write i val rec) arr)))
                 (equal-by-nths-rhs (lambda ()
                                      (update-nth i val (trec-to-array n rec arr)))))))))



(defthm delete-trec-indices-when-nil
  (equal (delete-trec-indices n nil)
         nil)
  :hints(("Goal" :in-theory (enable tr-write))))

(defthm tr-read-of-delete-trec-indices
  (equal (tr-read key (delete-trec-indices n rec))
         (if (and (natp key)
                  (<= key (nfix n)))
             (tr-val-default)
           (tr-read key rec))))

(defthm delete-trec-indicies-of-array-to-trec
  ;; broken, need new equal-by-g equivalent
  (equal (delete-trec-indices n (array-to-trec n arr rec))
         (delete-trec-indices n rec))
  :hints(("Goal"
          :use ((:functional-instance
                 equal-by-g
                 (equal-by-g-hyp (lambda () t))
                 (equal-by-g-lhs (lambda ()
                                   (delete-trec-indices n (array-to-trec n arr rec))))
                 (equal-by-g-rhs (lambda ()
                                   (delete-trec-indices n rec))))))))

(defthm delete-rec-indices-of-set-index
  ;; broken, need new equal-by-g
  (implies (and (natp n)
                (natp i)
                (<= i n))
           (equal (delete-rec-indices n (s i val rec))
                  (delete-rec-indices n rec)))
  :hints(("Goal"
          :use ((:functional-instance
                 equal-by-g
                 (equal-by-g-hyp (lambda ()
                                   (and (natp n)
                                        (natp i)
                                        (<= i n))))
                 (equal-by-g-lhs (lambda ()
                                   (delete-rec-indices n (s i val rec))))
                 (equal-by-g-rhs (lambda ()
                                   (delete-rec-indices n rec))))))))


(defthm array-to-trec-inverse-lemma
  (equal (tr-read key (array-to-trec n
                                     (trec-to-array n rec arr)
                                     (delete-trec-indices n rec)))
         (tr-read key rec)))

(defthm array-to-trec-inverse
  ;; BROKEN
  (equal (array-to-trec n
                       (trec-to-array n rec arr)
                       (delete-trec-indices n rec))
         rec)
  :hints(("Goal"
          :use ((:functional-instance
                 equal-by-g
                 (equal-by-g-hyp (lambda () t))
                 (equal-by-g-lhs (lambda ()
                                   (array-to-trec n
                                                 (trec-to-array n rec arr)
                                                 (delete-trec-indices n rec))))
                 (equal-by-g-rhs (lambda () rec)))))))

(defthm delete-trec-indices-idempotent
  ;; broken
  (equal (delete-trec-indices n (delete-trec-indices n rec))
         (delete-trec-indices n rec))
  :hints(("Goal"
          :use ((:functional-instance
                 equal-by-g
                 (equal-by-g-hyp (lambda () t))
                 (equal-by-g-lhs (lambda ()
                                   (delete-trec-indices n (delete-trec-indices n rec))))
                 (equal-by-g-rhs (lambda ()
                                   (delete-trec-indices n rec))))))))



(defthm array-trec-pair-p-of-nil
  (implies (and (true-listp arr)
                (equal (len arr) n))
           (array-trec-pair-p arr nil n)))

(defthm array-trec-pair-p-of-update-nth
  (implies (and (array-trec-pair-p arr rec len)
                (force (natp n))
                (force (posp len))
                (force (< n len)))
           (array-trec-pair-p (update-nth n val arr) rec len)))

(defthm array-trec-pair-p-of-delete-rec-indices
  (implies (array-trec-pair-p arr rec len)
           (array-trec-pair-p arr (delete-trec-indices (- len 1) rec) len)))


