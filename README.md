# Luciano Nooijen personal website

[![Netlify Status](https://api.netlify.com/api/v1/badges/1b597d94-711a-4772-8ca2-b95a39733a18/deploy-status)](https://app.netlify.com/sites/lucianonooijen/deploys)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Flucianonooijen%2FPersonal-Website.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Flucianonooijen%2FPersonal-Website?ref=badge_shield)

Luciano Nooijen's personal website built in [Hugo](https://gohugo.io).

## Development

For development, run `hugo server`. The development environment is now accessable on `localhost:1313`.

You can also just use `open http://localhost:1313 && hugo server`, but not all systems support this.

## Production

As Hugo is a static website builder, you can just host the website on any hosting service. To build the static files, run `rm -rf build && hugo -d build -b [url]`.

I run `hugo -d build -b https://lucianonooijen.com`.

Now upload the contents of the `build` folder to the webhost and you're done.

## Make

The `make` command can also be used:

| Command | Functionality |
| ------- | ------------- |
| `make server` | Runs hugo server |
| `make dev` | Runs hugo server and opens `localhost:1313` in browser |
| `make build` | Runs hugo build command as explained under the "production" header |

### License

MIT

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Flucianonooijen%2FPersonal-Website.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Flucianonooijen%2FPersonal-Website?ref=badge_large)