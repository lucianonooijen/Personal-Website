server:
	hugo server

css:
	npm run build:css

fmt:
	npm run fmt

dev:
	open http://localhost:1313 && hugo server

build:
	hugo -d build -b https://lucianonooijen.com --minify --gc
