FROM ubuntu
LABEL maintainer="shayco@gmail.com"

ENV RELEASE 0.0.4

RUN apt-get update && apt-get install -y wget tar
RUN mkdir /vagrancy
RUN cd /vagrancy && wget https://github.com/ryandoyle/vagrancy/releases/download/$RELEASE/vagrancy-$RELEASE-linux-x86_64.tar.gz && tar xzf vagrancy-$RELEASE-linux-x86_64.tar.gz && unlink vagrancy-$RELEASE-linux-x86_64.tar.gz
RUN cd /vagrancy && mv vagrancy-$RELEASE-linux-x86_64 linux-x86_64

RUN useradd vagrancy
USER vagrancy

ADD vagrancy-wd.sh /vagrancy-wd.sh

EXPOSE 8099

VOLUME  ["/vagrancy/linux-x86_64/data"]

CMD ["/bin/sh", "/vagrancy-wd.sh"]
