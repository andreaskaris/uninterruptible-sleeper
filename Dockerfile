FROM registry.fedoraproject.org/fedora:latest AS builder
RUN mkdir /build
COPY . /build/
WORKDIR /build
RUN yum install "@Development Tools" -y
RUN make build

FROM registry.fedoraproject.org/fedora-minimal:latest
COPY --from=builder /build/_output/* /usr/bin/
RUN microdnf install util-linux e2fsprogs -y && microdnf clean all
