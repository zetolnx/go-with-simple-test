FROM golang:1.14-alpine AS builder

### add make gcc g++ python if you will use native dependencies
RUN mkdir -p $GOPATH/src/github.com/zetogk/go-with-simple-test && \
apk add --no-cache gcc g++ git openssh-client

WORKDIR $GOPATH/src/github.com/zetogk/go-with-simple-test

ENV GO111MODULE=on

COPY . .

RUN go build ./... && go build

FROM alpine

RUN apk --no-cache add ca-certificates bash

WORKDIR /root/

COPY --from=builder /go/src/github.com/zetogk/go-with-simple-test .

RUN chmod +x ./go-with-simple-test

EXPOSE 8009

ENTRYPOINT [ "./go-with-simple-test" ]
