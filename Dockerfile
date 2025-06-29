FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs yarn libidn11-dev

# Set working directory
WORKDIR /app

# Copy app files
COPY . .

# Install gems and assets
RUN bundle install
RUN yarn install
RUN bundle exec rake assets:precompile

# Set environment variables
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Run database migration (optional here, can be moved to Render deploy hook)
RUN bundle exec rake db:migrate

# Start the server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
