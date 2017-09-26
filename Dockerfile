FROM python:3.6
WORKDIR /
ADD . /

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# update package list
RUN apt-get update
RUN apt-get update && apt-get install --assume-yes apt-utils

# install necessary locales
RUN apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

# unixODBC
RUN apt-get -y install unixodbc
RUN apt-get -y install unixodbc-dev

RUN apt-get install -f

# Msodbc
RUN DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y dpkg -i /extra_packages/msodbcsql_13.1.9.1-1_amd64.deb


RUN cd /

# django specific

ENV PYTHONUNBUFFERED 1
RUN pip install -r requirements.txt

EXPOSE 8000
ENV DJANGO_SETTINGS_MODULE=django_mssql_deb.settings

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]