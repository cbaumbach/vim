if exists("b:current_syntax")
    finish
endif

syntax match RComment "\v#.*$"
highlight link RComment Comment

syntax region RDoubleQuotedString start=/"\v/ skip=/\v\\./ end=/\v"/
syntax region RSingleQuotedString start=/'\v/ skip=/\v\\./ end=/\v'/
highlight link RDoubleQuotedString String
highlight link RSingleQuotedString String

let b:current_syntax = "R"
