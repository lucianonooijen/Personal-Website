server:
	hugo # The development environment is now accessable on localhost:1313.

dev:
	open http://localhost:1313 && hugo server

build:
	hugo -d build -b https://lucianonooijen.com
