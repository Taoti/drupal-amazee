ARG CLI_IMAGE
FROM ${CLI_IMAGE} AS cli

FROM uselagoon/solr-8-drupal:latest
COPY --from=cli /app/config/solr-conf/ /solr-conf/conf

CMD solr-recreate drupal /solr-conf && solr-foreground
