+++
title = "Skills and Expertise"
slug = "expertise"
+++

In the past ten years of programming, I have dealt with an enormous amount of programming languages and frameworks, from plain C to Ruby on Rails and from Java 6 to Python Django. As a result, I have figured out which languages and frameworks suit me best, and how I can achieve the best results to best meet the needs of the end user.

In recent years I have specialised in a few stacks, as can be read below. Although of course I have my preferences, I will always choose _the best tool for the job_, regardless of my preference.

Unless the project requires otherwise, I program according to Bytecode's Coding Standards. The Coding Standards can be found [here](https://github.com/BytecodeBV/Coding-Standards).

Since about a year, I fill the role of Technical Lead at Bytecode. This means that I only spend a small part of my time writing code myself, because I am more involved with software architecture, the design of the code at a higher level, performing code reviews and guiding the developers at Bytecode. Of course, there are still plenty of times when I do write code myself.

## Working method

*Technologies I use to deliver elegant, efficient, readable, understandable and maintainable code that adds value to a company and/or product.*

* "Always choose the best tool for the job"
* Cloud and application structure using [The Twelve-Factor App](https://12factor.net/)
* Software architecture through the principles of [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), [DDD](https://en.wikipedia.org/wiki/Domain-driven_design) and [Layered Architecture](https://en.wikipedia.org/wiki/Multitier_architecture).
* Prevention of [technical debt](https://en.wikipedia.org/wiki/Technical_debt), short term and long term
* Everything (even [infrastructure as code](https://en.wikipedia.org/wiki/Infrastructure_as_code)) in version control (Git) via [GitFlow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).
* Project management via SCRUM/Agile principle, without unnecessary meetings
* Bringing together Development, Security and Operations through [DevSecOps](https://www.devsecops.org/) and [secure by design](https://en.wikipedia.org/wiki/Secure_by_design).
* Prioritise via the [MoSCoW method](https://en.wikipedia.org/wiki/MoSCoW_method) and the [80 / 20 rule](https://en.wikipedia.org/wiki/Pareto_principle).
* Development on the basis of Test-Driven Development (TDD)
* Functional programming where possible
* [SOLID](https://en.wikipedia.org/wiki/SOLID), [KISS](https://en.wikipedia.org/wiki/KISS_principle) and [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) code
* Versioning according to [Semantic Versioning](https://semver.org/)
* Use of [Design Patterns](https://en.wikipedia.org/wiki/Software_design_pattern) to improve readability, performance and maintainability
* Use of free (open-source) software where possible


## Technology used

The techniques I'm currently working with the most are in **bold**.

### Web development

##### Backend/server

* **Golang** (Gin, Echo)
* Typescript (NodeJS, Express, Deno)
* Kotlin/Java (Spring Boot)
* Elixir (Phoenix, OTP)

With mostly **PostgreSQL** as the underlying database._

##### Front-end

* **React+Typescript** (icm. Redux, Styled-Components, NextJS)
* Elm

### Mobile development

* **React Native** (Expo)
* Progressive Web Apps
* Flutter

### Site Reliability Engineering and DevOps

* **Linux** (Arch, Ubuntu, CentOS)
* **Infrastructure and provisioning** (Ansible, Terraform, Shell)
* **Systems integration**
* CI/CD(GitLab)
* Docker and Kubernetes
* Cloud (DigitalOcean, AWS)
* Nginx

### Domain specific

* **Compilers, parsers, DSLs**: Golang, Rust, Haskell
* Systems programming: Rust, Golang, C
* Data science: SQL, Python, Scala, Javascript, R

<br>
<hr>
<br>

#### Personal development

As a developer, it is important to always continue to learn and to make sure you keep up with the technological advancements. For this reason I spend at least one day a week on self-education.

###### What I am currently working on:

* Improvements within the infrastructure of Bytecode, applying Site Reliability Engineering (SRE) principles.
* Building a central API system (REST and gRPC) for Bytecode, consisting of several microservices.
* Creating code generation tools for project scaffolding (e.g. React and Redux) with the objective of more uniform code bases within Bytecode and less manual boilerplate code.
* Building a tool within Bytecode to define and test import boundaries with a domain specific language.
* Conduct research to create fixed "stacks" for development at Bytecode, and better definition of guidelines.
* Self-education towards the foundations of Computer Science and Computational Science and Engineering.
* Reading The Art of Computer Programming, part 1 to 4A (Donald Knuth)

#### What I've been working on lately (most notably):

* Delving deeper into Go/Golang development for enterprise applications
* Specialisation towards software architecture/design and SRE
* Reading books related to productivity, management and soft-skills
* Reading books related to process/management with software development
* Reading Start With Why and similar books on startup branding and mission definition
* Delving deeper into compiler engineering and assembly language(s)
* Kubernetes in production

##### What I want to learn (most notably):

* Getting more acquainted with the purely functional programming languages Haskell and Elm
* Systems programming with Rust
* Embedded programming with C, C++ and/or Rust
* Become familiar with Erlang, OCaml, C++, Dart, F# and Smalltalk for research purposes
* Functional front-end web development with Elm, ReasonML and/or ClosureScript
* WebAssembly, icm. Rust, Go and/or C
* Artificial Intelligence and Neural Networks with Tensorflow

<br>
<hr>
<br>

#### Development environment

I often get questions about what my local development environment looks like and how everything is configured. For this reason, I have summarised everything on this page.

###### Operating system

For the majority of the time I use [Arch Linux](https://www.archlinux.org/), or Mac OS. I would prefer to do everything within Arch Linux, but unfortunately this is not feasible because I regularly have to compile iOS apps, which require Mac OS.

##### Arch config

Within Arch Linux I use [dwm](https://dwm.suckless.org/) as window manager, [Ranger](https://github.com/ranger/ranger) as file manager and
[ZSH with Oh My ZSH](https://ohmyz.sh/) within [ST (Simple Terminal)](https://st.suckless.org/) as terminal.

##### Code Editors

I use two different code editors: [NeoVim](https://github.com/neovim/neovim) (a better and backwards-compatible fork from [Vim](https://www.vim.org/)) and [Visual Studio Code](https://github.com/Microsoft/vscode) (abbreviated: VS Code).

I prefer to work with NeoVim, but for many projects I still use VS Code because it offers more [IDE functionalities](https://en.wikipedia.org/wiki/Integrated_development_environment), which allows me to be more productive when working in mid-size codebases.

In addition, I regularly use [IntelliJ IDEA](https://www.jetbrains.com/idea/), because for large-scale projects code editors like (Neo)Vim and VS Code unfortunately can't provide enough code intelligence support to work effectively.

Within both my code editors and my terminal I use the Monokai colors, because I experience them as very clear and pleasant.

##### Dot files (config files)

My "[dot files](https://www.quora.com/What-are-dotfiles)" can be found in [my dotfiles repository](https://github.com/lucianonooijen/dotfiles) on GitHub.

Because setting up Arch Linux can be a fairly labor-intensive job, and I like to automate things, I automated this process using [Luke Smith](https://lukesmith.xyz)'s scripts. These "bootstrapping scripts" can be found in [the LARBS repository](https://github.com/lucianonooijen/LARBS) on my GitHub profile.

Feel free to use and modify my dot files for your own use!

##### Any questions or need help?

I'm very passionate about how I've configured everything, and I'm happy to help others. If you have any questions, [mail me](mailto:luciano@bytecode.nl)!
