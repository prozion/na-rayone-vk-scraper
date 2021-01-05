#lang racket

(require compatibility/defmacro)
(require odysseus)
(require tabtree)
(require odysseus/read/vk)
(require odysseus/write/csv)

(require (file "/home/denis/.private/APIs.rkt"))
;
(require "globals.rkt")
;
(require (for-syntax odysseus))

(provide (all-defined-out))

; (define PLACES_COORS (map
;                         (λ (entity)
;                             (hash-union
;                               (hash 'id (string-downcase ($ id entity)))
;                               entity))
;                         (append
;                           (get-leaves (parse-tab-tree "../knowledge/russia_places_1.tree"))
;                           (get-leaves (parse-tab-tree "../knowledge/russia_places_2.tree")))))

(define-catch (get-coors-of-the-place place_string places_coors)
  (let* ((place (and place_string (@id (string-downcase place_string) places_coors)))
        (latlon? (and ($ lat place) ($ lon place)))
        (ref? ($ ref place))
        (coors_hash (or
                  (and latlon? place)
                  (and ref? (get-coors-of-the-place ($ ref place) places_coors))
                  (let ((city_name (first (string-split place_string "__"))))
                    (cond
                      ((equal? city_name place_string) #f)
                      (else (get-coors-of-the-place city_name places_coors)))))))
    coors_hash))

(define-catch (coors-in-south? lat lon)
  (let ((lat (->number lat))
        (lon (->number lon)))
    (and
      lat
      lon
      (> lat 41.0)
      (> lon 32.4)
      (< lon 49.2)
      (or
        ; Воронежский выступ
        (and
          (< lat 52.0)
          (> lon 38.5)
          (< lon 42.3))
        ; Камышинская сторона
        (and
          (< lat 50.3)
          (> lon 42.3)
          (< lon 47.3))
        ; От Крыма до Астрахани
        (and
          (< lat 48.4))))))
