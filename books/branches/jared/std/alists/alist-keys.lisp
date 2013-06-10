; Standard Association Lists Library
; Copyright (C) 2013 Centaur Technology
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
; Original authors: Jared Davis <jared@centtech.com>
;                   Sol Swords <sswords@centtech.com>

(in-package "ACL2")
(include-book "std/lists/list-defuns" :dir :system)
(local (include-book "std/lists/sets" :dir :system))

(defund alist-keys (x)
  (declare (xargs :guard t))
  (cond ((atom x)
         nil)
        ((atom (car x))
         (alist-keys (cdr x)))
        (t
         (cons (caar x) (alist-keys (cdr x))))))

(local (in-theory (enable alist-keys)))

(defthm alist-keys-when-atom
  (implies (atom x)
           (equal (alist-keys x)
                  nil)))

(defthm alist-keys-of-cons
  (equal (alist-keys (cons a x))
         (if (atom a)
             (alist-keys x)
           (cons (car a) (alist-keys x)))))

(encapsulate
  ()
  (local (defthmd l0
           (equal (alist-keys (list-fix x))
                  (alist-keys x))))

  (defcong list-equiv equal (alist-keys x) 1
    :hints(("Goal"
            :use ((:instance l0 (x x))
                  (:instance l0 (x acl2::x-equiv)))))))

(encapsulate
  ()
  (local (defthm l0
           (implies (member (cons a b) x)
                    (member a (alist-keys x)))))

  (local (defthm l1
           (implies (and (subsetp x y)
                         (member a (alist-keys x)))
                    (member a (alist-keys y)))))

  (local (defthm l2
           (implies (subsetp x y)
                    (subsetp (alist-keys x)
                             (alist-keys y)))))

  (defcong set-equiv set-equiv (alist-keys x) 1
    :hints(("Goal" :in-theory (enable set-equiv)))))


(defthm true-listp-of-alist-keys
  (true-listp (alist-keys x))
  :rule-classes :type-prescription)

(defthm alist-keys-of-hons-acons
  (equal (alist-keys (hons-acons key val x))
         (cons key (alist-keys x))))

(defthm alist-keys-of-pairlis$
  (equal (alist-keys (pairlis$ keys vals))
         (list-fix keys)))



(defthm alist-keys-member-hons-assoc-equal
  (iff (member-equal x (alist-keys a))
       (hons-assoc-equal x a))
  :hints(("Goal" :in-theory (enable hons-assoc-equal))))

(defthmd hons-assoc-equal-iff-member-alist-keys
  (iff (hons-assoc-equal x a)
       (member-equal x (alist-keys a)))
  :hints (("goal" :in-theory (enable alist-keys-member-hons-assoc-equal))))

(theory-invariant (incompatible (:rewrite alist-keys-member-hons-assoc-equal)
                                (:rewrite hons-assoc-equal-iff-member-alist-keys)))

(defthmd hons-assoc-equal-when-not-member-alist-keys
  ;; BOZO any reason to have this one?
  (implies (not (member-equal x (alist-keys a)))
           (equal (hons-assoc-equal x a)
                  nil))
  :hints (("goal" :in-theory (enable alist-keys-member-hons-assoc-equal))))


(defthm alist-keys-of-append
  (equal (alist-keys (append x y))
         (append (alist-keys x)
                 (alist-keys y))))

(defthm alist-keys-of-rev
  (equal (alist-keys (rev x))
         (rev (alist-keys x))))

(defthm alist-keys-of-revappend
  (equal (alist-keys (revappend x y))
         (revappend (alist-keys x)
                    (alist-keys y))))
