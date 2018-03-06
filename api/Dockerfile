FROM ruby:2.5

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --without test development

COPY . /usr/src/app

EXPOSE 3000

CMD rm -f /usr/src/app/tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'
