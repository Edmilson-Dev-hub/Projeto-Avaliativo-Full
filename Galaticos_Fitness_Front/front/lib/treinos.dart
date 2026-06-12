import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'exercicios.dart';

class Treinos extends StatefulWidget {
  const Treinos({super.key});

  @override
  State<Treinos> createState() => _TreinosState();
}

class _TreinosState extends State<Treinos> {
  List<dynamic> _meusTreinos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarTreinosDoBanco();
  }

  Future<void> _buscarTreinosDoBanco() async {
    setState(() => _carregando = true);
    try {
      final idUsuario = ApiService.usuarioId ?? 1;
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/treinos?usuario_id=$idUsuario'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _meusTreinos = jsonDecode(response.body);
          _carregando = false;
        });
      }
    } catch (e) {
      print('Erro ao buscar treinos: $e');
      setState(() => _carregando = false);
    }
  }

  Future<void> _cadastrarNovoTreino(String nome, String foco) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/treinos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': ApiService.usuarioId ?? 1,
          'nome': nome,
          'foco': foco,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Treino criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _buscarTreinosDoBanco();
      }
    } catch (e) {
      print('Erro ao cadastrar treino: $e');
    }
  }

  Future<void> _deletarTreino(int idTreino) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}/treinos/$idTreino'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Treino removido!'),
            backgroundColor: Colors.redAccent,
          ),
        );
        _buscarTreinosDoBanco();
      }
    } catch (e) {
      print('Erro ao deletar treino: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        // cadastro de treino botao
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFFC107),
          onPressed: () => _mostrarDialogoCadastro(),
          child: const Icon(Icons.add, color: Colors.black),
        ),

        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 0),
              color: const Color(0xFF161616),
              child: Column(
                children: [
                  const Text(
                    'Treinos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const TabBar(
                    indicatorColor: Color(0xFFFFC107),
                    labelColor: Color(0xFFFFC107),
                    unselectedLabelColor: Colors.grey,
                    tabs: [Tab(text: 'Meus treinos')],
                  ),
                ],
              ),
            ),

            // Conteúdo das Abas
            Expanded(
              child: TabBarView(
                children: [
                  _carregando
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFFFC107),
                            ),
                          ),
                        )
                      : _meusTreinos.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum treino cadastrado. Toque no + para criar!',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemCount: _meusTreinos.length,
                          itemBuilder: (context, index) {
                            final treino = _meusTreinos[index];
                            return _buildWorkoutCard(
                              id: treino['id'],
                              title: treino['nome'] ?? 'Sem Nome',
                              focus: treino['foco'] ?? 'Geral',
                            );
                          },
                        ),

                  const Center(
                    child: Text('Novos treinos da comunidade em breve!'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // auxiliar que desenha o Card do Treino com as ações do CRUD
  Widget _buildWorkoutCard({
    required int id,
    required String title,
    required String focus,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFF161616),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.fitness_center_rounded,
            color: Color(0xFFFFC107),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'Foco: $focus',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),

        // Botão de Deletar
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _deletarTreino(id),
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Exercicios(titulo: title, treinoId: id),
            ),
          );
        },
      ),
    );
  }

  // Pop-up que captura os dados para criar o treino
  void _mostrarDialogoCadastro() {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController focoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161616),
        title: const Text('Novo Treino', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration(
                'Nome do Treino (ex: Treino A)',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: focoController,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration(
                'Foco do Treino (ex: Peito e Tríceps)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
            ),
            onPressed: () {
              if (nomeController.text.isNotEmpty &&
                  focoController.text.isNotEmpty) {
                _cadastrarNovoTreino(
                  nomeController.text.trim(),
                  focoController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFC107)),
      ),
    );
  }
}
