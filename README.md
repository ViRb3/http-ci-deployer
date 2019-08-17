# HTTP CI Deployer
An extremely simple HTTP-based deployment solution for Continuous Integration services. Originally designed as a safer, simpler alternative to SSH and SCP for GitLab's CI/CD.

## Usage
### General
A single wildcard endpoint is exposed:
```
/deploy/*
```
If you want to deploy `localfile.zip` to `archive/localfile.zip`, you would submit a `POST` request to: `/deploy/archive/localfile.zip`, with the file content as form data and the deployment key as a `KEY` header.

Note that all deployment paths are relative to the working directory of the deployer binary!

### Curl command
```bash
curl -F file=@localfile.zip -H "KEY: 123" "https://website.com/archive/localfile.zip"
```

### CI/CD
Example variables:
* DEPLOY_FILE: `localfile.zip`

Example secrets:
* DEPLOY_KEY: `123`
* DEPLOY_URL: `https://website.com/archive`

#### Drone CI
```yml
steps:
- name: deploy
  image: ubuntu
  environment:
    DEPLOY_KEY:
      from_secret: DEPLOY_KEY
    DEPLOY_URL:
      from_secret: DEPLOY_URL
  commands:
  - apt update -y
  - apt install curl -y
  - >
    STATUS=$(curl --write-out %{http_code} --silent --output /dev/null
    -F file=@$DEPLOY_FILE -H "KEY: $DEPLOY_KEY" "$DEPLOY_URL/$DEPLOY_FILE")
  - >
    echo "Result: $STATUS"
  - >
    [ "$STATUS" = "200" ] || exit 1
```

#### GitLab
```yml
deploy:
  image: ubuntu
  stage: deploy
  before_script:
    - apt update -y
    - apt install curl -y
  script:
    - >
      STATUS=$(curl --write-out %{http_code} --silent --output /dev/null
      -F file=@$DEPLOY_FILE -H "KEY: $DEPLOY_KEY" "$DEPLOY_URL/$DEPLOY_FILE")
    - >
      echo "Result: $STATUS"
    - >
      [ "$STATUS" == "200" ] || exit 1
```

## Installation
1. Set a deployment key in `key.txt` in the deployer's working directory. It must be longer than **10 characters** or you will get a `bad key` error.
```bash
echo "SUPER_LONG_AND_SECRET_KEY" > key.txt
```

2. Run the webserver
```bash
/home/deploy/deployer-amd64 --port 5000
```

3. *(optional)* Install the systemd unit [deployer.service](deployer.service). Make sure you tweak or satisfy the configuration inside it.
