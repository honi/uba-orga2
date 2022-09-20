FROM ubuntu:22.10

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y build-essential gdb nasm valgrind wget python3-pip

RUN wget -P ~ https://git.io/.gdbinit

RUN pip3 install pygments

# Hasta que me acuerde de memoria estos flags defino un alias "v" que ejecuta valgrind con los flags ya seteados.
RUN echo "alias v='valgrind --leak-check=full --track-origins=yes'" >> ~/.bashrc

WORKDIR /workspace
