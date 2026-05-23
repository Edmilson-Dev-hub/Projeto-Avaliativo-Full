from flask import Flask
from flask_mysqldb import MySQL
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '12345678'
app.config['MYSQL_DB'] = 'galaticos_fitness'

mysql = MySQL(app)

# Importa as rotas
from routers import *

if __name__ == '__main__':
    app.run(debug=True, port=5000)
