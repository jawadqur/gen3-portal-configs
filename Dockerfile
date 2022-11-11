ARG CODE_VERSION=feat_jq_prebuilder	
FROM quay.io/cdis/data-portal:${CODE_VERSION} as builder

ARG PORTAL_HOSTNAME=healdata.org


# ENV PORTAL_HOSTNAME healdata.org
ENV APP gitops
ENV BASENAME /

RUN echo "PORTAL: ${PORTAL_HOSTNAME}"
# COPY dockerStart.sh ./runWebpack.sh ./package.json ./
# COPY data data
COPY webpack.config.js webpack.config.js 
COPY ${PORTAL_HOSTNAME}/portal/gitops.json data/config/
COPY ${PORTAL_HOSTNAME}/portal/gitops-logo.png custom/logo/gitops-logo.png
COPY ${PORTAL_HOSTNAME}/portal/gitops-favicon.ico custom/favicon/gitops-favicon.ico
COPY ${PORTAL_HOSTNAME}/portal/gitops.css custom/css/gitops.css
COPY ${PORTAL_HOSTNAME}/portal/gitops-sponsors custom/sponsors/gitops-sponsors

ENV NODE_ENV=production
RUN bash runWebpack.sh

# FROM nginx:latest

# COPY --from=builder /data-portal/build/*.js /data-portal/build/index.html /usr/share/nginx/html/
# COPY --from=builder /data-portal/src/img/ /usr/share/nginx/html/src/img/
# COPY --from=builder /data-portal/src/css/ /usr/share/nginx/html/src/css/