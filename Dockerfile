FROM debian:bookworm-slim

LABEL "Author"="John Bayly"

RUN apt-get update \
  && apt-get install -y curl \
  unzip \
  git

RUN mkdir -p /app \
  && mkdir -p /fontello/ \
  && git clone https://github.com/tipstrade/docker-fontello-tools.git /src \
  && cp /src/app.sh /app/app.sh \
  && chmod +x /app/app.sh

ENTRYPOINT [ "/app/app.sh" ]
CMD [ "start" ]
