+++
date = "2025-02-24"
title = "Announcing Capsa, an Unreal Engine logging solution"
slug = "announcing-capsa"
tags = ["Capsa", "Tools", "Unreal Engine"]
categories = ["Tools", "Games"]
[params]
  metadescription = "Capsa makes Unreal Engine logging a lot better, especially for those working on multiplayer"
  metakeywords = 'capsa, unreal engine, logging'
+++

_tl;dr: Capsa makes Unreal Engine logging a lot better, especially for those working on multiplayer. Check it out [here](https://capsa.gg/blog/announcing-capsa)._

I'm very excited to share what I've been working on over the last few months by announcing the v0.1 release of Capsa.

## Introducing Capsa

_An open-source Unreal Engine logging solution._

Ever since I started working on multiplayer games, I was quite surprised how few tools were available for working effectively with Unreal Engine logs for multiplayer games. After working on various titles, Mark Jawdoszak and I started building a tool called Capsa to address this. We've made this fully open-source so it can be used by other teams facing similar challenges.

More in-depth reasons why we've built Capsa and licensing can be found in [this blog post on Capsa.gg](https://capsa.gg/blog/why-we-built-capsa/).

## About Capsa

Capsa makes this easy by automatically collecting logs and making them accessible in a structured, searchable, and shareable way.

Some of the features Capsa offers:

- Logs with syntax highlighting and sharable links
- Filter, search, and link logs
- Merged client-server logs
- Minimal setup, no game core or engine changes
- Cloud-native, so host anywhere
- Optimized for performance
- Open-source, web stack AGPL3.0 and UE plugin MIT
- Dark-mode support

Working on Capsa has been a blast and we've got tons of ideas of new features we want to add over the next few months.

To read the full announcement post, check out [Announcing Capsa](https://capsa.gg/blog/announcing-capsa).

## Building Capsa

Some notes on building Capsa and the tech we have used.

#### Extending Unreal Engine

We chose to extend Unreal Engine rather than replace functionality. We are hooking into `GLog` as an output device, so we can capture `UE_LOG` calls and we don't require game code changes with a new log system. We want to have a system that is easy to add to and easy to remove from games, and I think this is a great way to achieve that.

The received log lines are formatted according to our [Capsa log format](https://capsa.gg/docs/technical/protocol) so the server can parse it correctly. This way we don't change any default Unreal Engine log output, but we receive the correct format on the server

#### Golang server log parsing

The log is processed in O(1) complexity, reading one character at a time. A buffer is built with all line characters until encountering a `\n`. The line buffer is then used to extract metadata for that specific line. The metadata is stored in the database and the log chunks are stored in S3-compatible storage.

Due to the per-character algorithm for log chunk processing, it allows the server to be very performant with extracting the metadata. At the time of writing this, parsing a 100k line log chunk (which is much bigger than will be done in production) takes just around 60ms.

More details on log processing can be found on [Log processing](https://capsa.gg/docs/technical/log-processing).

#### Server-side merging and filtering

We had to make an important decision on doing log merging and filtering, whether we wanted to do this on the server or client. There are pros and cons for each, but we decided to do this server-side.

By doing this, we can re-use the existing log parsing code for incoming logs, get better performance, but it means that changing the filtering/merging settings requires reloading the full log from the server. We figured we needed server-side logic anyway, as large logs cannot be kept fully in the browser's memory, so at least for v0.1, all of the merging and filtering logic is handled server-side.

Because we store per-chunk metadata, we can ignore chunks that don't fit the filtering criteria as well, giving us a good performance boost. The benchmark for filtering lines from a 100.000-line chunk for streaming to a user (as is used for the admin panel) is around 70ms.

#### Golang server SQL

For handling database logic, I chose to go with sqlc and golang-migrate, as I have written in my [Golang SQL handling article](./best-golang-sql-handling). This has been a good decision so far, as I have full control over the SQL to optimize for performance. I have already done a few optimizations in the queries, which would not have been possible with ORMs.

#### JWT with private/public keys

Authentication is hand-rolled in the API server, so there is no reliance on external parties for this. JWTs are used for this. Instead of using a signing secret, a private/public keypair is used.

This allows the web panel to check the JWTs (stored as a cookie) if they are valid and have users reauthenticate if they are not.

All API requests are done from the browser directly to the API server to not unnecessarily increase server load for the web panel. Yet we still want to validate the JWTs on page load to make sure we don't perform API requests that will return in a `401` or `403` response.

#### Building Capsa cloud-native

Another concern when building Capsa was making it possible to deploy anywhere. This is why I have chosen to build the web stack with Golang and NextJS. Deploying these to any Linux or Windows system is very trivial. Both of the applications are available as Docker images and can be hosted anywhere by setting some environment variables.

#### Log processing web worker

The web panel uses a web worker to process incoming logs, to not block the main thread, which would make the website feel a lot slower due. This is achieved by writing a class to manage the web worker, which is then exposed in a React hook to work with the rest of the logic.

#### Runtime JSON validation

For the web panel, we have added runtime type validation by using Zod. The React code uses `useSWR` to call API endpoints as hooks. Instead of using API endpoints directly, we have added wrappers for requests, for example `const { trigger, isMutating } = useAddTitle();` to add a new game title. This hook internally calls the API endpoint with `useSWR`, validates the JSON it gets back with Zod, and sets an error if it's not valid.

By doing this, we can avoid runtime type exceptions.

## Continuing development

We have tons of ideas on how to improve or extend the current functionality or new features we can add. But before we add this, we want to make sure we are on the right path with Capsa.

Now v0.1 is released, we will be integrating this into a few Companion Group projects and gather feedback from there, as well as early-adopters. We will continue to fix bugs and work on existing and new features over time, to slowly work towards a v1.0 release.

For v1.0 we have a few feature ideas that would make Capsa even more powerful to improve the lives of developers working on Unreal Engine multiplayer games. We are working on a few proof-of-concepts for this, though these will take some time as we need to figure out details, as we don't want Capsa to take over game codebases, we want to keep Capsa non-intrusive.

## Want to become an early adopter?

If you are interested in becoming an early adopter, the details on getting started are in [Announcing Capsa](https://capsa.gg/blog/announcing-capsa). You can also reach out to me if you need any help, I'm more than happy to help you get started with Capsa.

All feedback - positive or negative - is very much welcome as well!
