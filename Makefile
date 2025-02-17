server:
	hugo server

css:
	sass ./assets/styles/style.scss ./static/css/styles.css --no-source-map 

dev:
	open http://localhost:1313 && hugo server

build:
	hugo -d build -b https://lucianonooijen.com --minify --gc
