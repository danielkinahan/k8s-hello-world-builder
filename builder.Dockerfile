FROM docker:dind
RUN apk --no-cache add git
WORKDIR /builder
CMD ["sh"]