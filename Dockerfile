FROM fpco/stack-build:latest as dependencies

RUN mkdir /opt/build
WORKDIR /opt/build

RUN chown -Rv _apt:root /opt/build/
RUN chmod -Rv 700 /opt/build/

# GHC dynamically links its compilation targets to lib gmp
RUN apt-get update \
  && apt-get download libgmp10
RUN mv libgmp*.deb libgmp.deb

RUN chown -Rv root /opt/build/
RUN chmod -Rv 706 /opt/build/

# Docker build should not use cached layer if any of these is modified
COPY stack.yaml package.yaml stack.yaml.lock /opt/build/
RUN stack build --system-ghc --dependencies-only

# ------------------------------------------------------------------

FROM fpco/stack-build:latest as build

COPY --from=dependencies /root/.stack /root/.stack
COPY . /opt/build/

WORKDIR /opt/build

RUN stack build --system-ghc

RUN mv "$(stack path --local-install-root --system-ghc)/bin" /opt/build/bin

# -------------------------------------------------------------------------------------------

FROM ubuntu:latest as app

RUN mkdir -p /opt/app
WORKDIR /opt/app

RUN mkdir /opt/app/assets
COPY ./assets /opt/app/assets

# Install lib gmp
COPY --from=dependencies /opt/build/libgmp.deb /tmp
RUN dpkg -i /tmp/libgmp.deb && rm /tmp/libgmp.deb

COPY --from=build /opt/build/bin .
EXPOSE 8080

CMD /opt/app/meme-page-exe
