(in-package :what-to-watch)

(defun main(args)
  (declare (ignore args))
  (in-package :what-to-watch)
  (format t "what?!~%")
  (let ((urls (get-watch-url-list)))
	(process-urls urls)))
