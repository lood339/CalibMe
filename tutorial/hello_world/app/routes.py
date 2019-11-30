from app import app

# decorators to associate the URL and function
@app.route('/')
@app.route('/index')
def index():
    return 'Hello, World'
