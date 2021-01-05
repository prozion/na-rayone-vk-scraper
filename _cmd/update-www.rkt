#lang racket

(require odysseus)
(require odysseus/read/vk)
(require odysseus/write/csv)
(require tabtree)
(require tabtree/html)
(require (file "/home/denis/.private/APIs.rkt"))

(require "../_lib/globals.rkt")
(require "../_lib/functions.rkt")
(require "../_lib/page_snippets.rkt")

(define-namespace-anchor a)
(define ns (namespace-anchor->namespace a))

(define news_cards "")
(define page-id "")

(persistent h-galias-gid)
(persistent anapa-posts)

(set-access-token ($ access_token vk/postagg3_1))

(define anapa.tree "../knowledge/anapa.tree")

(define anapa-items (get-entities anapa.tree))

(define PAGES (get-sitemap))

(define-catch (update-cache)
  (parameterize ((Name-id-hash (h-galias-gid)))
    (cache-posts
        #:source (list anapa.tree)
        #:write-to-cache (string-append CACHE_DIR "/anapa_posts.rktd")
        #:ignore-with-status #t
        #:ignore-sleepy #t
        #:read-depth 42)
  #t))

(define-catch (update-page page_id #:note (note "") #:template (template-name #f) #:gen-ext (gen-ext "html"))
  (unless (empty-string? note) (--- (str "\n" note)))
  (set! page-id page_id)
  (let* ((page-id-string (string-downcase (->string page-id)))
        (template-name (or template-name page-id-string))
        (processed-template (process-html-template (format "../_templates/~a.t" template-name) #:tabtree-root "../knowledge" #:namespace ns)))
    (write-file (format "../www/~a.~a" page-id-string gen-ext) processed-template)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(--- (format "~a: Обновляем контент сайта" (timestamp)))

; (update-cache)

(--- "Компилируем страницы сайта")

(set! news_cards (make-cards
                    (filter-posts
                        (anapa-posts)
                        #:entities anapa-items
                        #:within-days WITHIN_DAYS
                        #:min-symbols MIN_SYMBOLS)
                    #:entities anapa-items
                    #:max-brs MAX_BRS
                    ))
(update-page 'Anapa #:note "Объявления Анапы" #:template "news")

(--- (format "~a Конец компиляции~n~n" (timestamp)))
