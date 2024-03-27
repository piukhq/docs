FROM docker.io/node:latest as redoc

RUN npm i -g redoc-cli

WORKDIR /build
ADD . .
RUN mkdir -p \
    /output \
    /output/bpl \
    /output/portal \
    /output/merchant \
    /output/events/loyalty_card_management/async \
    /output/events/reporting_mi/async \
    /output/events/transaction_processing\/async \
    /output/events/bpl_events/async \
    /output/events/user_and_wallet/async \
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
RUN mv events/index.html /output/events/index.html

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
RUN npm install -g @asyncapi/parser@3.0.5


RUN asyncapi generate fromTemplate events/loyalty_card_management/asyncapi.yaml @asyncapi/html-template -o /output/events/loyalty_card_management/async
RUN sed -i 's/js\//\/events\/loyalty_card_management\/async\/js\//g' /output/events/loyalty_card_management/async/index.html
RUN sed -i 's/css\//\/events\/loyalty_card_management\/async\/css\//g' /output/events/loyalty_card_management/async/index.html

RUN asyncapi generate fromTemplate events/user_and_wallet/asyncapi.yaml @asyncapi/html-template -o /output/events/user_and_wallet/async
RUN sed -i 's/js\//\/events\/user_and_wallet\/async\/js\//g' /output/events/user_and_wallet/async/index.html
RUN sed -i 's/css\//\/events\/user_and_wallet\/async\/css\//g' /output/events/user_and_wallet/async/index.html

RUN asyncapi generate fromTemplate events/transaction_processing/asyncapi.yaml @asyncapi/html-template -o /output/events/transaction_processing/async
RUN sed -i 's/js\//\/events\/transaction_processing\/async\/js\//g' /output/events/transaction_processing/async/index.html
RUN sed -i 's/css\//\/events\/transaction_processing\/async\/css\//g' /output/events/transaction_processing/async/index.html

RUN asyncapi generate fromTemplate events/reporting_mi/asyncapi.yaml @asyncapi/html-template -o /output/events/reporting_mi/async
RUN sed -i 's/js\//\/events\/reporting_mi\/async\/js\//g' /output/events/reporting_mi/async/index.html
RUN sed -i 's/css\//\/events\/reporting_mi\/async\/css\//g' /output/events/reporting_mi/async/index.html

RUN asyncapi generate fromTemplate events/bpl_events/asyncapi.yaml @asyncapi/html-template -o /output/events/bpl_events/async
RUN sed -i 's/js\//\/events\/bpl_events\/async\/js\//g' /output/events/bpl_events/async/index.html
RUN sed -i 's/css\//\/events\/bpl_events\/async\/css\//g' /output/events/bpl_events/async/index.html

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
