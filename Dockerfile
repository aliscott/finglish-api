FROM ruby:2.3

EXPOSE 9292

RUN mkdir -p /app
RUN chmod -R g+w /var/run /var/log

WORKDIR /app
COPY . /app
RUN gem install bundler && bundle install

USER 1001

CMD puma config.ru -C puma.rb
