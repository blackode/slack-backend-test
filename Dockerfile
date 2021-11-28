#Build Stage
FROM bitwalker/alpine-elixir:latest as build

#Copy the source folder into the Docker image
COPY . .

#Install dependencies and build Release
RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    mix local.rebar --force && \
    mix deps.get && \
    mix release

#Deployment Stage
FROM pentacent/alpine-erlang-base:latest

#Set environment variables and expose port
EXPOSE 4000
ENV REPLACE_OS_VARS=true \
    PORT=4000

COPY releases .

#Change user
USER default

#Set default entrypoint and command
ENTRYPOINT ["./_build/dev/res/vhs/bin/vhs"]
CMD ["start"]

