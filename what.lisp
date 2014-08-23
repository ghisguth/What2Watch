(defun load-quicklisp()
  (let ((quicklisp-init (merge-pathnames ".quicklisp/setup.lisp"
					 (user-homedir-pathname))))
    (when (probe-file quicklisp-init)
      (load quicklisp-init))))

(load-quicklisp)
(require :drakma)
(require :cl-ppcre)
(require :puri)

(defun get-watch-url-list()
  '("http://rutracker.org/forum/viewtopic.php?t=4786394"
   "http://rutracker.org/forum/viewtopic.php?t=4777752"
   "http://rutracker.org/forum/viewtopic.php?t=4781143"
   "http://tr.anidub.com/anime_tv/anime_ongoing/9088-mastera-mecha-onlayn-2-sword-art-online-ii-01-iz-24.html"
   "http://tr.anidub.com/anime_tv/anime_ongoing/9070-ubiyca-akame-akame-ga-kill-prevyu.html"
   "http://tr.anidub.com/anime_tv/anime_ongoing/9113-rezonans-uzhasa-zankyou-no-terror-01-11.html"))

(defun extract-name(link)
  (let* ((start-pos (position #\> link))
	 (end-pos (position #\[ link)))
    (if (or (eql start-pos nil) (eql end-pos nil))
	"unknown"
	(subseq link (+ start-pos 1) (- end-pos 1)))))

(defun extract-progress(link)
  (cl-ppcre:scan-to-strings "\\[[0-9\-]+ из [0-9]+\\]" link))

(defun extract-title-block-rutracker(content)
  (cl-ppcre:scan-to-strings "<h1 class=\\\"maintitle\\\"><a[^>]+>.*" content))

(defun extract-link-block-rutracker(title)
  (cl-ppcre:scan-to-strings "<a[^>]+>(([^<]*))" title))

(defun extract-title-rutracker(content)
  (let* ((link (extract-link-block-rutracker (extract-title-block-rutracker content)))
	  (progress (extract-progress link))
	  (name (extract-name link)))
    (list name progress)))

(defun extract-title-block-anidub(content)
  (cl-ppcre:scan-to-strings "<span id=\\\"news-title\\\">.*" content))

(defun extract-link-block-anidub(title)
  (cl-ppcre:scan-to-strings ">(([^<]*))" title))

(defun extract-title-anidub(content)
  (let* ((link (extract-link-block-anidub (extract-title-block-anidub content)))
	  (progress (extract-progress link))
	  (name (extract-name link)))
    (list name (or progress "???"))))

;(defun extract-title(url content)
;  (case (find-symbol (string-upcase (puri:uri-host (puri:parse-uri url))))
;    (rutracker.org (extract-title-rutracker content))
;    (tr.anidub.com (extract-title-anidub content))
;    (t '("unknown" "???"))))

(defun extract-title(url content)
  (let ((hostname (puri:uri-host (puri:parse-uri url))))
    (cond 
      ((equalp hostname "rutracker.org") (extract-title-rutracker content))
      ((equalp hostname "tr.anidub.com") (extract-title-anidub content))
      (t '("unknown" "???")))))

(defun process-url(url)
  (format t "~a~%" url)
  (let ((content (drakma:http-request url :external-format-in :utf-8)))
    (let ((title (extract-title url content)))
      (format t "~a [92m~a[0m~%" (first title) (second title)))))

(defun process-urls(urls)
   (dolist (url urls) (process-url url))) 

;; entry point
(defun main()
  (format t "what?!~%")
  (let ((urls (get-watch-url-list)))
	(process-urls urls)))

(main)
