command! TrainVocabulary call vocabulary_trainer#TrainVocabulary()
command! -nargs=* -complete=file Train call vocabulary_trainer#Train(<f-args>)
