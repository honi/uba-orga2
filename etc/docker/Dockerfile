FROM ubuntu:22.10

# Los sospechosos de siempre
RUN apt update && apt install -y build-essential nasm valgrind wget python3-pip

# GDB + dashboard
# https://github.com/cyrus-and/gdb-dashboard
RUN apt install -y gdb
RUN wget -P ~ https://git.io/.gdbinit
RUN pip3 install pygments

# Bochs
ENV BOCHS_URL=https://sourceforge.net/projects/bochs/files/bochs/2.7/bochs-2.7.tar.gz/download
RUN apt install -y mtools libgtk2.0-dev libvncserver-dev
RUN wget --content-disposition -O - $BOCHS_URL | tar -xzf - && \
    cd bochs-2.7 && \
    ./configure --prefix=$HOME/bochs/ --enable-debugger --enable-readline --disable-docbook --with-vncsrv && \
    make && make install
RUN echo 'export PATH="$HOME/bochs/bin:$PATH"\nexport BXSHARE="$HOME/bochs/share/bochs"' >> ~/.bashrc
COPY bochsrc /etc

# Al iniciar el container arrancamos en este path,
# donde está mounteado el path del host desde donde corriste orga2shell.
WORKDIR /workspace
