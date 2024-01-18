from flask import Flask
app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World! Welcome to the demo of k8s-hello-world-builder."


if __name__ == "__main__":
    app.run()
