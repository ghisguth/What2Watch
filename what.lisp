(defun load-quicklisp()
  (let ((quicklisp-init (merge-pathnames ".quicklisp/setup.lisp"
					 (user-homedir-pathname))))
    (when (probe-file quicklisp-init)
      (load quicklisp-init))))

(load-quicklisp)
(require :drakma)
(require :cl-ppcre)

(defun get-watch-url-list()
  '("http://rutracker.org/forum/viewtopic.php?t=4786394"
   "http://rutracker.org/forum/viewtopic.php?t=4777752"
   "http://rutracker.org/forum/viewtopic.php?t=4781143"))

(defun extract-title-block(content)
  (cl-ppcre:scan-to-strings "<h1 class=\\\"maintitle\\\"><a[^>]+>.*" content))

(defun extract-link-block(title)
  (cl-ppcre:scan-to-strings "<a[^>]+>(([^<]*))" title))

(defun extract-progress(link)
  (cl-ppcre:scan-to-strings "\\[[0-9\-]+ из [0-9]+\\]" link))

(defun extract-name(link)
  (let* ((start-pos (position #\> link))
	 (end-pos (position #\[ link)))
    (if (or (eql start-pos nil) (eql end-pos nil))
	"unknown"
	(subseq link (+ start-pos 1) (- end-pos 1)))))

(defun extract-title(content)
  (let* ((link (extract-link-block (extract-title-block content)))
	  (progress (extract-progress link))
	  (name (extract-name link)))
    (list name progress)))

(defun process-url(url)
  (format t "~a~%" url)
  (let ((content (drakma:http-request url)))
    (let ((title (extract-title content)))
      (format t "~a [92m~a[0m~%" (first title) (second title)))))

(defun process-urls(urls)
   (dolist (url urls) (process-url url))) 

;; entry point
(defun main()
  (format t "what?!~%")
  (let ((urls (get-watch-url-list)))
	(process-urls urls)))

(main)
