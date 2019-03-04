# base image elixer to start with
FROM elixir:1.4.0

# install hex package manager
RUN mix local.hex --force

# install the latest phoenix 
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.0.ez --force

# install node
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

# create app folder
RUN mkdir /app
COPY . /app
WORKDIR /app

# install dependencies
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile

# install node dependencies
#RUN npm install
#RUN node node_modules/brunch/bin/brunch build

# run phoenix in *dev* mode on port 4000
CMD mix phoenix.server