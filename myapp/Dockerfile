FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /home/myapp
ADD Gemfile /home/myapp/Gemfile
ADD Gemfile.lock /home/myapp/Gemfile.lock
RUN bundle install
ADD . /home/myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
