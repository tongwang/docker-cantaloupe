# Cantaloupe Docker Image

This is a fork of [MIT Libraries Cantaloupe Docker Container](https://github.com/MITLibraries/docker-cantaloupe)


## Usage

Run the container:

    docker run -d -p 8182:8182 -v /path/to/images:/home/myself/images tongwang/cantaloupe

To test, go to the URL http://localhost:8182/iiif/2/some.tif/full/pct:10/0/default.jpg, where some.tif is the image identifier. Image identifier is the relative path to the image and has to be percent encoded.

Images are served from `/home/myself/images/` within the container.

