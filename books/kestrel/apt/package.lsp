; APT (Automated Program Transformations) Library
;
; Copyright (C) 2020 Kestrel Institute (http://www.kestrel.edu)
;
; License: A 3-clause BSD license. See the LICENSE file distributed with ACL2.
;
; Author: Alessandro Coglio (coglio@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(include-book "std/portcullis" :dir :system)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpkg "APT" (set-difference-eq
               (append *std-pkg-symbols*
                       '(*defiso-table-name*
                         *fake-runes*
                         *force-xnume*
                         *geneqv-iff*
                         *nil*
                         *t*
                         *unspecified-xarg-value*
                         add-numbered-name-in-use
                         add-suffix
                         add-suffix-to-fn
                         alist-to-doublets
                         all-calls
                         all-ffn-symbs
                         all-nils
                         all-runes-in-ttree
                         append-lst
                         append?
                         apply-fn-if-known
                         apply-fn-into-ifs
                         apply-term
                         apply-term*
                         apply-unary-to-terms
                         assert-equal
                         assume-true-false-aggressive-p
                         attachment-pair
                         body
                         check-user-lambda
                         clausify
                         cltl-def-from-name
                         collect-ideals
                         compute-stobj-flags
                         conc
                         congruence-rule
                         conjoin
                         conjoin-untranslated-terms
                         conjoin2
                         cons-term
                         constant-t-function-arity-0
                         control-screen-output
                         convert-soft-error
                         copy-def
                         current-addr
                         current-theory-fn
                         cw-event
                         def-error-checker
                         defattach-system
                         definedp
                         defiso
                         defiso-info
                         defiso-lookup
                         defun-sk-bound-vars
                         defun-sk-imatrix
                         defun-sk-matrix
                         defun-sk-p
                         defun-sk-quantifier
                         defun-sk-rewrite-kind
                         defun-sk-rewrite-name
                         defun-sk-strengthen
                         defun-sk-witness
                         defun-sk2
                         defxdoc+
                         directed-untranslate
                         directed-untranslate-no-lets
                         disable*
                         disjoin
                         do-all
                         doublets-to-alist
                         drop-fake-runes
                         dumb-negate-lit
                         dumb-occur
                         e/d*
                         enabled-numep
                         enabled-runep
                         enabled-xfnp
                         encapsulate-report-errors
                         ens
                         ensure-boolean$
                         ensure-boolean-or-auto-and-return-boolean$
                         ensure-doublet-list$
                         ensure-function-defined$
                         ensure-function-guard-verified$
                         ensure-function-has-args$
                         ensure-function-known-measure$
                         ensure-function-logic-mode$
                         ensure-function-name-or-numbered-wildcard$
                         ensure-function-no-stobjs$
                         ensure-function-not-in-termination-thm$
                         ensure-function-number-of-results$
                         ensure-function-singly-recursive$
                         ensure-function/lambda-arity$
                         ensure-function/lambda-closed$
                         ensure-function/lambda-guard-verified-exec-fns$
                         ensure-function/lambda-logic-mode$
                         ensure-function/lambda-no-stobjs$
                         ensure-function/lambda/term-number-of-results$
                         ensure-function/macro/lambda$
                         ensure-keyword-value-list
                         ensure-keyword-value-list$
                         ensure-list-no-duplicates$
                         ensure-list-subset$
                         ensure-named-formulas
                         ensure-symbol$
                         ensure-symbol-different$
                         ensure-symbol-list$
                         ensure-symbol-new-event-name
                         ensure-symbol-new-event-name$
                         ensure-term$
                         ensure-term-does-not-call$
                         ensure-term-free-vars-subset$
                         ensure-term-ground$
                         ensure-term-guard-verified-exec-fns$
                         ensure-term-if-call$
                         ensure-term-logic-mode$
                         ensure-term-no-stobjs$
                         ensure-term-not-call-of$
                         equivalence-relationp
                         er-soft+
                         evmac-input-print-p
                         evmac-process-input-hints
                         evmac-process-input-print
                         evmac-process-input-show-only
                         ext-address-subterm-governors-lst
                         ext-address-subterm-governors-lst-state
                         ext-fdeposit-term
                         ext-geneqv-at-subterm
                         ext-rename-formals
                         fargn
                         fargs
                         fcons-term
                         fcons-term*
                         fetch-term
                         ffn-symb
                         ffn-symb-p
                         ffnnamep
                         flambda-applicationp
                         flambdap
                         flatten-ands-in-lit
                         flatten-ands-in-lit-lst
                         fn-copy-name
                         fn-is-fn-copy-name
                         fn-rune-nume
                         fn-ubody
                         formals
                         formals+
                         fquotep
                         fresh-name-in-world-with-$s
                         fsublis-fn-lst-simple
                         fsublis-fn-simple
                         fsublis-var
                         function-intro-macro
                         function-namep
                         fundef-enabledp
                         geneqv-from-g?equiv
                         genvar
                         get-event
                         get-unambiguous-xargs-flg1/edcls1
                         get-unnormalized-bodies
                         guard-raw
                         guard-verified-p
                         ibody
                         implicate
                         implicate-untranslated-terms
                         impossible
                         induction-machine
                         induction-machine-for-fn
                         install-not-norm
                         install-not-norm-event
                         install-not-normalized
                         install-not-normalized-name
                         io?
                         irecursivep
                         justification
                         keyword-listp
                         keyword-value-list-to-alist
                         lambda-applicationp
                         lambda-body
                         lambda-formals
                         macro-namep
                         macro-required-args
                         make-event-terse
                         make-implication
                         make-lambda
                         make-lambda-term
                         make-paired-name
                         maybe-pseudo-event-formp
                         measure
                         merge-sort-lexorder
                         msg-downcase-first
                         must-eval-to-t
                         must-succeed*
                         mvify
                         named-formulas-to-thm-events
                         next-numbered-name
                         non-executablep
                         number-of-results
                         on-failure
                         packn
                         packn-pos
                         pairlis-x1
                         pseudo-event-form-listp
                         pseudo-event-formp
                         pseudo-lambdap
                         pseudo-termfnp
                         pseudo-tests-and-call-listp
                         recursive-calls
                         recursivep
                         remove-assocs-eq
                         remove-keyword
                         remove-lambdas
                         rename-fns
                         rename-fns-lst
                         resolve-numbered-name-wildcard
                         restore-output?
                         rewrite-if-avoid-swap
                         rewrite-if1
                         rewrite1
                         ruler-extenders-lst
                         run-when
                         set-numbered-name-index-end
                         set-numbered-name-index-start
                         set-paired-name-separator
                         simplify-hyps
                         sr-limit
                         stobjs-in
                         stobjs-out
                         str::intern-list
                         str::symbol-list-names
                         strip-cddrs
                         strip-keyword-list
                         subcor-var
                         subcor-var-lst
                         sublis-expr
                         sublis-var
                         subst-expr
                         subst-expr1
                         subst-var
                         symbol-class
                         symbol-package-name-safe
                         symbol-symbol-alistp
                         symbol-truelist-alistp
                         term-guard-obligation
                         termify-clause-set
                         tests-and-call
                         tests-and-calls
                         theorem-intro-macro
                         theorem-namep
                         thm-formula+
                         too-many-ifs-post-rewrite
                         too-many-ifs-pre-rewrite
                         tool2-fn
                         trans-eval
                         trans-eval-error-triple
                         translate-hints
                         translate-term-lst
                         try-event
                         ubody
                         uguard
                         unnormalized-body
                         untranslate-lst
                         unwrapped-nonexec-body
                         variablep
                         well-founded-relation))

; It's not clear why acl2::simplify is in *acl2-exports*.  That may change, but
; for now it is convenient to avoid importing it into the "APT" package in view
; of there possibly being a SIMPLIFY transformation in the future.

               '(simplify)))
