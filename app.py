from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')  # Flask automatically looks for templates in the 'templates' folder

if __name__ == '__main__':
    app.run(debug=True, port=80, host='0.0.0.0')  # The app will be exposed on port 80

