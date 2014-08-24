(defpackage #:what-to-watch
  (:use :cl :iterate :metatilities :drakma :cl-ppcre :puri)
  (:shadowing-import-from :metatilities minimize finish)
  (:export
    :main))

(in-package :what-to-watch)
