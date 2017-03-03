# Digital Garage Docker image for the [Ghost](https://github.com/TryGhost/Ghost) blogging platform.
This image is designed specifically to support the deployment of Ghost via Docker and Kubernetes on Digital Garage. This image modifies the [official Ghost Docker image](https://registry.hub.docker.com/_/ghost/) so that it does not run as root.

# What is Ghost?
Ghost is a free and open source blogging platform written in JavaScript and distributed under the MIT License, designed to simplify the process of online publishing for individual bloggers as well as online publications.

The concept of the Ghost platform was first floated publicly in November 2012 in a blog post by project founder John O'Nolan, which generated enough response to justify coding a prototype version with collaborator Hannah Wolfe.

The first public version of Ghost, released October 2013, was financed by a successful Kickstarter campaign which achieved its initial funding goal of £25,000 in 11 hours and went on to raise a final total of £196,362 during the 29-day campaign.

```
wikipedia.org/wiki/Ghost_(blogging_platform)

```


![ghost](https://ghost.org/logo.svg)

## Why yet another container for Ghost?

The official container for Ghost runs as the root user. This is considered a
[bad practice](http://www.projectatomic.io/docs/docker-image-author-guidance/),
and Digital Garage does not support containers that run as root user. We have
modified this container to run as a supported user.

This container uses the official Ghost image as it's base, has a more "environment aware"
`config.js` file, and uses these environment variables to tune the config.

## Configuration

There are some environment variables that can be configured:

* `GHOST_URL`: the URL of your blog (e.g., `http://www.example.com`)
* `MAIL_SERVICE`: the type of smtp service (e.g., `Mailgun` or `Gmail`)
* `MAIL_ACCOUNT`: user account for smtp credential
* `MAIL_PWD`: user password for smtp credential
* `MAIL_FROM`: the email of the blog installation (e.g., `'"Webmaster" <webmaster@example.com>'`)
* `MYSQL_SERVICE_HOST`: name of mysql service
* `MYSQL_USER`: username for mysql connection
* `MYSQL_PASSWORD`: password for mysql connection
* `MYSQL_DATABASE`: database name

These can either be set on the Digital Garage command line interface for Openshift,
in the Docker command line directly, or stored in a file or Kubernetes template and
passed to the container at deployment:

## Quickstart via Docker and Kubernetes on Digital Garage

From the Digital Garage command line interface for Openshift:

```
# Use the public Docker Hub Digital Garage registry Ghost image to create an app.
# Generated artifacts will be labeled with app=ghost

$ oc new-app thedigitalgarage/ghost GHOST_URL=www.example.com MAIL_SERVICE=Gmail MAIL_ACCOUNT=some.account@gmail.com MAIL_PWD=XXXXXX -l app=ghost

# If you have not set up a domain name, your GHOST_URL should conform to:
# <app-name>-<project-name>.apps.thedigitalgarage.io in order to be accessible
# from an external client.

# Create a route and specify a hostname
$ oc expose service ghost --hostname=www.example.com

```

Then, access your Ghost blog via the browser at http://www.example.com. To configure
your Ghost blog, go to: http://www.example.com/ghost

## Quickstart via Docker

```
docker run --name some-ghost -d thedigitalgarage/ghost

```

This will start Ghost in development mode listening on the default port of 2368.

If you'd like to be able to access the instance from the host without the
contain's IP, standard port mappings can be used:

```
docker run --name some-ghost -p 8080:2368 -d thedigitalgarage/ghost
```

```
sudo cp ghost.example.env /etc/default/ghost
sudo vi /etc/default/ghost
docker run --name some-ghost --env-file /etc/default/ghost -p 8080:2368 -d thedigitalgarage/ghost

```

If you have just pulled the Docker image with `docker pull thedigitalgarage/ghost`, the example
environment file looks like this:

```
# Ghost environment
# Place in /etc/default/ghost

GHOST_URL=http://www.example.com
MAIL_FROM='"Webmaster" <webmaster@example.com>'
MAIL_HOST=mail.example.com
```

## Further reading

If you would like to read more about deploying and runnning this image on Digital Garage, you can find the tutorial on the Digital Garage Community site here:

* [Deploy Ghost with the Digital Garage Instant App](http://www.thedigitalgarage.io/community/ghost-deployment/): a tutorial on deploying the Ghost Blogging Platform via Docker and Kubernetes on the Digital Garage.
