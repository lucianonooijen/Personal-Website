.PHONY: help
help: ## Shows all commands
	@echo 'All Makefile commands:'
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: server
server: ## Start development server
	hugo server

.PHONY: css
css: ## Build css file
	npm run build:css

.PHONY: csswatch
csswatch: ## Run listener for scss changes, compiling on the fly for development
	npm run dev:css

.PHONY: fmt
fmt: ## Format project using Prettier
	npm run fmt

.PHONY: dev
dev: ## Opens browser and starts server
	open http://localhost:1313 && hugo server

.PHONY: build
build: css fmt ## Builds production website for lucianonooijen.com
	hugo -d build -b https://lucianonooijen.com --minify --gc
