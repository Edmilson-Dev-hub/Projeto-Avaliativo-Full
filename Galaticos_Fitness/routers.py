from flask import render_template, request
from app import app, mysql  # Importa o app e a conexão do arquivo principal

#listando os usuarios
@app.route('/usuarios', methods=['GET'])
def listar_usuarios():
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT * FROM usuarios')
    usuarios = []

    for item in cursor.fetchall():
        usuarios.append({
            'id': item[0],
            'nome': item[1],
            'cidade': item[2]
        })

    return jsonify(usuarios)

#cadastrar usuarios
@app.route('/usuarios', methods=['POST'])
def cadastrar_usuario():
    dados = request.json

    nome = dados['nome']
    cidade = dados['cidade']

    cursor = mysql.connection.cursor()

    cursor.execute('insert into usuarios(nome, cidade) values(%s, %s)', (nome, cidade))

    mysql.connection.commit()

    return jsonify({'mensagem': 'Usuário cadastrado com sucesso!'})

#atualizar
@app.route('/usuarios/<int:id>', methods=['PUT'])
def atualizar_usuario(id):
    dados = request.json

    nome = dados['nome']
    cidade = dados['cidade']

    cursor = mysql.connection.cursor()

    cursor.execute('update usuarios set nome = %s, cidade = %s where id = %s', (nome, cidade, id))

    mysql.connection.commit()

    return jsonify({'mensagem': 'Usuário atualizado com sucesso'})

#deletar 
@app.route('/usuarios/<int:id>', methods=['DELETE'])
def deletar_usuario(id):
    cursor = mysql.connection.cursor()

    cursor.execute('delete from usuarios where id = %s', (id,))

    mysql.connection.commit()

    return jsonify({'mensagem': 'Usuário deletado com sucesso'})


# ===================== treinos

#listando treinos
@app.route('/treinos', methods=['GET'])
def listar_treinos():
    cursor = mysql.connection.cursor()
    cursor.execute('select * from treinos')

    treinos = []

    for item in cursor.fetchall():
        treinos.append({
            'id': item[0],
            'nome': item[1],
            'exercicio': item[2],
            'duracao': item[3]
        })

    return jsonify(treinos)

#cadastrando treinos
@app.route('/treinos', methods=['POST'])
def cadastrar_treino():
    dados = request.json

    nome = dados['nome']
    exercicio = dados['exercicio']
    duracao = dados['duracao']

    cursor = mysql.connection.cursor()

    cursor.execute('insert into treinos(nome, exercicio, duracao) values(%s, %s, %s)', (nome, exercicio, duracao))

    mysql.connection.commit()

    return jsonify({'mensagem': 'Treino cadastrado com sucesso'})

#atualizando treinos
@app.route('/treinos/<int:id>', methods=['PUT'])
def atualizar_treino(id):
    dados = request.json

    nome = dados['nome']
    exercicio = dados['exercicio']
    duracao = dados['duracao']

    cursor = mysql.connection.cursor()

    cursor.execute('update treinos set nome = %s, exercicio = %s, duracao = %s where id = %s', (nome, exercicio, duracao, id))

    mysql.connection.commit()

    return jsonify({'mensagem': 'Treino atualizado com sucesso'})

#deletando treinos
@app.route('/treinos/<int:id>', methods=['DELETE'])
def deletar_treino(id):
    cursor = mysql.connection.cursor()

    cursor.execute('delete from treinos where id = %s', (id,))

    mysql.connection.commit()

    return jsonify({'mensagem': 'Treino deletado com sucesso'})

# ====================== exercicios
@app.route('/exercicios', methods=['GET'])
def listar_exercicios():
    cursor = mysql.connection.cursor()
    cursor.execute('select * from exercicios')

    exercicios = []

    for item in cursor.fetchall():
        exercicios.append({
            'id': item[0],
            'nome': item[1],
            'descricao': item[2]
        })

    return jsonify(exercicios)

#cadastrando exercicios
@app.route('/exercicios', methods=['POST'])
def cadastrar_exercicio():
    dados = request.json

    nome = dados['nome']
    descricao = dados['descricao']

    cursor = mysql.connection.cursor()

    cursor.execute('insert into exercicios(nome, descricao) values(%s, %s)', (nome, descricao))

    mysql.connection.commit()

    return jsonify({'mensagem': 'Exercício cadastrado com sucesso'})
    id_time_casa = dados['id_time_casa']
    id_time_visitante = dados['id_time_visitante']
    placar_casa = dados['placar_casa']
    placar_visitante = dados['placar_visitante']

    cursor = mysql.connection.cursor()
    cursor.execute('insert into partidas(data, id_time_casa, id_time_visitante, placar_casa, placar_visitante) values(%s, %s, %s, %s, %s)', (data, id_time_casa, id_time_visitante, placar_casa, placar_visitante))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Partida cadastrada com sucesso'})

#atualizando partidas 
@app.route('/partidas/<int:id>', methods=['PUT'])
def atualizar_partida(id):
    dados = request.json

    data = dados['data']
    id_time_casa = dados['id_time_casa']
    id_time_visitante = dados['id_time_visitante']
    placar_casa = dados['placar_casa']
    placar_visitante = dados['placar_visitante']

    cursor = mysql.connection.cursor()
    cursor.execute('update partidas set data = %s, id_time_casa = %s, id_time_visitante = %s, placar_casa = %s, placar_visitante = %s where id = %s', (data, id_time_casa, id_time_visitante, placar_casa, placar_visitante, id))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Partida atualizada com sucesso'})

#deletando partidas 
@app.route('/partidas/<int:id>', methods=['DELETE'])
def deletar_partida(id):
    cursor = mysql.connection.cursor()
    cursor.execute('delete from partidas where id = %s', (id))
    mysql.connection.commit()
    return jsonify({'mensagem': 'Partida deletada com sucesso'})

if __name__ == '__main__':
    app.run(debug=True)