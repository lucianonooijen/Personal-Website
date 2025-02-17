+++
date = "2025-02-13"
title = "Easy help command for Makefiles"
slug = "help-makefile"
tags = ["QOL"]
categories = ["Tools"]
[params]
  metadescription = 'Adding a help command to your Makefile'
  metakeywords = 'makefile, help command'
+++

I love Makefiles, they are my prefered way to manage builds. Not just for C or C++, I also use it for Golang for example. To me, it is the best way to manage build commands in a single place.

As I love CLI tools in general, and working with them, the `--help` flag is often a great help, but Make does not offer this out of the box, and navigating complex Makefiles can be challenging.

I can't remember where or when, but a few years ago, I found a snippet somewhere of a Makefile command that adds a coloured text output of all Makefile commands. Using it is as simple as making the following your first Makefile command:

```Makefile
.PHONY: help
help: ## Shows all commands
	@echo 'All Makefile commands:'
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
```

After adding this, you can simply add comments after your other Makefile commands with two `#` characters, like this:

```Makefile
.PHONY: dev
dev: CFLAGS = $(CFLAGS_DEV) ## Development build for /src and /example
dev: clean $(LIB) $(EXAMPLE)
```

This will now be automatically generate help output when running `make help`, or when you have defined this as your first Make command, with simply `make`

![make help output](/img/0005-1.jpg)
