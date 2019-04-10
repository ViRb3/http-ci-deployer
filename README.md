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
1. Clone this repo
2. Set a deployment key in `key.txt`. This will be checked before accepting a deployment
```bash
echo "SUPER_LONG_AND_SECRET_KEY" > key.txt
```

2. Install `pipenv`

```bash
python3 -m pip install pipenv
```

3. Run `pipenv update`
```bash
python3 -m pipenv update
```

4. Run the webserver
```bash
python3 -m pipenv run gunicorn --bind 0.0.0.0:5000 app:app
```

5. *(optional)* Install the systemd unit `deployer.service`. Make sure you tweak or satisfy the user and path configuration inside it.
