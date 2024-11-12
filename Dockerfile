FROM debian:bullseye

ENV CANTALOUPE_VERSION=5.0.6

ENV TEMP_PATHNAME=/var/tmp/cantaloupe

EXPOSE 8182

VOLUME /imageroot

# Update packages and install tools
RUN apt-get update -qy && apt-get dist-upgrade -qy && \
    apt-get install -qy --no-install-recommends curl imagemagick \
    libopenjp2-tools ffmpeg unzip default-jre-headless && \
    apt-get -qqy autoremove && apt-get -qqy autoclean

# Run non privileged
RUN adduser --system cantaloupe

# Get and unpack Cantaloupe release archive
RUN curl --silent --fail -OL https://github.com/medusa-project/cantaloupe/releases/download/v$CANTALOUPE_VERSION/Cantaloupe-$CANTALOUPE_VERSION.zip \
    && unzip Cantaloupe-$CANTALOUPE_VERSION.zip \
    && ln -s cantaloupe-$CANTALOUPE_VERSION cantaloupe \
    && rm Cantaloupe-$CANTALOUPE_VERSION.zip \
    && mkdir -p /var/log/cantaloupe /var/cache/cantaloupe /var/tmp/cantaloupe \
    && chown -R cantaloupe /cantaloupe /var/log/cantaloupe /var/cache/cantaloupe /var/tmp/cantaloupe \
    && cp -rs /cantaloupe/deps/Linux-x86-64/* /usr/

# build libjpeg-turbo from source with Java
RUN apt-get install -qy cmake nasm default-jdk
RUN curl --silent --fail -OL https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/2.0.2.zip \
    && unzip 2.0.2.zip \
    && rm 2.0.2.zip

WORKDIR /tmp/libjpeg-turbo-2.0.2-build
RUN cmake -G"Unix Makefiles" -DWITH_JAVA=1 /libjpeg-turbo-2.0.2 \
    && make

# install libjpeg-turbo library files
RUN mkdir -p /opt/libjpeg-turbo/lib && \
    mv /tmp/libjpeg-turbo-2.0.2-build/*.so* /opt/libjpeg-turbo/lib/

# clean up libjpeg-turbo build artifacts
RUN apt-get remove -qy cmake nasm default-jdk && \
    rm -rf /tmp/libjpeg-turbo-2.0.2-build && \
    rm -rf /libjpeg-turbo-2.0.2

USER cantaloupe

CMD ["sh", "-c", "java $JVM_OPTS -Dcantaloupe.config=/cantaloupe/cantaloupe.properties.sample -jar /cantaloupe/cantaloupe-$CANTALOUPE_VERSION.jar"]
