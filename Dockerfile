FROM docker.io/node:latest as redoc

RUN npm i -g redoc-cli

WORKDIR /build
ADD . .
RUN mkdir -p \
    /output \
    /output/bpl \
    /output/portal \
    /output/merchant \
    /output/merchant/async \
    /output/extras \
    /output/webhook \
    /output/wallet

# Webhook
#RUN npx @redocly/cli build-docs webhook/webhook.yaml --template webhook/template.hbs --output /output/webhook/webhook.html
RUN mv webhook/webhook.yaml /output/webhook/webhook.yaml
RUN mv webhook/webhook.html /output/webhook/webhook.html

RUN mv extras/appendix.html /output/extras/appendix.html
RUN mv extras/changelog.html /output/extras/changelog.html
RUN mv extras/givex.html /output/extras/givex.html
RUN mv wallet/2.0.yaml /output/wallet/2.0.yaml
RUN mv wallet/api.html /output/wallet/api.html

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
RUN sed -i 's/js\//\/merchant\/async\/js\//g' /output/merchant/async/index.html
RUN sed -i 's/css\//\/merchant\/async\/css\//g' /output/merchant/async/index.html


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
