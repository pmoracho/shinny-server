FROM rocker/shiny-verse:4.1.1

# Install system requirements for index.R as needed
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    git-core \
    libssl-dev \
    libcurl4-gnutls-dev \
    curl \
    libsodium-dev \
    libxml2-dev \
    libicu-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV _R_SHLIB_STRIP_=true
COPY Rprofile.site /etc/R

RUN install2.r --error --skipinstalled tm
RUN install2.r --error --skipinstalled memoise
RUN install2.r --error --skipinstalled wordcloud

COPY ./apps/ /srv/shiny-server/

USER shiny

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]