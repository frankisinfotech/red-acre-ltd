# Build step #1: build the React front end
FROM node:16-alpine as build-step
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY ./sys-stats/package.json ./sys-stats/yarn.lock ./
COPY ./sys-stats/src ./src
COPY ./sys-stats/public ./public
RUN yarn install
RUN yarn build

# Build step #2: build the API with the client as static files
FROM python:3.9
WORKDIR /app
COPY --from=build-step /app/build ./build

RUN mkdir ./api
COPY ./api/requirements.txt ./api/app.py ./api
RUN pip install -r ./api/requirements.txt
ENV FLASK_ENV production

EXPOSE 3000
WORKDIR /app/api
CMD ["python3", "./app.py"]
#CMD ["gunicorn", "-b", ":3000", "api:app"]
