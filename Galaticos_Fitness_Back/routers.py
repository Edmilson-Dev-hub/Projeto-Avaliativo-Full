
from flask import request, jsonify
import uuid # token unico recuperacao
from app import app, mysql, bcrypt 
from flask_mail import Message
from app import mail

@app.route('/cadastro', methods=['POST'])
def cadastrar_usuario():
    "cadastro de novos usuários com senha criptografada"
    d = request.json
    nome = d.get('nome')
    email = d.get('email')
    senha_plana = d.get('senha')
    meta = d.get('meta', 5)

    if not nome or not email or not senha_plana:
        return jsonify({'erro': 'Todos os campos são obrigatórios!'}), 400

    #hash segura da senha
    senha_criptografada = bcrypt.generate_password_hash(senha_plana).decode('utf-8')

    cursor = mysql.connection.cursor()
    try:
        cursor.execute(
            'INSERT INTO usuarios(nome, email, senha, meta_treinos_semana) VALUES(%s, %s, %s, %s)',
            (nome, email, senha_criptografada, meta)
        )
        mysql.connection.commit()
        return jsonify({'mensagem': 'Usuário cadastrado com sucesso!'}), 201
    except Exception as e:
        return jsonify({'erro': 'E-mail já cadastrado no sistema.'}), 400


@app.route('/login', methods=['POST'])
def login():
    "validando as credenciais comparando a senha plana com a hash do banco."
    d = request.json
    email = d.get('email')
    senha_plana = d.get('senha')

    cursor = mysql.connection.cursor()
    cursor.execute('SELECT id, nome, email, senha, meta_treinos_semana FROM usuarios WHERE email = %s', (email,))
    usuario = cursor.fetchone()

    if usuario and bcrypt.check_password_hash(usuario[3], senha_plana):
        return jsonify({
            'mensagem': 'Login realizado com sucesso!',
            'usuario': {
                'id': usuario[0],
                'nome': usuario[1],
                'email': usuario[2],
                'meta': usuario[4]
            }
        }), 200
    
    return jsonify({'erro': 'E-mail ou senha incorretos.'}), 401


@app.route('/logout', methods=['POST'])
def logout():
    "logoff"
    return jsonify({'mensagem': 'Logoff realizado com sucesso. Volte sempre!'}), 200


" crud usuarios"

@app.route('/usuarios', methods=['GET'])
def listar_usuarios():
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT id, nome, meta_treinos_semana FROM usuarios')
    return jsonify([{'id': i[0], 'nome': i[1], 'meta': i[2]} for i in cursor.fetchall()])


@app.route('/usuarios/<int:id>', methods=['PUT'])
def atualizar_usuario(id):
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('UPDATE usuarios SET nome=%s, meta_treinos_semana=%s WHERE id=%s', (d['nome'], d['meta'], id))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Usuário atualizado com sucesso!'})


@app.route('/usuarios/<int:id>', methods=['DELETE'])
def deletar_usuario(id):
    cursor = mysql.connection.cursor()
    cursor.execute('DELETE FROM usuarios WHERE id = %s', (id,))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Usuário removido com sucesso!'})


'crud treinos'
@app.route('/treinos', methods=['GET'])
def listar_treinos():
    user_id = request.args.get('usuario_id')
    cursor = mysql.connection.cursor()
    
    if user_id:
        cursor.execute('SELECT * FROM treinos WHERE usuario_id = %s', (user_id,))
    else:
        cursor.execute('SELECT * FROM treinos')
        
    return jsonify([{'id': i[0], 'usuario_id': i[1], 'nome': i[2], 'foco': i[3]} for i in cursor.fetchall()])


@app.route('/treinos', methods=['POST'])
def cadastrar_treino():
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('INSERT INTO treinos(usuario_id, nome_treino, foco) VALUES(%s, %s, %s)', (d['usuario_id'], d['nome'], d['foco']))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Treino cadastrado com sucesso!'}), 201


@app.route('/treinos/<int:id>', methods=['PUT'])
def atualizar_treino(id):
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('UPDATE treinos SET nome_treino=%s, foco=%s WHERE id=%s', (d['nome'], d['foco'], id))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Treino updated com sucesso!'})


@app.route('/treinos/<int:id>', methods=['DELETE'])
def deletar_treino(id):
    cursor = mysql.connection.cursor()
    cursor.execute('DELETE FROM treinos WHERE id = %s', (id,))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Treino removido com sucesso!'})


'crud exercicios'
@app.route('/exercicios', methods=['GET'])
def listar_exercicios():
    treino_id = request.args.get('treino_id')
    cursor = mysql.connection.cursor()
    
    if treino_id:
        cursor.execute('SELECT id, treino_id, nome, series, repeticoes FROM exercicios WHERE treino_id = %s', (treino_id,))
    else:
        cursor.execute('SELECT id, treino_id, nome, series, repeticoes FROM exercicios')
        
    return jsonify([{'id': i[0], 'treino_id': i[1], 'nome': i[2], 'series': i[3], 'reps': i[4]} for i in cursor.fetchall()])


@app.route('/exercicios', methods=['POST'])
def cadastrar_exercicio():
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('INSERT INTO exercicios(treino_id, nome, series, repeticoes) VALUES(%s, %s, %s, %s)', (d['treino_id'], d['nome'], d['series'], d['reps']))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Exercício cadastrado com sucesso!'}), 201


@app.route('/exercicios/<int:id>', methods=['PUT'])
def atualizar_exercicio(id):
    dados = request.json
    nome = dados['nome']
    series = dados['series']
    repeticoes = dados['reps']
    
    cursor = mysql.connection.cursor()
    cursor.execute('UPDATE exercicios SET nome=%s, series=%s, repeticoes=%s WHERE id=%s', (nome, series, repeticoes, id))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Exercício atualizado com sucesso!'})


@app.route('/exercicios/<int:id>', methods=['DELETE'])
def deletar_exercicio(id):
    cursor = mysql.connection.cursor()
    cursor.execute('DELETE FROM exercicios WHERE id = %s', (id,))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Exercício removido com sucesso!'})

' historico treinos'
@app.route('/historico', methods=['GET', 'POST'])
def gerenciar_historico():
    cursor = mysql.connection.cursor()
    
    if request.method == 'POST':
        d = request.json
        cursor.execute(
            'INSERT INTO historico_treinos(usuario_id, treino_id) VALUES(%s, %s)', 
            (d['usuario_id'], d['treino_id'])
        )
        mysql.connection.commit()
        return jsonify({'mensagem': 'Parabéns! Treino salvo no seu histórico.'}), 201

    elif request.method == 'GET':
        user_id = request.args.get('usuario_id')
        if not user_id:
            return jsonify({'erro': 'Parâmetro usuario_id é obrigatório'}), 400
            
        query = """
            SELECT h.id, h.data_realizacao, t.nome_treino, t.foco, h.treino_id
            FROM historico_treinos h
            INNER JOIN treinos t ON h.treino_id = t.id
            WHERE h.usuario_id = %s
            ORDER BY h.data_realizacao DESC
        """
        cursor.execute(query, (user_id,))
        rows = cursor.fetchall()
        
        resultado = []
        for i in rows:
            resultado.append({
                'id': i[0],
                'data_conclusao': str(i[1]),
                'nome_treino': i[2],
                'foco_treino': i[3],
                'treino_id': int(i[4])
            })
            
        return jsonify(resultado), 200