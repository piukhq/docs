FROM docker.io/node:latest as build

RUN npm i -g redoc-cli

WORKDIR /build
ADD deploy-*.yaml /build
RUN for i in deploy*.yaml; do html="${i#deploy-}"; html="${html%.yaml}"; redoc-cli bundle $i --output "$html.html"; done
WORKDIR /output
RUN mv ../build/*.html .

FROM docker.io/nginx:alpine
COPY --from=build /output/* /usr/share/nginx/html/
