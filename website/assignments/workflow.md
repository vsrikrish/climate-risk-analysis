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

### Typesetting Math

You can typeset math using LaTeX syntax. If LaTeX is output from a Julia block, this will also be rendered appropriately.
