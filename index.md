% Annotated source code with Pandoc and highlight.js
% Pradeep Gowda
% Jun 12, 2020

You can use `pandoc` to render a source file interspersed with annotations. I find this approach useful when studying
unfamiliar code -- written by some one else, in a language I'm unfamiliar with (this experiment started when I had to reimplement a 5 year old solution written in Perl5, with no tests and documentation).

Step 1: copy the source code you are planning to study to a markdown file (extension `.md`)

Step 2: "Select all" the text and `[TAB]` one level (4 characters).

Step 3: Start writing your annotations at column 0 (beginning of the line)

Step 4: Compile the annotated file into a easy to read HTML file (especially useful if you are trying to "present"/ code-review with your team), with the following command:

	pandoc source.md --standalone -B B.inc --css=style.css -o annotated.html

where, `B.inc` contains the following css and js lines to help with syntax highlighting:

	<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@10.0.0/build/styles/default.min.css">
	<script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@10.0.0/build/highlight.min.js"></script>
	<script>hljs.initHighlightingOnLoad();</script>

## Example: Annotated csv2html script

(The original source code can be found [here](https://github.com/btbytes/csv2html))

Use Python3. You can use `#!/usr/bin/python3`, but the location of python interpreter may be different on another machine.


	#!/usr/bin/env python3

This program has only one (standard library) dependency:

	import csv

Even though this is a small program, and can be written at the "top-level" or "main" method, we will write a seperate method. This way, you can
call it from another program or write test cases (This program does not have a test).


	def csv2html(csvfile, delimiter, quotechar, caption, title, header=False):


I've inlined the HTML generation because

1. the template is quite small
2. Python doesn't ship with HTML generation libraries.
3. See my [csv2html.nim](https://github.com/btbytes/csv2html.nim) project to see how I'm using Nim's source code filters to seperate HTML from the main code.

	    print('''<!doctype html><head><style type="text/css">
	                table {
	                  border-collapse: collapse;
	                  margin-bottom: 10px;
	                }

	                td,
	                th {
	                  padding: 6px;
	                  text-align: left;
	                }

	                thead {
	                  border-bottom: 1px solid var(--border);
	                }

	                tfoot {
	                  border-top: 1px solid var(--border);
	                }

	                tbody tr:nth-child(even) {
	                  background-color: var(--background-alt);
	                }</style></head><body>
	                ''')
	    if title:
	        print(f'''<h1>{title}</h1>''')
	    print('<table>')
	    if caption:
	        print(f'<caption>{caption}</caption>')
	    with open(csvfile, 'r') as f:
	        reader = csv.reader(f, delimiter=delimiter, quotechar=quotechar)
	        for idx, row in enumerate(reader):
	            if idx == 0 and header:
	                td = 'th'
	            else:
	                td = 'td'
	            print('<tr>')
	            for col in row:
	                print(f'<{td}>{col}</{td}>')
	            print('</tr>')
	        print('</table>')

Using `argparse`  library to provide a nice command line user experience is easy and helpful thing to do. Even if its for your own use, six months from now, you don't have to remember if the optionX was the first argument to the program or the third.

	if __name__ == '__main__':
	    import argparse
	    parser = argparse.ArgumentParser(description='CSV to HTML converter.')
	    parser.add_argument('csvfile')
	    parser.add_argument(
	        '--delimiter', help='Field delimiter. Default is , .', default=',')
	    parser.add_argument(
	        '--quotechar', help='Quote Character. Deault is nothing')
	    parser.add_argument(
	        '--title', help='Page title. Will be printed in h1 tag.')
	    parser.add_argument('--caption', help='Table caption.')
	    parser.add_argument(
	        '--header',
	        action='store_true',
	        help='data has header. First row will be "th".')
	    args = parser.parse_args()
	    csv2html(args.csvfile, args.delimiter, args.quotechar,
	             args.caption, args.title, args.header)

Caveat: This way of annotating the file is for "code reading" (which we all should be doing more often), and does not make any claims about "literate programming" where you can expect things like "tangling".

Hopefully this way of annotating the programs for study will prove useful to you.

Let me know what you think -- [\@btbytes](https://twitter.com/btbytes)


----

The source files used in this presentation:

* [index.md](index.md)
* [B.inc](B.inc)
* [Makefile](Makefile)
* [style.css](style.css)
