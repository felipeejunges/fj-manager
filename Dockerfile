# syntax=docker/dockerfile:1
FROM ruby:3.2.1
RUN apt-get update -qq && apt-get install -y \
    libffi-dev \
    libc-dev \ 
    libxml2-dev \
    libxslt-dev \
    libgcrypt-dev \
    nodejs \
    npm \
    openssl \
    python3 \
    tzdata \
    yarn
WORKDIR /newpay
COPY Gemfile /newpay/Gemfile
COPY Gemfile.lock /newpay/Gemfile.lock
COPY package.json /newpay
RUN npm install -g yarn
RUN bundle install
RUN yarn install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
