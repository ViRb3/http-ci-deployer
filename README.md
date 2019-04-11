# HTTP CI Deployer
An extremely simple HTTP-based deployment solution for Continuous Integration services. Originally designed for GitLab's CI/CD.

## Usage
### General
This project exposes a single wildcard endpoint:
```
/deploy/*
```
If you want to deploy the file `localfile.zip` to `archive/localfile.zip`, you would submit a request to:
```
/deploy/archive/localfile.zip
```
Note that all deployment paths are relative to the working directory of the project!

### Curl command
```bash
curl -F file=@localfile.zip -H "KEY: 123" "https://website.com/archive/localfile.zip"
```

### GitLab CI/CD stage
```yml
deploy:
  stage: deploy
  before_script:
    - apt update -y
    - apt install curl -y
  script:
    # define DEPLOY_FILE, DEPLOY_KEY, DEPLOY_URL
    - >
      curl -F file=@$DEPLOY_FILE -H "KEY: $DEPLOY_KEY" "$DEPLOY_URL"
```

## Installation
1. Set a deployment key in `key.txt`. This will be checked before accepting a deployment
```bash
echo "SUPER_LONG_AND_SECRET_KEY" > key.txt
```

2. Run the webserver
```bash
/home/deploy/deployer-amd64 --port 5000
```

3. *(optional)* Install the systemd unit [deployer.service](deployer.service). Make sure you tweak or satisfy the configuration inside it.
