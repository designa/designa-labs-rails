# syntax=docker/dockerfile:1
FROM ruby:2.7.2
LABEL maintainer "João Mateus Scarpa <joao.scarpa@gmail.com>"

EXPOSE 3000
WORKDIR /myapp
ENV TZ=Etc/UTC

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install -y nodejs postgresql-client yarn

ENV LANG C.UTF-8

RUN gem update --system && gem install bundler

# Add a script to be executed every time the container starts.
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
RUN chmod +x /entrypoint.sh

# Application dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]