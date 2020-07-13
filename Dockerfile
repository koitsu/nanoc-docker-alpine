FROM ruby:2.7.1-alpine3.12

# NOTE: All the gem install calls are necessary because by default
# nanoc does not install a bunch of plugins (gems).   The :plugins
# group in the main nanoc Gemfile defines a list:
# https://github.com/nanoc/nanoc/blob/main/Gemfile
# I've included the ones I find useful.  If you want others added,
# just ask via an Issue on GitHub or by filing a PR.

RUN set -e -x \
&& addgroup -g 1000 -S nanoc \
&& adduser -u 1000 -D -S -G nanoc nanoc \
&& apk update \
&& apk add bash curl git wget \
&& apk add --virtual build-deps build-base ruby-dev \
&& gem install nanoc -v 4.11.18 \
&& gem install adsf adsf-live kramdown nokogiri rouge sass \
&& apk del --purge build-deps \
&& rm -fr /var/cache/apk/*

USER nanoc:nanoc
WORKDIR /app
EXPOSE 3000
EXPOSE 35729
CMD ["nanoc"]
