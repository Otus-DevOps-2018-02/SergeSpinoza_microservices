FROM python:3.6.0-alpine

WORKDIR /app
COPY . /app

RUN apk update && apk add gcc musl-dev
RUN pip install -r /app/requirements.txt

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]
