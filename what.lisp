(in-package :what-to-watch)

;"http://rutracker.org/forum/viewtopic.php?t=4786394"
;   "http://rutracker.org/forum/viewtopic.php?t=4777752"
;   "http://rutracker.org/forum/viewtopic.php?t=4781143"

(defun get-watch-url-list()
  '(
   "http://tr.anidub.com/anime_tv/anime_ongoing/9436-v-podzemele-ya-poydu-tam-krasavicu-naydu-danmachi-01-iz-12.html"
   "http://tr.anidub.com/anime_ova/8856-vtorzhenie-titanov-shingeki-no-kyojin-ova-1-iz-2.html"
   "http://tr.anidub.com/anime_tv/anime_ongoing/9306-anime-ot-a-do-ya-shirobako-01-iz-hh.html"
   "http://rutracker.org/forum/viewtopic.php?t=4844855"
   ))

(defun extract-name(link)
  (let* ((start-pos (position #\> link))
   (end-pos (position #\[ link)))
    (if (or (eql start-pos nil) (eql end-pos nil))
  "unknown"
  (subseq link (+ start-pos 1) (- end-pos 1)))))

(defun extract-progress(link)
  (cl-ppcre:scan-to-strings "\\[[0-9\-]+ из [0-9]+\\+?\\]" link))

(defun extract-title-block(patterns content)
  (cl-ppcre:scan-to-strings (getf patterns :title) content))

(defun extract-link-block(patterns title)
  (cl-ppcre:scan-to-strings (getf patterns :link) title))

(defun extract-title-patterns(patterns content)
  (let* ((link (extract-link-block patterns (extract-title-block patterns content)))
   (progress (extract-progress link))
   (name (extract-name link)))
    (list name (or progress "???"))))

(defun extract-title-rutracker(content)
  (let ((patterns '(:title "<h1 class=\\\"maintitle\\\"><a[^>]+>.*" :link "<a[^>]+>(([^<]*))")))
    (extract-title-patterns patterns content)))

(defun extract-title-anidub(content)
  (let ((patterns '(:title "<span id=\\\"news-title\\\">.*" :link ">(([^<]*))")))
    (extract-title-patterns patterns content)))

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
