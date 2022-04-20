FROM ruby:2.7.2

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /desafio-ninja
COPY Gemfile* ./
RUN gem install bundler
RUN bundle install
COPY . .

EXPOSE 3000