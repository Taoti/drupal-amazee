FROM uselagoon/node-14-builder:latest as nodebuilder
COPY . /app
RUN cd /app/web/themes/SITENAME && npm install --no-ansi && npx gulp --no-ansi

FROM uselagoon/php-7.4-cli-drupal:latest
COPY --from=nodebuilder /app /app
RUN COMPOSER_MEMORY_LIMIT=-1 composer global remove hirak/prestissimo
RUN COMPOSER_MEMORY_LIMIT=-1 composer self-update --2
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress --optimize-autoloader --no-dev --no-ansi
RUN mkdir -p -v -m766 /app/web/sites/default/files/private
RUN chmod 444 /app/web/sites/default/settings.php
RUN chmod 644 /app/web/sites/default/
COPY . /app

COPY /lagoon/drush-override.yml /home/.drush/drush.yml

# Define where the Drupal Root is located
ENV WEBROOT=web
