from controller.controller import app


@app.route('/')
def hello():
    return 'hello' 

