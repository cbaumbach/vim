if exists("b:current_syntax")
    finish
endif

hi CorrectAnswer ctermfg=Green ctermbg=Black guifg=Green guibg=Black
hi WrongAnswer ctermfg=Red ctermbg=Black guifg=Red guibg=Black
hi Hidden ctermfg=Black ctermbg=Black guifg=Black guibg=Black

syntax match vocabulary_trainer_correct_answer "\v(^\> )@<=.*( \+$)@="
syntax match vocabulary_trainer_wrong_answer "\v(^\> )@<=.*( -$)@="
syntax match vocabulary_trainer_hidden /\v [-+]$/

hi! link vocabulary_trainer_correct_answer CorrectAnswer
hi! link vocabulary_trainer_wrong_answer WrongAnswer
hi! link vocabulary_trainer_hidden Hidden

let b:current_syntax = "vocabulary_trainer"
