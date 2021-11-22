FROM docker:20.10.10-alpine3.14

COPY . ./

ENTRYPOINT [ "/entrypoint.sh" ]