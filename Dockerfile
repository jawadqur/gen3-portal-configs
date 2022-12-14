ARG CODE_VERSION=feat_jq_prebuilder	
FROM quay.io/cdis/data-portal:${CODE_VERSION} as builder

ARG PORTAL_HOSTNAME

ENV APP gitops
ENV BASENAME /

RUN echo "PORTAL: ${PORTAL_HOSTNAME}"
# COPY dockerStart.sh ./runWebpack.sh ./package.json ./
# COPY data data
COPY webpack.config.js webpack.config.js 

COPY ${PORTAL_HOSTNAME}/portal/ /overrides
COPY overrides.sh .
RUN bash overrides.sh

ENV NODE_ENV=production
RUN bash runWebpack.sh

FROM nginx:latest

COPY nginx.conf /etc/nginx/sites-enabled
COPY --from=builder /data-portal/build/*.js /data-portal/build/index.html /usr/share/nginx/html/
COPY --from=builder /data-portal/src/img/ /usr/share/nginx/html/src/img/
COPY --from=builder /data-portal/src/css/ /usr/share/nginx/html/src/css/