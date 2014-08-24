all:
	@sbcl --non-interactive --load ~/.quicklisp/setup.lisp \
		--eval '(ql:write-asdf-manifest-file "systems.txt")'
	@buildapp --manifest-file systems.txt \
		--manifest-file ~/.quicklisp/local-projects/system-index.txt \
		--load-system what-to-watch \
		--entry what-to-watch:main \
		--output what-to-watch
	@rm systems.txt

