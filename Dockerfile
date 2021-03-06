FROM ubuntu:latest as build-diamond

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt-get update && apt-get install -y g++ automake cmake zlib1g-dev subversion

WORKDIR /opt/diamond
ADD . .

RUN svn co https://anonsvn.ncbi.nlm.nih.gov/repos/v1/trunk/c++
WORKDIR c++
RUN ./cmake-configure --without-debug --with-projects="objtools/blast/seqdb_reader;objtools/blast/blastdb_format"
WORKDIR CMake-GCC930-Release/build
RUN make -j4

WORKDIR build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make && make install

FROM ubuntu:latest

LABEL maintainer="Benjamin Buchfink <buchfink@gmail.com>"

COPY --from=build-diamond /usr/local/bin/diamond /usr/local/bin/diamond

ENTRYPOINT ["diamond"]
CMD ["help"]