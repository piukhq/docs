FROM docker.io/node:latest as redoc

RUN npm i -g redoc-cli

WORKDIR /build
ADD . .
RUN mkdir -p \
    /output \
    /output/apiv1 \
    /output/apiv2 \
    /output/bpl \
    /output/portal

# APIv1
RUN redoc-cli build apiv1/1.2.yaml --output /output/apiv1/1.2.html
RUN redoc-cli build apiv1/1.3.yaml --output /output/apiv1/1.3.html

# APIv2
RUN redoc-cli build apiv2/dev.yaml --output /output/apiv2/dev.html
RUN redoc-cli build apiv2/staging.yaml --output /output/apiv2/staging.html
RUN redoc-cli build apiv2/sandbox-retail.yaml --output /output/apiv2/sandbox-retail.html
RUN redoc-cli build apiv2/sandbox-banking.yaml --output /output/apiv2/sandbox-banking.html
RUN mv apiv2/appendix.html /output/apiv2/appendix.html
RUN mv apiv2/changelog.html /output/apiv2/changelog.html

# BPL
RUN redoc-cli build bpl/deploy.yaml --output /output/bpl/index.html

# Portal
RUN redoc-cli build portal/api.yaml --output /output/portal/index.html


###################################################
### DevOps owned, do not modify below this line ###
###################################################
FROM ghcr.io/binkhq/python:3.11-poetry as poetry
WORKDIR /src
ADD . .
RUN poetry build

FROM ghcr.io/binkhq/python:3.11
WORKDIR /app
COPY --from=poetry /src/dist/*whl /src/app/config.toml ./
RUN pip install *.whl && rm *.whl
COPY --from=redoc /output .
RUN ["docs", "serve"]
