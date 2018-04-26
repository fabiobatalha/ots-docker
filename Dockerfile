FROM centos:centos7
MAINTAINER fabio.batalha@erudit.org

# General Dependencies
RUN yum -y update && \
    yum groupinstall -y "Development Tools" && \
    yum install -y vim git wget && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum install -y yum-utils && \
    yum-config-manager --enable remi-php71
RUN yum install -y python-pip
RUN pip install --upgrade pip
RUN mkdir project

WORKDIR project
COPY deps /project/deps
COPY entrypoint /project/entrypoint
COPY config /project/config

# Decompressing Dependencies
RUN cd /project/deps && \
    unzip deps.zip && \
    rm deps.zip && \
    cd -

# ParsCit
# https://github.com/knmnyn/ParsCit/blob/master/INSTALL
RUN yum install -y perl perl-core perl-XML-Twig perl-XML-Writer ruby && \
    curl -L http://cpanmin.us | perl - App::cpanminus && \
    cpanm XML::Writer::String && \
    cd deps/CRF++-0.58 && \
    ./configure && \
    make && \
    make install
ENV CRFPP_HOME=/usr/local

# Pandoc
# https://pandoc.org/
RUN yum install -y pandoc pandoc-citeproc ghc-pandoc-citeproc

# Image Exif
# https://sno.phy.queensu.ca/~phil/exiftool/
RUN cd deps/Image-ExifTool-10.87 && \
    perl Makefile.PL && \
    make install

# MITIE
# About: https://github.com/mit-nlp/MITIE
RUN yum install -y cmake libX11-devel blas-devel blas OpenBLAS && \
    cd deps/MITIE-0.5/tools/ner_stream && \
    mkdir build && \
    cmake . && \
    cmake --build . --config Release && \
    cp ner_stream /usr/local/bin && \
    cd -

# meTypeset Dependencies
# https://github.com/MartinPaulEve/meTypeset
RUN pip install django editdistance lxml

# GROBID
# https://github.com/kermitt2/grobid
RUN yum install -y java-devel
RUN cd deps && \
    wget https://github.com/kermitt2/grobid/archive/0.5.1.zip && \
    unzip 0.5.1.zip && \
    rm 0.5.1.zip && \
    cd grobid-0.5.1 && \
    ./gradlew clean install && \

    # For OTS compatibility
    mkdir -p grobid-core/target && \
    cp grobid-core/build/libs/* grobid-core/target

# OTS dependencies
# https://github.com/pkp/ots
RUN yum install -y php httpd php-xsl php-mysql php-pdo python-lxml php-cli php-mcrypt php-ldap php-zip java sendmail zip unzip && \
    yum install -y libreoffice python-openoffice.noarch libreoffice-pyuno.x86_64 unoconv
RUN cd deps/bibutils_6.2 && \
    ./configure && \
    make && \
    make install && \
    cd -
RUN git clone https://github.com/pkp/ots.git && \
    cd ots && \
    rm composer.lock && \
    php composer.phar self-update -vvv && \
    php composer.phar install -vvv && \
    cd -

# CONFIG FILES
RUN ln -s /project/config/ots/local.php ots/config/autoload/local.php && \
    rm /etc/php.ini && \
    ln -s /project/config/php/php.ini /etc/php.ini && \
    rm /etc/httpd/conf/httpd.conf && \
    ln -s /project/config/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf && \
    mkdir /etc/httpd/conf.d/vhosts && \
    ln -s /project/config/httpd/conf.d/vhosts/ots.conf /etc/httpd/conf.d/vhosts/ots.conf

# PERMISSIONS
RUN chmod -v +x /project/entrypoint/processes_wrapper.sh && \
    chmod -v go+w -R /project/ots/var && \
    touch /var/local/queue_debug.out && \
    chmod -v go+w /var/local/queue_debug.out && \
    chown apache:apache /var/local/queue_debug.out && \
    chmod -v go+w /project/entrypoint/processes_wrapper.sh && \
    chown -R apache:apache /project/ots && \
    chmod -v 755 -R /project/ots

CMD ["/project/entrypoint/processes_wrapper.sh"]