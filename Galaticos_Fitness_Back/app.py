from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS
from flask_bcrypt import Bcrypt
from flask_mail import Mail, Message 
import uuid

app = Flask(__name__)
CORS(app)

bcrypt = Bcrypt(app) 

'config smpt do servidor do email'

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False
app.config['MAIL_USERNAME'] = 'edmilsonsantosg2@gmail.com'  # ✉️ Coloque o e-mail aqui
app.config['MAIL_PASSWORD'] = 'zzfr nwqc hvsi xerl'            # 🔐 Coloque a Senha de App de 16 dígitos aqui

mail = Mail(app) 

'config do banco'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '12345678'
app.config['MYSQL_DB'] = 'galaticos_fitness'

mysql = MySQL(app)

' aqui eu forçei a rota direto '

@app.route('/recuperar-senha', methods=['POST'])
def recuperar_senha():
    "Gerando um token único, salvando no banco e enviando um e-mail real para o usuário."
    d = request.json
    email = d.get('email')

    cursor = mysql.connection.cursor()
    cursor.execute('SELECT id, nome FROM usuarios WHERE email = %s', (email,))
    usuario = cursor.fetchone()

    if usuario:
        usuario_id = usuario[0]
        usuario_nome = usuario[1]
        
        token = str(uuid.uuid4())
        cursor.execute('UPDATE usuarios SET token_recuperacao = %s WHERE email = %s', (token, email))
        mysql.connection.commit()
        
        link_redefinicao = f"http://127.0.0.1:5000/redefinir/{usuario_id}?token={token}"

        try:
            msg = Message(
                subject="Galáticos Fitness - Recuperação de Senha",
                sender=app.config['MAIL_USERNAME'],
                recipients=[email]
            )
            
            msg.body = f"Olá, {usuario_nome}!\n\nVocê solicitou a redefinição de sua senha no sistema Galáticos Fitness.\n\nClique no link seguro abaixo para criar uma nova senha:\n{link_redefinicao}\n\nSe você não solicitou essa alteração, por favor ignore este e-mail por segurança."
            
            mail.send(msg)
            
            print(f"\n[SUCESSO DEFINITIVO] E-mail enviado para {email} com o token: {token}\n")
            return jsonify({'mensagem': 'E-mail de recuperação enviado com sucesso!'}), 200
            
        except Exception as e:
            print(f"\n[ERRO REAL NO DISPARO] Falha ao mandar o e-mail: {e}\n")
            return jsonify({'erro': 'Erro interno ao tentar enviar o e-mail.'}), 500
    
    return jsonify({'erro': 'E-mail não encontrado.'}), 404

from routers import *

if __name__ == '__main__':
    app.run(debug=True, port=5000)