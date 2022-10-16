FROM ruby:3.1.2-slim

# Dependencies
RUN apt-get update -qq \
   && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    git \
    curl \
    nodejs \
    yarn \
    npm \
    && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN mkdir /app

WORKDIR /app

COPY Gemfile.lock .
COPY Gemfile .
COPY .ruby-version .
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN bundle install -j4

COPY . /app

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
