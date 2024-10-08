# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:slim-bullseye as base

EXPOSE 8000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

#Upgrade pip
RUN pip install --upgrade pip
# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /app
COPY ./app /app

## --- Debug ---
FROM base as debug
RUN pip install debugpy==1.8.1
EXPOSE 5678
