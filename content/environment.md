+++
title = "Development environment"
slug = "environment"
+++

_Note: this page reflects my personal configuration, as my work requires me to work on Windows._

#### Development environment

I often get questions about what my local development environment looks like and how everything is configured. For this reason, I have summarised everything on this page.

###### Operating system

For the majority of the time I use [Arch Linux](https://www.archlinux.org/), or Mac OS. I would prefer to do everything within Arch Linux, but unfortunately this is not feasible because I regularly have to compile iOS apps, which require Mac OS.

Recently, I started experimenting with using FreeBSD instead of Linux-based distro's. I don't have a lot of time to explore here, but I am planning to port my dotfiles to BSD in the near future.

##### Arch config

Within Arch Linux I use [dwm](https://dwm.suckless.org/) as window manager, [Ranger](https://github.com/ranger/ranger) as file manager and
[ZSH with Oh My ZSH](https://ohmyz.sh/) within [ST (Simple Terminal)](https://st.suckless.org/) as terminal.

##### Code Editors

I use two different code editors: [NeoVim](https://github.com/neovim/neovim) (a better and backwards-compatible fork from [Vim](https://www.vim.org/)) and [Visual Studio Code](https://github.com/Microsoft/vscode) (abbreviated: VS Code).

I prefer to work with NeoVim, but for many projects I still use VS Code because it offers more [IDE functionalities](https://en.wikipedia.org/wiki/Integrated_development_environment), which allows me to be more productive when working in mid-size codebases.

In addition, I regularly use [IntelliJ IDEA](https://www.jetbrains.com/idea/), because for large-scale projects code editors like (Neo)Vim and VS Code unfortunately can't provide enough code intelligence support to work effectively.

Within both my code editors and my terminal I use the Monokai colors, because I experience them as very clear and pleasant.

##### Dot files (config files)

My "[dotfiles](https://www.quora.com/What-are-dotfiles)" can be found in [my dotfiles repository](https://github.com/lucianonooijen/dotfiles) on GitHub.

Because setting up Arch Linux can be a fairly labor-intensive job, and I like to automate things, I automated this process using [Luke Smith](https://lukesmith.xyz)'s scripts. These "bootstrapping scripts" can be found in [the LARBS repository](https://github.com/lucianonooijen/LARBS) on my GitHub profile.

Feel free to use and modify my dot files for your own use!

##### Any questions or need help?

I'm very passionate about how I've configured everything, and I'm happy to help others. If you have any questions, [email me](mailto:luciano@lucianonooijen.com)!
