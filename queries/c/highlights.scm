;; extends

((type_identifier) @type.builtin
 (#any-of? @type.builtin "u8" "u16" "u32" "u64" "s8" "s16" "s32" "s64" "f32" "f64" "b32"))
((primitive_type) @type.builtin)

((comment)+ @comment.todo
  (#any-match? @comment.todo "TODO"))
((comment)+ @comment.note
  (#any-match? @comment.note "NOTE"))
((comment)+ @comment.error
  (#any-match? @comment.error "BUG"))
