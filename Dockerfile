FROM docker.io/node:latest as redoc

RUN npm i -g redoc-cli

WORKDIR /build
ADD deploy-*.yaml /build
RUN for i in deploy*.yaml; do html="${i#deploy-}"; html="${html%.yaml}"; redoc-cli bundle $i --output "$html.html"; done
WORKDIR /output
RUN mv ../build/*.html .

FROM docker.io/ubuntu:latest as mkd2html
WORKDIR /build
ADD /pandoc/* /build/
RUN apt-get update && apt-get -y install pandoc
RUN pandoc appendix.md -c style.css --self-contained -o appendix.html
RUN pandoc CHANGELOG.md -c style.css --self-contained -o changelog.html
WORKDIR /output
RUN mv /build/*.html /output


FROM docker.io/nginx:alpine
COPY --from=redoc /output/* /usr/share/nginx/html/
COPY --from=mkd2html /output/* /usr/share/nginx/html/
ADD config/default.conf.template /etc/nginx/templates/
