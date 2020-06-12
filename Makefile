index.html: index.md Makefile style.css B.inc
	pandoc $< --standalone --css=style.css -B B.inc -o  $@

sync: index.html
	now
