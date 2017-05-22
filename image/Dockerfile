# License: GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
# The license applies to the way the image is built, while the
# software components inside the image are under the respective
# licenses chosen by their respective copyright holders.

FROM ubuntu:16.04
MAINTAINER Mohamed Hashi <maxamedhashi@gmail.com>

# Install texlive
RUN export LANG=C.UTF-8 &&\
    apt-get clean &&\
    apt-get update &&\
    apt-get autoclean -y &&\
    apt-get autoremove -y &&\
    apt-get update &&\
# install utilities
    apt-get install -f -y apt-utils &&\
# install TeX Live and ghostscript
    apt-get install -f -y ghostscript=9.18* \
                          make=4.1* \
                          texlive-latex-recommended=2015.2016* \
                          texlive-math-extra=2015.2016* \
                          texlive-luatex=2015.2016* \
                          texlive-pstricks=2015.2016* \
                          texlive-xetex=2015.2016* &&\
                          software-properties-common &&\\
# free huge amount of unused space
    apt-get purge -f -y make-doc \
                        texlive-fonts-recommended-doc \
                        texlive-latex-base-doc \
                        texlive-latex-extra-doc \
                        texlive-latex-recommended-doc \
                        texlive-metapost-doc \
                        texlive-pictures-doc \
                        texlive-pstricks-doc
                      

# Install php
RUN apt-get install -f -y python-software-properties &&\
    add-apt-repository ppa:ondrej/php &&\
    apt-get update &&\
    apt-get install -f -y php5.6

# Install sqlite3
RUN apt-get install -f -y sqlite3 libsqlite3-dev

#Install git
RUN apt-get install -f -y git

# clean up all temporary files 
RUN    apt-get clean &&\
    apt-get autoclean -y &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -rf /tmp/* /var/tmp/* &&\
    rm -rf /var/lib/apt/lists/* &&\    
    rm -f /etc/ssh/ssh_host_*



RUN git clone https://github.com/mqzry/stacks-bootstrap.git /var/stacks-bootstrap &&\
cd /var/stacks-bootstrap &&\
./bootstrap.sh

VOLUME ["/doc/", "/usr/share/fonts/external/"]

ADD scripts /bin/

ENTRYPOINT ["/bin/__boot__.sh"]