from flask import request, jsonify
from app import app, mysql

#crud usuarios
@app.route('/usuarios', methods=['GET'])
def listar_usuarios():
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT * FROM usuarios')
    return jsonify([{'id': i[0], 'nome': i[1], 'meta': i[2]} for i in cursor.fetchall()])

@app.route('/usuarios', methods=['POST'])
def cadastrar_usuario():
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('INSERT INTO usuarios(nome, meta_treinos_semana) VALUES(%s, %s)', (d['nome'], d['meta']))
    mysql.connection.commit()
    return jsonify({'msg': 'Sucesso'})

@app.route('/usuarios/<int:id>', methods=['PUT'])
def atualizar_usuario(id):
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('UPDATE usuarios SET nome=%s, meta_treinos_semana=%s WHERE id=%s', (d['nome'], d['meta'], id))
    mysql.connection.commit()
    return jsonify({'msg': 'Atualizado'})

@app.route('/usuarios/<int:id>', methods=['DELETE'])
def deletar_usuario(id):
    cursor = mysql.connection.cursor()
    cursor.execute('DELETE FROM usuarios WHERE id = %s', (id,))
    mysql.connection.commit()
    return jsonify({'msg': 'Removido'})

#crud treinos
@app.route('/treinos', methods=['GET'])
def listar_treinos():
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT * FROM treinos')
    return jsonify([{'id': i[0], 'usuario_id': i[1], 'nome': i[2], 'foco': i[3]} for i in cursor.fetchall()])

@app.route('/treinos', methods=['POST'])
def cadastrar_treino():
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('INSERT INTO treinos(usuario_id, nome_treino, foco) VALUES(%s, %s, %s)', (d['usuario_id'], d['nome'], d['foco']))
    mysql.connection.commit()
    return jsonify({'msg': 'Sucesso'})

@app.route('/treinos/<int:id>', methods=['PUT'])
def atualizar_treino(id):
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('UPDATE treinos SET nome_treino=%s, foco=%s WHERE id=%s', (d['nome'], d['foco'], id))
    mysql.connection.commit()
    return jsonify({'msg': 'Atualizado'})

@app.route('/treinos/<int:id>', methods=['DELETE'])
def deletar_treino(id):
    cursor = mysql.connection.cursor()
    cursor.execute('DELETE FROM treinos WHERE id = %s', (id,))
    mysql.connection.commit()
    return jsonify({'msg': 'Removido'})

#crud exercicios
@app.route('/exercicios', methods=['GET'])
def listar_exercicios():
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT * FROM exercicios')
    return jsonify([{'id': i[0], 'treino_id': i[1], 'nome': i[2], 'series': i[3], 'reps': i[4]} for i in cursor.fetchall()])

@app.route('/exercicios', methods=['POST'])
def cadastrar_exercicio():
    d = request.json
    cursor = mysql.connection.cursor()
    cursor.execute('INSERT INTO exercicios(treino_id, nome, series, repeticoes) VALUES(%s, %s, %s, %s)', (d['treino_id'], d['nome'], d['series'], d['reps']))
    mysql.connection.commit()
    return jsonify({'msg': 'Sucesso'})

@app.route('/exercicios/<int:id>', methods=['PUT'])
def atualizar_exercicio(id):
    dados = request.json
    
    nome = dados['nome']
    series = dados['series']
    repeticoes = dados['reps']
    
    cursor = mysql.connection.cursor()
    cursor.execute('''
        UPDATE exercicios 
        SET nome = %s, series = %s, repeticoes = %s 
        WHERE id = %s
    ''', (nome, series, repeticoes, id))
    
    mysql.connection.commit()
    return jsonify({'mensagem': 'Exercício atualizado com sucesso!'})

@app.route('/exercicios/<int:id>', methods=['DELETE'])
def deletar_exercicio(id):
    cursor = mysql.connection.cursor()
    cursor.execute('DELETE FROM exercicios WHERE id = %s', (id,))
    mysql.connection.commit()
    return jsonify({'msg': 'Removido'})
