# interpolator replaces templated variables in docker-compose.yaml
FROM alpine:3.9

COPY --from=dockertemplate/interpolator:v0.1.4 /interpolator /interpolator

WORKDIR /assets
COPY assets/ .

WORKDIR /templates
COPY templates/ .

CMD cp -r /assets/* /project && \
    /interpolator -source /templates -destination /project