FROM ruby:3.2

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs curl && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn libidn11-dev

WORKDIR /app

COPY . .

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV DATABASE_URL=postgres://invalid

RUN bundle install
RUN yarn install
RUN bundle exec rake assets:precompile

RUN bundle exec rake db:migrate

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
