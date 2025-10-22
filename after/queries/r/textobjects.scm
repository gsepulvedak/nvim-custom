;; extends
; --- Select 2+ consecutive comment lines as one block ---
((comment) @c.start
  .
  (comment)+ @c.rest
  (#make-range! "comment.block" @c.start @c.rest))

; --- Fallback: single comment line as a block too ---
((comment) @c.only
  (#make-range! "comment.block" @c.only @c.only))
