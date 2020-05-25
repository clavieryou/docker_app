FROM ruby:2.6.5-alpine AS Builder

ARG RAILS_ROOT=/home/myapp
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="postgresql-dev yaml-dev zlib-dev nodejs yarn bash"
ARG RUBY_PACKAGES="tzdata"

# ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR ${RAILS_ROOT}

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

ADD Gemfile /home/myapp/Gemfile
ADD Gemfile.lock /home/myapp/Gemfile.lock

ADD entrypoint.sh /home/myapp/entrypoint.sh
# RUN bundle install -j4 --path= vendor/bundle
RUN bundle config --global frozen 1 \
    && bundle install -j4 --retry 3 --path=vendor/bundle \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf vendor/bundle/ruby/2.6.0/cache/*.gem \
    && find vendor/bundle/ruby/2.6.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/2.6.0/gems/ -name "*.o" -delete

ADD . /home/myapp

############### Build step done ###############

FROM ruby:2.6.5-alpine
ARG RAILS_ROOT=/home/myapp
ARG PACKAGES="tzdata postgresql-client nodejs bash"

# ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR $RAILS_ROOT
# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES


# Add a script to be executed every time the container starts.

COPY --from=Builder $RAILS_ROOT $RAILS_ROOT
RUN chmod a+x /home/myapp/entrypoint.sh

# Start the main process.
CMD /home/myapp/entrypoint.sh
