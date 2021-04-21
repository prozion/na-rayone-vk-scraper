#lang racket

(require odysseus)
(require tabtree)
(require odysseus/api/vk)
(require json)

(require (file "/home/denis/.private/APIs.rkt"))
(set-access-token ($ access_token vk/postagg2_1))

(define CACHEDIR "/var/tmp/projects/na-rayone/dogs")

(define (deactivated? user-info)
  ($ deactivated user-info))

(define-catch (get-users-info uids)
  (let* ((headers (list "Content-Type: application/x-www-form-urlencoded"))
        (body (format "user_ids=~a&fields=deactivated&v=~a&access_token=~a"
                                  (string-join uids ",")
                                  VK_API_VERSION
                                  (_AT))))
    ($ response
      (string->jsexpr
        (post-url
          "https://api.vk.com/method/users.get"
          headers
          body)))))

(define-catch (detect-permanent-dogs group-parameters-h)
  (let* ((gid ($ gid group-parameters-h))
        (gname ($ gname group-parameters-h))
        (_ (--- 1))
        (group-uids (get-group-users gid))
        (group-uids-1000s (partition-all group-uids 1000))
        (_ (--- 2))
        (users-info (for/fold
                      ((res empty))
                      ((group-uids-1000 group-uids-1000s))
                      (append res (get-users-info group-uids-1000))))
        (_ (--- 3))
        (all-cached-files (filter
                            (λ (filename) (re-matches? "\\d\\d\\.\\d\\d\\.\\d\\d\\d\\d\\.rktd" filename))
                            (directory-list (format "~a/~a" CACHEDIR gname))))
        (_ (--- 4))
        (file-latest (for/fold
                          ((res #f))
                          ((filename all-cached-files))
                          (let* ((filedate (first (string-split (->string filename) ".rktd"))))
                            (cond
                              (res (if (d>= filedate res) filedate res))
                              (else filedate)))))
        (_ (--- 5))
        (file-earliest (for/fold
                          ((res #f))
                          ((filename all-cached-files))
                          (let* ((filedate (first (string-split (->string filename) ".rktd"))))
                            (cond
                              (res (if (d<= filedate res) filedate res))
                              (else filedate)))))
        (_ (--- 6))
        (dogs-latest (and file-latest (read-serialized-data-from-file (format "~a/~a/~a.rktd" CACHEDIR gname file-latest ))))
        (dogs-earliest (and file-earliest (read-serialized-data-from-file (format "~a/~a/~a.rktd" CACHEDIR gname file-earliest))))
        (_ (--- 7))
        (dogs-today (for/fold
                      ((res (hash)))
                      ((user-info users-info))
                      (if (deactivated? user-info)
                        (hash-insert res (cons ($ id user-info) (deactivated? user-info)))
                        res)))
        (permanent-dogs (if dogs-earliest
                            (set-intersect (hash-keys dogs-today) (hash-keys dogs-earliest))
                            dogs-today))
        )
    (--- 8)
    (write-data-to-file dogs-today (format "~a/~a/~a.rktd" CACHEDIR gname (current-date)))
    (--- 9)
    (write-file
      (format "~a/~a/permanent-dogs.html" CACHEDIR gname)
      (format "<html><body><div>~a</div></body></html>"
              (for/fold
                ((res ""))
                ((permanent-dog-id permanent-dogs))
                (format "~a~n<div><a href=\"https://vk.com/id~a\">~a</div></li>" res permanent-dog-id permanent-dog-id))))
    #t))

; (detect-permanent-dogs (hash 'gname "shebekino" 'gid "185772763"))
(detect-permanent-dogs (hash 'gname "pornowife" 'gid "148888375"))
