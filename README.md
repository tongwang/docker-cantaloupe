# Cantaloupe Docker Image

This is a fork of [MIT Libraries Cantaloupe Docker Container](https://github.com/MITLibraries/docker-cantaloupe)


## Usage

Run the container:

    docker run -d -p 8182:8182 -v /path/to/images:/home/myself/images tongwang/cantaloupe

To test, go to the URL http://localhost:8182/iiif/2/some.tif/full/pct:10/0/default.jpg, where some.tif is the image identifier. Image identifier is the relative path to the image and has to be percent encoded.

## Configuration

This Docker image uses the bundled sample configuration file, named `cantaloupe.properties.sample`. As the result, images are served from the file system at `/home/myself/images/` within the container. You can override the configurations by setting the environment variables. Key names in the environment are uppercased versions of "ordinary" configuration key names, with all non-alphanumerics replaced with underscores. For example, use `FILESYSTEMSOURCE_BASICLOOKUPSTRATEGY_PATH_PREFIX` environemnt variable to override `FilesystemSource.BasicLookupStrategy.path_prefix = /home/myself/images/` in the default configuration:

    docker run -d -p 8182:8182 -v /path/to/images:/home/images --env FILESYSTEMSOURCE_BASICLOOKUPSTRATEGY_PATH_PREFIX=/home/images/ tongwang/cantaloupe

