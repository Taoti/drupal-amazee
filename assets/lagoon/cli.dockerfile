FROM uselagoon/node-20-builder:latest AS nodebuilder
ARG GITHUB_ACCESS
COPY . /app
RUN cd /app/web/themes/SITENAME && npm ci --no-ansi && npm run gulp --no-ansi

FROM uselagoon/php-8.2-cli-drupal:latest
ARG GITHUB_ACCESS
RUN apk add screen

COPY --from=nodebuilder /app /app

RUN if [ ! -z "$GITHUB_ACCESS" ]; then composer config --global github-oauth.github.com "$GITHUB_ACCESS"; echo "Github authentication token stored"; else echo "No github authentication stored"; fi
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress --optimize-autoloader --no-dev --no-ansi

RUN mkdir -p -v -m766 /app/web/sites/default/files/private
RUN chmod 444 /app/web/sites/default/settings.php
RUN chmod 644 /app/web/sites/default/
COPY . /app

COPY /lagoon/drush-override.yml /home/.drush/drush.yml

# Define where the Drupal Root is located
ENV WEBROOT=web
