#!/usr/bin/env sbcl --noinform --script
(load "~/.sbclrc")
(ql:quickload :what-to-watch)
(what-to-watch:main nil)

