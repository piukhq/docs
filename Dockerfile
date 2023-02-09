FROM docker.io/node:latest as redoc

RUN npm i -g redoc-cli

# External API v2
WORKDIR /build
ADD deploy-*.yaml /build
RUN for i in deploy*.yaml; do html="${i#deploy-}"; html="${html%.yaml}"; redoc-cli bundle $i --output "$html.html"; done
WORKDIR /output
RUN mv ../build/*.html .

# BPL 
WORKDIR /build/bpl
ADD bpl/deploy-bpl.yaml /build/bpl
RUN for i in deploy*.yaml; do html="${i#deploy-}"; html="${html%.yaml}"; redoc-cli bundle $i --output "$html.html"; done
WORKDIR /output/bpl
RUN mv ../../build/bpl/bpl.html ./index.html

# Portal
WORKDIR /build/portal
ADD portal/portal_api.yaml /build/portal
ADD portal/portal_components.yaml /build/portal
RUN redoc-cli bundle portal_api.yaml --output portal.html
WORKDIR /output/portal
RUN mv ../../build/portal/portal.html ./index.html

# API v1 legacy specifications
WORKDIR /build/apiv1
ADD apiv1/deploy-apiv1_2.yaml /build/apiv1
ADD apiv1/deploy-apiv1_3.yaml /build/apiv1
RUN for i in deploy*.yaml; do html="${i#deploy-}"; html="${html%.yaml}"; redoc-cli bundle $i --output "$html.html"; done
WORKDIR /output/apiv1
RUN mv ../../build/apiv1/apiv1_2.html ./indexv1_2.html
RUN mv ../../build/apiv1/apiv1_3.html ./indexv1_3.html


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
COPY --from=redoc /output/bpl/* /usr/share/nginx/html/bpl/
COPY --from=redoc /output/portal/* /usr/share/nginx/html/portal/
COPY --from=redoc /output/apiv1/indexv1_2.html /usr/share/nginx/html/v1/2/index.html
COPY --from=redoc /output/apiv1/indexv1_3.html /usr/share/nginx/html/v1/3/index.html
COPY --from=mkd2html /output/* /usr/share/nginx/html/
RUN chmod 755 /usr/share/nginx/html/bpl/
ADD config/default.conf.template /etc/nginx/templates/
