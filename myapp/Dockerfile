FROM ruby:2.6.5-alpine AS Builder

ARG RAILS_ROOT=/home/app
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="postgresql-dev yaml-dev zlib-dev"
ARG RUBY_PACKAGES="tzdata"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="${RAILS_ROOT}/.bundle"

WORKDIR ${RAILS_ROOT}

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache ${BUILD_PACKAGES} ${DEV_PACKAGES} \
       ${RUBY_PACKAGES}

ADD Gemfile* ${RAILS_ROOT}/
RUN bundle config --global frozen 1 \ 
    && bundle install --without development:test:assets -j4 --retry 3 --path=vendor/bundle \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf vendor/bundle/ruby/2.6.0/cache/*.gem \
    && find vendor/bundle/ruby/2.6.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/2.6.0/gems/ -name "*.o" -delete

COPY . ${RAILS_ROOT}
RUN rm -rf node_modules tmp/cache app/assets vendor/assets spec

############### Build step done ###############

FROM ruby:2.6.5-alpine 

ARG RAILS_ROOT=/home/app
ARG PACKAGES="tzdata postgresql-client nodejs bash"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="${RAILS_ROOT}/.bundle"

WORKDIR ${RAILS_ROOT}

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES
COPY --from=Builder $RAILS_ROOT $RAILS_ROOT
ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

