syn match cMacrosConstant "\<[A-Z_][A-Z0-9_]*\>" 
syn match cMacrosFunction "\<[A-Z_][A-Z0-9_]*\>*\ze\s*(" 
syn match cDesignatedInitializer "\v\s+\zs(\.\h\w*)+\ze\s*\=" containedin=cBlock contained keepend
syn match cCustomType "\v<\h\w*>[* \t\n]*\ze\h\w*\s*[;=]" containedin=cBlock

syn keyword cType s8 s16 s32 s64 u8 u16 u32 u64 f32 f64

hi def link cDesignatedInitializer Identifier
hi def link cMacrosConstant cConstant
hi def link cMacrosFunction cStorageClass
hi def link cCustomType cType

