@def hascode = false

@@banner
# Assignment Logistics
@@

\toc

## Getting Assignments

We will use GitHub Classroom to manage assignments and projects this semester. GitHub Classroom will send out invites when assignments are ready, and will create an individual or group repository for you to work in. You will need [a GitHub account](/software#setup_an_account).

### Why Are We Using GitHub Classroom?

We are using GitHub in this class for a number of reasons.

- Version control is a best practice for software, and many of you are likely to take jobs which involve working with code.
- GitHub Classroom makes it easy to assign and collect group and individual assignments. You'll receive an email when an assignment is ready, and the repository will be automatically set up on GitHub, so all you have to do is [clone it to your computer](/software#clone_your_repository).
- As GitHub allows code others to view and comment on code, it also facilitates collective debugging with classmates and instructors, rather than requiring us to work off shared screenshots or email threads. You can just share the link to your assignment repository on Slack and we can see the current state of your code, as well as any previous versions.
- Finally, GitHub provides documentation of the state of your code at any given time, so if there is a hiccup in submission to Gradescope, you have proof that your code was effectively ready on time!

### Accepting An Assignment

When we release an assignment, you will receive an email from GitHub Classroom containing an invitation link. This link will be provided in a pinned post in the relevant Ed Discussion forum. **You should access the assignment through this link**. When you click on this link, GitHub Classroom will ask you if you want to accept the invitation. If you answer "yes," a new repository will be created for you containing the repository template. In this class, this template will include the following files.

1. `README.md` with an overview of the assignment and its objectives.
2. `assignment.ipynb`, which is a Jupyter notebook containing assignment instructions. You should add your code to this notebook, evaluate it, and export it to a PDF for submission.
3. `Project.toml`, which is a file specifying the Julia packages and their versions which should be installed (you won't have to do anything with this file, but it's provided to reduce the risk of any issues with package versions. This environment will be automatically loaded (and any needed packages installed) before your code is compiled, so you don't need to explicitly do so in your report. The list of packages which are included in the environment will be provided in the repository README. For each assignment, this environment should be sufficient, but if you come across another package you want to use, feel free to use Julia's `Pkg` package manager to add it.
4. Any additional files, such as figures, required for the assignment.

Your new repository will be called "hwx-<your-GitHub-username> and will be linked to your account (and listed under the list of your account's repositories).

## Working with Jupyter Notebooks

The main file in your repository that you will be editing will be named `hwx.ipynb`, which is a [Jupyter notebook](https://jupyter.org/). These notebooks allow the integration of text and code, and can be run with a variety of programming languages, including Julia (via the `IJulia.jl` package). However, running them with Julia kernels (the backend allowing Julia code to be evaluated) requires some setup. There are several cloud-based solutions that you could use, but these can often take time (to allow server space to free up) or cost money, so we'll focus on local options.

### Editing With VS Code

[VS Code](https://code.visualstudio.com/) is the integrated development environment (IDE) that we recommend, though other setups are possible for other IDEs. VS Code has a full-featured [Julia extension] which includes support for Jupyter notebooks. After [installing Julia](/software/#install-julia), the Julia VS Code extension should automatically detect your Julia version (let me know if this does not work), allowing it to be used for Jupyter notebooks, as well as for running Julia scripts and opening a REPL for code evaluation. 

Once the extension is installed, you should be able to open the `.ipynb` file and edit it. Attempting to run cells will prompt you to select a kernel if you haven't already done so. 

### Editing With IJulia

Another option is to install the [`IJulia.jl`](https://github.com/JuliaLang/IJulia.jl) package. You can open a browser-based notebook interface with the following REPL commands:

```julia-repl
using IJulia
notebook()
```

and can navigate to your local repository folder and open the notebook.

### Typesetting Math

You can typeset math using LaTeX syntax. If LaTeX is output from a Julia block, this will also be rendered appropriately.

## Submitting Assignments

### Format of Gradescope Submissions

You should submit your assignments as PDFs, not as notebooks (e.g. don't submit `.ipynb` files). Before converting to a PDF, make sure that you have evaluated all of the cells in whatever 

### Converting Notebooks to PDF

There are several different methods to produce a PDF from your notebook *after running all cells* (so the output is displayed) and saving. We will describe one of them which does not involve installing anything else. If you have a Python installation and have installed the `jupyter` Python package, you can use the [`nbconvert` tool](https://nbconvert.readthedocs.io/en/latest/usage.html), or you can convert using VS Code or IJulia's export functionality if you have a Python installation (export to HTML and save as PDF) or Python and LaTeX installed (directly convert to PDF). If you would like help with these options, come talk to Vivek.

#### Converting with NBViewer

After you've evaluated your notebook's cells, saved this version of the notebook, and [committed](/software/#commit-changes) and [pushed](/software/#pushing-commits) the `.ipynb` file to GitHub, you can navigate to your repository and click on the `.ipynb` file, which should open a page which looks like the following:

![Notebook Displayed Within GitHub](/assets/images/github-notebook.png)

Copy the page's URL, and go to [NBViewer](https://nbviewer.org/). Paste the URL into the prompt, as shown in the image below.

![Pasting GitHub Notebook URL into NBViewer](/assets/images/nbviewer.png)

Opening this will display your notebook:

![Notebook Open in NBViewer](/assets/images/nbviewer-open.png)

Then you can use your browser to print to a PDF, which can be submitted to Gradescope.