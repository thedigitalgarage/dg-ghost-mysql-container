# Digital Garage Docker image for Ghost using MySQL.
This image is designed specifically to support the deployment of Ghost via Docker and Kubernetes via the Digital Garage. This image is a bit more configurable than the [official Ghost Docker image](https://registry.hub.docker.com/_/ghost/).

# What is Ghost?
Ghost is a free and open source blogging platform written in JavaScript and distributed under the MIT License, designed to simplify the process of online publishing for individual bloggers as well as online publications.

The concept of the Ghost platform was first floated publicly in November 2012 in a blog post by project founder John O'Nolan, which generated enough response to justify coding a prototype version with collaborator Hannah Wolfe.

The first public version of Ghost, released October 2013, was financed by a successful Kickstarter campaign which achieved its initial funding goal of £25,000 in 11 hours and went on to raise a final total of £196,362 during the 29-day campaign.

```
wikipedia.org/wiki/Ghost_(blogging_platform)
```


![ghost]

[ghost]: ghost-logo.svg

## Why yet another container for Ghost?

The official container for Ghost is fine for running in development mode, but it has the wrong
permissions for running in production. That, and the config file doesn't have any easy way to tweak
it.

This container uses the official Ghost image as it's base, has a more "environment aware"
`config.js` file, and uses these environment variables to tune the config.

## Quickstart on via Docker

```
docker run --name some-ghost -d eddsuarez/ghost
```

This will start Ghost in development mode listening on the default port of 2368.

If you'd like to be able to access the instance from the host without the
contain's IP, standard port mappings can be used:

```
docker run --name some-ghost -p 8080:2368 -d eddsuarez/ghost
```

Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser.

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

These can either be set on the Docker command line directly, or stored in a file and passed on
the Docker command line:

```
sudo cp ghost.example.env /etc/default/ghost
sudo vi /etc/default/ghost
docker run --name some-ghost --env-file /etc/default/ghost -p 8080:2368 -d thedigitalgarage/dg-ghost
```

If you have just pulled the Docker image with `docker pull thedigitalgarage/dg-ghost`, the example
environment file looks like this:

```
# Ghost environment
# Place in /etc/default/ghost

GHOST_URL=http://www.example.com
MAIL_SERVICE=Gmail
MAIL_ACCOUNT=example@gmail.com
MAIL_PWD=example
MAIL_FROM=example@gmail.com
MYSQL_SERVICE_HOST=mysql
MYSQL_USER=ghost
MYSQL_PASSWORD=ghost
MYSQL_DATABASE=ghost

```

## Running in production

The official Ghost image places the blog content in `/var/lib/ghost` and exports it as a `VOLUME`.
This allows two main modes of operation:

### Content on host filesystem

In this mode, the Ghost blog content lives on the filesystem of the host with the `UID`:`GID` of
`1000`:`1000`. If this is acceptable, create a directory somewhere, and use the `-v` Docker command
line option to mount it:

```
sudo mkdir -p /var/lib/ghost
sudo chown 1000:1000 /var/lib/ghost
docker run --name some-ghost --env-file /etc/default/ghost -p 80:2368 -v /var/lib/ghost:/var/lib/ghost -d ptimof/ghost npm start --production
```

### Content in a data volume

This is the preferred mechanism to store the blog data. Please see the
[Docker documentation](https://docs.docker.com/userguide/dockervolumes/#backup-restore-or-migrate-data-volumes)
for backup, restore, and migration strategies.

```
docker create -v /var/lib/ghost --name some-ghost-content busybox
docker run --name some-ghost --env-file /etc/default/ghost -p 80:2368 --volumes-from some-ghost-content -d ptimof/ghost npm start --production
```

You should now be able to access this instance as `http://www.example.com` in a browser.

### Behind a reverse proxy

Of course, you should really be running Ghost behind a reverse proxy, and set things up to auto restart. For that,
a reasonable container would be:

```
docker create --name some-ghost -h ghost.example.com --env-file /etc/default/ghost -p 127.0.0.1:2368:2368 --volumes-from some-ghost-content --restart=on-failure:10 ptimof/ghost npm start --production
docker run some-ghost
```
## Further reading

If you would like to read more about deploying and runnning this image on Digital Garage, you can find the tutorial on the Digital Garage Community site here:

* [Deploy Ghost with the Digital Garage Instant App](http://www.thedigitalgarage.io/community/ghost-deployment/): a tutorial on deploying the Ghost Blogging Platform via Docker and Kubernetes on the Digital Garage.
