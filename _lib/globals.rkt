#lang racket

(require odysseus)
;
(provide (all-defined-out))
;
(define HOURS_SHIFT 3) ; to correct output time, regarding time of the scraping script on the remote server

(define MAX_SYMBOLS 500)
(define MIN_SYMBOLS 50)
(define MAX_BRS 5) ; maximum number of <br> (effectively - lines of text)
(define WITHIN_DAYS 1)
(define DEFAULT_PLACE #f)
;
(define MIN_MEMBER 1)
(define MAX_MEMBERS_IN_SCANNED_GROUPS 10000)

; how frequently to write to the file, when changing persistence
(define FILE_WRITE_FREQUENCY 500)

; cache directory for persistent data:
; (define CACHE_DIR "_cache")
(define CACHE_DIR "/var/tmp/projects/na-rayone")
(define SERVER_DIR "/var/www/html/pages/na_rayone")
