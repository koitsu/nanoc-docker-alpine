# nanoc-docker-alpine

This is a repository containing a `Dockerfile` that can be used to build the
static site generator [Nanoc](https://github.com/nanoc/nanoc).

I haven't taken the time to figure out how to get this onto DockerHub.  Sorry.

## Details

* Nanoc version: 4.11.18 via RubyGems
* Base image: [ruby:2.7.1-alpine3.12](https://hub.docker.com/_/ruby)
* Container directory: `/app`
* Container UID/GID: `1000:1000`
* Container exposed ports:
  * 3000/tcp (nanoc / WEBrick)
  * 35729/tcp (rack-livereload WebSockets)
* Additional programs: `bash`, `curl`, `git`, `wget`
* Additional packages via RubyGems:
  * [adsf](https://rubygems.org/gems/adsf) latest
  * [adsf-live](https://rubygems.org/gems/adsf-live) latest
  * [kramdown](https://rubygems.org/gems/kramdown) latest
  * [nokogiri](https://rubygems.org/gems/kramdown) latest
  * [rouge](https://rubygems.org/gems/rouge) latest
  * [sass](https://rubygems.org/gems/sass) latest

If you'd like additional RubyGems packages added to the list, please file a
GitHub pull request, or open up a GitHub Issue and I'll happily add it.

The container should be run with non-root credentials (read: the container
should be run as your own UID/GID), due to use of a volume map.  This ensures
files created within the container will have your UID/GID on the host side.
**Docker containers using volume maps should not normally be run as root!**
I try my best to comply with many different "best practises" for Docker
when applicable:

* https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
* https://snyk.io/blog/10-docker-image-security-best-practices/
* https://developers.redhat.com/blog/2016/02/24/10-things-to-avoid-in-docker-containers/

# Building

```
$ git clone https://github.com/koitsu/nanoc-docker-alpine.git
$ cd nanoc-docker-alpine
$ docker build --rm -t nanoc-docker-alpine:latest .
```

# Usage Examples

## Convenience Script

The below examples use two (2) simple wrapper scripts called `nanocdocker`
and `nanoc-view`, for convenience and to make the examples shorter in
width.  Be sure to to `chmod u+x` the scripts and place them somewhere in
your `$PATH`:

### `nanocdocker`

```bash
#!/bin/sh
exec docker run --rm -it \
  -u $(id -u):$(id -g) \
  -v $PWD:/app \
  nanoc-docker-alpine:latest $*
```

### `nanoc-view`

```bash
#!/bin/sh
exec docker run --rm -it \
  -u $(id -u):$(id -g) \
  -v $PWD:/app \
  -p 3000:3000 \
  -p 35729:35729 \
  nanoc-docker-alpine:latest nanoc view -L --host 0.0.0.0
```

## Common Usage

```
Window 1:
$ cd my-site
$ nanocdocker nanoc create-site blog
$ cd blog
$ nanocdocker nanoc compile

Window 2:
$ cd my-site/blog
$ nanoc-view
```
