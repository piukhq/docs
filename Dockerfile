FROM docker.io/node:latest as redoc

RUN npm i -g redoc-cli

WORKDIR /build
ADD . .
RUN mkdir -p \
    /output \
    /output/apiv1 \
    /output/apiv2 \
    /output/bpl \
    /output/portal \
    /output/merchant \
    /output/merchant/async \
    /output/extras

# APIv1
RUN redoc-cli build apiv1/1.2.yaml --output /output/apiv1/1.2.html
RUN redoc-cli build apiv1/1.3.yaml --output /output/apiv1/1.3.html

# APIv2
RUN redoc-cli build apiv2/dev.yaml --output /output/apiv2/dev.html
RUN redoc-cli build apiv2/staging.yaml --output /output/apiv2/staging.html
RUN redoc-cli build apiv2/sandbox-retail.yaml --output /output/apiv2/sandbox-retail.html
RUN redoc-cli build apiv2/sandbox-banking.yaml --output /output/apiv2/sandbox-banking.html
RUN mv extras/appendix.html /output/extras/appendix.html
RUN mv extras/changelog.html /output/extras/changelog.html

# BPL
RUN redoc-cli build bpl/deploy.yaml --output /output/bpl/index.html

# Portal
RUN redoc-cli build portal/api.yaml --output /output/portal/index.html

# Retail Transaction API 
RUN redoc-cli build merchant/retail_transaction_api.yaml --output /output/merchant/retail_transaction_api.html

# Async API specifications
ARG PUPPETEER_SKIP_DOWNLOAD=true
RUN npm install -g @asyncapi/cli
RUN npm install -g @asyncapi/html-template

RUN asyncapi generate fromTemplate merchant/async/midas_internal.yaml @asyncapi/html-template -o /output/merchant/async


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
CMD ["docs", "serve"]
