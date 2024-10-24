FROM ruby:2.6-slim

WORKDIR /srv/slate

EXPOSE 80

COPY Gemfile .
COPY Gemfile.lock .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        nodejs \
    && gem install bundler -v 2.4.22 \
    && bundle install \
    && apt-get remove -y build-essential git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /srv/slate

RUN chmod +x /srv/slate/slate.sh

# RUN bundle exec middleman server -p 4567

ENTRYPOINT ["/srv/slate/slate.sh"]

#CMD ["bundle exec middleman server -p 4567"]

