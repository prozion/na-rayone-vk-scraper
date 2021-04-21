#lang racket

(require odysseus)
(require tabtree)
(require odysseus/api/vk)
(require json)

(require (file "/home/denis/.private/APIs.rkt"))
(set-access-token ($ access_token vk/postagg3_1))

; How to check outcoming HTTP requests:
; > <strike>sudo tcpdump -i any -w /tmp/http.log &</strike>
; > sudo tcpdump -A -s 0 'src api.vk.com and tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
; > tcpdump -A -r /tmp/http.log | less
; > killall tcpdump

; (---
;   (string->jsexpr
;     (get-url
;       ; "https://api.vk.com/method/wall.getById?params[posts]=-179961837_3196&params[extended]=0&params[v]=5.126")))
;       (format "https://api.vk.com/method/wall.getById?posts=~a&v=~a&access_token=~a"
;                         "-195298682_2874"
;                         VK_API_VERSION
;                         (_AT)))))

(---
  (let* (
        (uids (list "642166954" "641734619"))
        (headers (list "Content-Type: application/x-www-form-urlencoded"))
        (body (format "user_ids=~a&fields=deactivated&v=~a&access_token=~a"
                                (string-join uids ",")
                                VK_API_VERSION
                                (_AT))))
      (string->jsexpr
        (post-url
          "https://api.vk.com/method/users.get"
          ; "http://denis-shirshov.ru"
          headers
          body))))
