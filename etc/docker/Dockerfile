FROM ubuntu:22.10

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y build-essential gdb nasm valgrind wget python3-pip

RUN wget -P ~ https://git.io/.gdbinit

RUN pip3 install pygments

WORKDIR /workspace
