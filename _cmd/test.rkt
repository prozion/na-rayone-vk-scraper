#lang racket

(require odysseus)
(require tabtree)
(require odysseus/read/vk)
(require json)

(require (file "/home/denis/.private/APIs.rkt"))
(set-access-token ($ access_token vk/postagg3_1))

(---
  (string->jsexpr
    (get-url
      ; "https://api.vk.com/method/wall.getById?params[posts]=-179961837_3196&params[extended]=0&params[v]=5.126")))
      (format "https://api.vk.com/method/wall.getById?posts=~a&v=~a&access_token=~a"
                        "-195298682_2874"
                        VK_API_VERSION
                        (_AT)))))
