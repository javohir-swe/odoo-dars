FROM python:3.10-bullseye

ARG UID=999
# create the working directory and a place to set the logs (if wanted)
RUN mkdir -p /odoo /var/log/odoo

COPY ./base_requirements.txt /odoo
COPY ./extra_requirements.txt /odoo

COPY ./install /install

# Moved because there was a bug while installing `odoo-autodiscover`. There is
# an accent in the contributor name
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# build and dev packages
ENV BUILD_PACKAGE \
    build-essential \
    gcc \
    libevent-dev \
    libfreetype6-dev \
    libxml2-dev \
    libxslt1-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libjpeg-dev \
    libpng-dev \
    zlib1g-dev \
    git

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
# wkhtml-buster is kept as in official image, no deb available for bullseye
RUN sh -c /install/package_odoo-bullseye.sh
RUN /install/setup-pip.sh
RUN /install/postgres.sh
RUN /install/kwkhtml_client.sh
RUN /install/kwkhtml_client_force_python3.sh
RUN /install/dev_package.sh
RUN python3 -m pip install --force-reinstall pip "setuptools<58"
RUN pip install -r /odoo/base_requirements.txt --ignore-installed
RUN pip install -r /odoo/extra_requirements.txt --ignore-installed
RUN /install/purge_dev_package_and_cache.sh


# grab dockerize to generate template and
# wait on postgres
RUN /install/dockerize.sh

COPY ./bin /odoo/odoo-bin
COPY ./templates /templates
COPY ./before-migrate-entrypoint.d /odoo/before-migrate-entrypoint.d
COPY ./start-entrypoint.d /odoo/start-entrypoint.d
COPY ./MANIFEST.in /odoo

COPY ./src/odoo/ /odoo/src/
COPY ./src/local/ /odoo/local-src
COPY ./src/addons/ /odoo/external-src
COPY ./songs /odoo/songs
COPY ./setup.py /odoo/
COPY ./VERSION /odoo/
COPY ./migration.yml /odoo/

RUN adduser --disabled-password -u $UID --gecos '' odoo \
    && touch /odoo/odoo.cfg \
    && mkdir -p /odoo/data/odoo/{addons,filestore,sessions} \
    && chown -R odoo:odoo /odoo && usermod odoo --home /odoo \
    && chown -R odoo:odoo /var/log/odoo

USER odoo
# Expose Odoo services
EXPOSE 8069 8072

ENV ODOO_VERSION=16.0 \
    PATH=/odoo/odoo-bin:/odoo/.local/bin:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    # the place where you put the data of your project (csv, ...)
    ODOO_DATA_PATH=/odoo/data \
    DEMO=False \
    OPENERP_SERVER=/odoo/odoo.cfg


WORKDIR /odoo/src
RUN pip install --user -e .

# ENV ADDONS_PATH=/odoo/src/addons,/odoo/src/odoo/addons,/odoo/local-src

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]
