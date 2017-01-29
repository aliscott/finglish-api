Very basic English -> Finglish translator

## Run locally

```
GOOGLE_PROJECT_ID=<GOOGLE_PROJECT_ID GOOGLE_API_KEY=<GOOGLE_API_KEY> bundle exec rackup
```

## Run with Docker

```
docker build -t aliscott/finglish-api .
docker run \
  -p 9292:9292 \
  --env GOOGLE_PROJECT_ID=<GOOGLE_PROJECT_ID \
  --env GOOGLE_API_KEY=<GOOGLE_API_KEY> \
  aliscott/finglish-api
```

## Run on AbarCloud

```
oc new-app github.com/aliscott/finglish-api.git \
  --strategy=docker \
  --env GOOGLE_PROJECT_ID=<GOOGLE_PROJECT_ID \
  --env GOOGLE_API_KEY=<GOOGLE_API_KEY>
oc path bc/finglish-api -p '{"spec":{"strategy":{"dockerStrategy":""}}}'
oc start-build bc/finglish-api
oc expose svc--hostname=finglish.abar.cloud
```
