# Luciano Nooijen personal website

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

Luciano Nooijen's personal website built with [Hugo](https://gohugo.io).

## Development

Run `npm install` to install development dependencies.

For development, run `hugo server`. The development environment is now accessable on `localhost:1313`.

You can also just use `open http://localhost:1313 && hugo server`, but not all systems support this.

## Production

As Hugo is a static website builder, you can just host the website on any hosting service. To build the static files, run `rm -rf build && hugo -d build -b [url]`. I run `hugo -d build -b https://lucianonooijen.com`.

Now upload the contents of the `build` folder to the webhost and you're done.

When using `make build` it also builds the css and runs the formatter before building.

## Make

The `make` command can also be used:

| Command       | Functionality                                                      |
| ------------- | ------------------------------------------------------------------ |
| `make server` | Runs hugo server                                                   |
| `make css`    | Converts scss to css                                               |
| `make dev`    | Runs hugo server and opens `localhost:1313` in browser             |
| `make build`  | Runs hugo build command as explained under the "production" header |
| `make fmt`    | Runs Prettier formatting for all files (should be in PATH)         |

### License

- [AGPL3.0](https://www.gnu.org/licenses/agpl-3.0) for all website code
- [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) for text content
