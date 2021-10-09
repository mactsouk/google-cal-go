# docker build -t gcal .
# docker run -it -p 2345:2345 gcal

FROM golang:alpine AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

RUN mkdir $GOPATH/src/server
RUN mkdir /pro
ADD ./gCal.go $GOPATH/src/server
WORKDIR $GOPATH/src/server
ADD ./gCal.go /pro/
RUN go mod init
RUN go mod tidy
RUN go build -o /pro/server gCal.go

FROM alpine:latest

RUN mkdir /pro
ADD ./credentials.json /pro/
ADD ./token.json /pro/
COPY --from=builder /pro/server /pro/server
EXPOSE 2348
WORKDIR /pro
CMD ["/pro/server"]

