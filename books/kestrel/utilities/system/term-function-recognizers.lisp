; System Utilities -- Term Function Recognizers
;
; Copyright (C) 2018 Kestrel Institute (http://www.kestrel.edu)
;
; License: A 3-clause BSD license. See the LICENSE file distributed with ACL2.
;
; Author: Alessandro Coglio (coglio@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(include-book "kestrel/std/system/term-function-recognizers" :dir :system)

(include-book "std/util/deflist" :dir :system)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(std::deflist termfn-listp (x wrld)
  (termfnp x wrld)
  :guard (plist-worldp-with-formals wrld)
  :parents (term-utilities term-function-recognizers)
  :short "Recognize true lists of
          valid <see topic='@(url termfnp)'>translated term functions</see>."
  :long
  "<p>
   We would need stronger world assumptions for @(':elementp-of-nil nil'),
   so with the current weaker world assumptions we leave the default,
   i.e. @(':elementp-of-nil :unknown').
   </p>"
  :true-listp t)
