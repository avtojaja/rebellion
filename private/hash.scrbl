#lang scribble/manual

@(require (for-label racket/base
                     racket/contract/base
                     rebellion/base/immutable-string
                     rebellion/collection/entry
                     rebellion/collection/hash
                     rebellion/streaming/reducer
                     rebellion/type/record)
          (submod rebellion/private/scribble-evaluator-factory doc)
          scribble/example)

@(define make-evaluator
   (make-module-sharing-evaluator-factory
    #:public (list 'rebellion/base/immutable-string
                   'rebellion/collection/entry
                   'rebellion/collection/hash
                   'rebellion/streaming/reducer
                   'rebellion/type/record)
    #:private (list 'racket/base)))

@title{Hash Tables}
@defmodule[rebellion/collection/hash]

@deftogether[[
 @defproc[(immutable-hash? [v any/c]) boolean?]
 @defproc[(mutable-hash? [v any/c]) boolean?]]]{
 Convenience predicates for immutable and mutable hash tables, respectively.
 Implies @racket[hash?].}

@deftogether[[
 @defthing[into-hash reducer?]
 @defthing[into-mutable-hash reducer?]]]{
 A pair of @tech{reducers} that build either an immutable hash table or a
 mutable hash table from a sequence of @tech{entries}. Duplicate keys are not
 allowed, and attempting to reduce a sequence containing duplicate keys will
 raise @racket[exn:fail:contract].

 @(examples
   #:eval (make-evaluator) #:once
   (for/reducer into-hash
                ([str (immutable-string-split "The quick brown fox")])
     (entry (string-downcase str)
            (immutable-string-length str))))}

@deftogether[[
 @defproc[(combine-into-hash [value-combiner (-> any/c any/c any/c)]) reducer?]
 @defproc[(combine-into-mutable-hash [value-combiner (-> any/c any/c any/c)])
          reducer?]]]{
 Constructs a @tech{reducer} that combines a sequence of @tech{entries} into
 either an immutable hash table or a mutable hash table, respectively. Values
 for duplicate keys are combined using @racket[value-combiner].

 @(examples
   #:eval (make-evaluator) #:once
   (reduce (combine-into-hash immutable-string-append)
           (entry 1 "apple")
           (entry 1 ".")
           (entry 1 "banana")
           (entry 2 "orange")
           (entry 2 ".")
           (entry 2 "grape"))))}

@defthing[empty-hash immutable-hash? #:value (hash)]{
 The empty (immutable) hash table.}

@defproc[(hash-set-entry [h immutable-hash?] [e entry?]) immutable-hash?]{
 Like @racket[hash-set], but accepting a single @tech{entry} argument instead of
 separate key and value arguments.}

@defproc[(hash-set-entry! [h mutable-hash?] [e entry?]) void?]{
 Like @racket[hash-set!], but accepting a single @tech{entry} argument instead
 of separate key and value arguments.}

@defproc[(in-hash-entries [h immutable-hash?]) (sequence/c entry?)]{
 Returns a sequence of the @tech{entries} in @racket[h].}

@defproc[(in-mutable-hash-entries [h mutable-hash?]) (sequence/c entry?)]{
 Returns a sequence of the @tech{entries} in @racket[h].}
