FROM ruby:3.2.2
ENV LANG C.UTF-8

# Install Dependencies
RUN apt-get update && apt-get install -y \
      apt-transport-https \
      default-libmysqlclient-dev \
      build-essential \
      curl \
      default-mysql-client \
      libjemalloc2 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


# Add LD_PRELOAD to override the default memory allocator with jemalloc
# https://github.com/jemalloc/jemalloc/issues/1328
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
# Install node.js (Use Maintenance LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get update && apt-get install -y nodejs && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install -y yarn && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN gem update bundler
ADD Gemfile ./
ADD Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3
RUN bundle clean --force

RUN mkdir /rails-app
WORKDIR /rails-app
