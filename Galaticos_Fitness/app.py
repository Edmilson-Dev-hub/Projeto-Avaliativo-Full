from flask import Flask
from flask_mysqldb import MySQL

app = Flask(__name__)

# Configurações do Banco de Dados
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'seu_usuario'
app.config['MYSQL_PASSWORD'] = 'sua_senha'
app.config['MYSQL_DB'] = 'seu_banco'

# Inicializa o MySQL atrelando-o ao app principal
mysql = MySQL(app)

# Importa as rotas no final para evitar importação cíclica
from routes import *

if __name__ == '__main__':
    app.run(debug=True)
