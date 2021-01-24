FROM debian:stable-slim

ARG KOPIA_VERSION

RUN set -o errexit -o xtrace \
    && apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
        ca-certificates \
        wget \
    && rm --recursive --force /var/lib/apt/lists/*

RUN set -o errexit -o xtrace -o nounset \
    && wget \
        --output-document kopia.deb \
        "https://github.com/kopia/kopia/releases/download/v${KOPIA_VERSION}/kopia_${KOPIA_VERSION}_linux_amd64.deb" \
    && dpkg --install kopia.deb \
    && rm kopia.deb

CMD [ "kopia" ]
