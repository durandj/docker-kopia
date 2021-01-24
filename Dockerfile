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

RUN set -o errexit -o xtrace \
    && apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
        apt-transport-https \
        curl \
        gnupg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
        google-cloud-sdk \
    && rm --recursive --force /var/lib/apt/lists/*

CMD [ "kopia" ]
