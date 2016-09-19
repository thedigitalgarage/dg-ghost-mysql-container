FROM ghost

MAINTAINER David, david.dimas333@gmail.com

# Add in better default config
ADD config.example.js config.example.js

# Add a few themes
COPY themes/bootstraptheme    content/themes/bootstraptheme
COPY themes/ghostium          content/themes/ghostium
COPY themes/ghostScroll       content/themes/ghostScroll
COPY themes/mapache-godofredo content/themes/mapache-godofredo
COPY themes/perfetta          content/themes/perfetta
COPY themes/portfolio         content/themes/portfolio
COPY themes/saga              content/themes/saga
COPY themes/webkid            content/themes/webkid

# Fix ownership in src
RUN chown -R user $GHOST_SOURCE/content

# Install GIT
RUN apt-get update && apt-get install -y git

# Default environment variables
ENV NODE_ENV production
#ENV GHOST_URL http://my-ghost-blog.com

# Port 2368 for ghost server
EXPOSE 2368