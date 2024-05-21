FROM kartoza/mapproxy:latest

ENV MAPNIK_VERSION v3.1.0

ENV BUILD_DEPENDENCIES="build-essential \
    ca-certificates \
    git \
    icu-devtools \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-regex-dev \
    libboost-thread-dev \
    libboost-system-dev \
    libcairo-dev \
    libfreetype6-dev \
    libgdal-dev \
    libharfbuzz-dev \
    libicu-dev \
    libjpeg-dev \
    libpq-dev  \
    libproj-dev \
    librasterlite2-dev \
    libsqlite3-dev \
    libtiff-dev \
    libwebp-dev"

ENV DEPENDENCIES="libboost-filesystem1.74.0 \
    libboost-program-options1.74.0 \
    libboost-regex1.74.0 \
    libboost-thread1.74.0 \
    libboost-system1.74.0 \
    libcairo2 \
    libfreetype6 \
    libgdal28 \
    libharfbuzz-gobject0 \
    libharfbuzz-icu0 \
    libharfbuzz0b \
    libicu67 \
    libjpeg62-turbo \
    libpq5 \
    libproj19 \
    librasterlite2-1 \
    libsqlite3-0 \
    libtiff5 \
    libtiffxx5 \
    libwebp6  \
    libwebpdemux2 \
    libwebpmux3 \
    python"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        $BUILD_DEPENDENCIES $DEPENDENCIES \
    && git clone https://github.com/mapnik/mapnik.git \
    && cd mapnik \
    && git checkout $MAPNIK_VERSION \
    && git submodule update --init \
    && python scons/scons.py INPUT_PLUGINS='all' \
    && make \
    && make install \
    && cd - \
    && rm -r mapnik \
    && apt-get autoremove -y --purge $BUILD_DEPENDENCIES \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/local/lib/mapnik /usr/lib/mapnik
