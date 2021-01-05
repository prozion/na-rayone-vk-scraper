#lang racket

(require odysseus)
;
(provide (all-defined-out))
;
(define HOURS_SHIFT 3) ; to correct output time, regarding time of the scraping script on the remote server

(define MAX_SYMBOLS 500)
(define MIN_SYMBOLS 200)
(define MAX_BRS 5)
(define WITHIN_DAYS 3)
(define DEFAULT_PLACE #f)

(define month-abbrs
  (hash "01" "янв"
        "02" "фев"
        "03" "мар"
        "04" "апр"
        "05" "мая"
        "06" "июн"
        "07" "июл"
        "08" "авг"
        "09" "сен"
        "10" "окт"
        "11" "ноя"
        "12" "дек"))
;
(define MIN_MEMBER 1)
(define MAX_MEMBERS_IN_SCANNED_GROUPS 10000)

; how frequently to write to the file, when changing persistence
(define FILE_WRITE_FREQUENCY 500)

; cache directory for persistent data:
; (define CACHE_DIR "_cache")
(define CACHE_DIR "/var/tmp/projects/na_anape/_cache")
