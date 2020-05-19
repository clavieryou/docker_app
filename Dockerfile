FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /home/webapp
ADD /myapp/Gemfile Gemfile
ADD /myapp/Gemfile.lock Gemfile.lock
RUN bundle install
ADD /myapp /home/webapp

# Add a script to be executed every time the container starts.
COPY /myapp/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
