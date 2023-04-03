FROM ruby:2.7-alpine AS base

ENV LD_LIBRARY_PATH /lib64

RUN apk add --no-cache tzdata bash less build-base nodejs yarn postgresql-dev postgresql-client \
      nano rsync git libc6-compat && \
    gem install bundler
WORKDIR /code

COPY Gemfile Gemfile.lock ./
RUN bundle install --retry=7

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
