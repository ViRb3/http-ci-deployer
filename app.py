import os
from flask import Flask, request, redirect, flash

app = Flask(__name__)

with open('key.txt', 'r') as file:
    KEY: str = file.read()
assert len(KEY.strip()) > 10, "bad key"

@app.route('/deploy/<path:path>', methods=['POST'])
def deploy(path):

    key = request.headers.get('KEY')
    if key != KEY:
        print("Incorrect key:", key)
        return "", 403

    if len(request.files) < 1:
        print("No file given")
        return "no file given", 400

    file = next(request.files.values())
    file.save(path)
    print("Deployed to:", path)
    return "", 200
