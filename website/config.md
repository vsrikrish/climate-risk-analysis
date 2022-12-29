
+++
author = "Vivek Srikrishnan"
mintoclevel = 2
maxtoclevel = 3
prepath = "climate-risk-analysis"
hasmath = false
generate_rss = false

ignore = ["node_modules/", "lecture-notes/"]
weave = false
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
\newcommand{\blurb}[1]{
    ~~~
    <span style="font-size:24px;font-weight:300;">!#1</span>
    ~~~
}
\newcommand{\refblank}[2]{
    ~~~
    <a href="!#2" target="_blank" rel="noopener noreferrer">#1</a>
    ~~~
}
\newcommand{\lineskip}{@@blank@@} 
\newcommand{\skipline}{\lineskip} 
\newcommand{\note}[1]{@@note @@title ⚠ Note@@ @@contents #1 @@ @@} 
\newcommand{\warn}[1]{@@warning @@title ⚠ Warning!@@ @@contents #1 @@ @@}

\newcommand{\esc}[2]{ julia:esc__!#1 #hideall using Markdown println("\`\`\`\`\`plaintext $(Markdown.htmlesc(raw"""#2""")) \`\`\`\`\`") \textoutput{esc__!#1} }

\newcommand{\esch}[2]{ julia:esc__!#1 #hideall using Markdown println("\`\`\`\`\`html $(Markdown.htmlesc(raw"""#2""")) \`\`\`\`\`") \textoutput{esc__!#1} }

\newcommand{\span}[2]{~~~~~~!#2~~~~~~}

\newcommand{\goto}[1]{~~~✓→~~~}

\newcommand{\smindent}[1]{\span{width:45px;text-align:right;color:slategray;}{#1}} \newcommand{\smnote}[1]{\style{font-size:85%;line-height:0em;}{#1}}

\newcommand{\figenv}[3]{
~~~
<figure style="text-align:center;">
<img src="!#2" style="padding:0;#3" alt="#1"/>
<figcaption>#1</figcaption>
</figure>
~~~
}

\newcommand{\nblink}[1]{https://raw.githubusercontent.com/vsrikrish/climate-risk-analysis/gh-pages/tutorials/notebooks/!#1/!#1.ipynb}
\newcommand{\tgz}[1]{https://raw.githubusercontent.com/vsrikrish/climate-risk-analysis/gh-pages/tutorials/notebooks/!#1.tar.gz}}
\newcommand{\zip}[1]{https://raw.githubusercontent.com/vsrikrish/climate-risk-analysis/gh-pages/tutorials/notebooks/!#1.zip}}

\newcommand{\tutorial}[1]{ 
This tutorial can be downloaded as a [Jupyter notebook](\nblink{#1}); follow instructions in the notebook to download or view any relevant `Project.toml` or `Manifest.toml` files. You can also download the entire folder as a [tar.gz](\tgz{#1}) or a [zip](\zip{#1}) file.

\toc\literate{/_literate/!#1/tutorial.jl} }
