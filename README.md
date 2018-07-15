# Luciano Nooijen personal website

Luciano Nooijen's personal website built in [Hugo](https://gohugo.io).

## Development

For development, run `hugo server -D -w`. The development environment is now accessable on `localhost:1313`.

## Production

As Hugo is a static website builder, you can just host the website on any hosting service. To build the static files, run `rm -rf public && hugo -s`.

Now upload the contents of the `public` folder to the webhost and you're done.

### License

MIT