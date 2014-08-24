;;; -*- What-To-Watch: Small tool to help to keep track of new anime. -*-

(defpackage #:what-to-watch-asd
  (:use :cl :asdf))

(in-package #:what-to-watch-asd)

(defsystem what-to-watch
  :name "what-to-watch"
  :version "0.1"
  :author "Alexander Fedora"
  :licence "MIT"
  :description "What-To-Watch: Small tool to help to keep track of new anime."
  :depends-on (:iterate :metatilities :split-sequence :drakma :cl-ppcre :puri)
  :components ((:file "package")
               (:file "what" :depends-on ("package"))
               (:file "main" :depends-on ("what"))))

