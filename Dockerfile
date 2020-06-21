FROM debian
COPY ./app /app
RUN chmod a+x /app
ENTRYPOINT /app/in-cluster-client

