import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ListaGeralExercicios extends StatefulWidget {
  const ListaGeralExercicios({super.key});

  @override
  State<ListaGeralExercicios> createState() => _ListaGeralExerciciosState();
}

class _ListaGeralExerciciosState extends State<ListaGeralExercicios> {
  List<dynamic> _exerciciosGlobais = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarTodosOsExercicios();
  }

  Future<void> _buscarTodosOsExercicios() async {
    if (!mounted) return;
    setState(() => _carregando = true);
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/exercicios'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _exerciciosGlobais = jsonDecode(response.body);
          _carregando = false;
        });
      }
    } catch (e) {
      print('Erro ao buscar exercícios globais: $e');
      setState(() => _carregando = false);
    }
  }

  Future<void> _criarExercicioGlobal(
    String nome,
    int series,
    String reps,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/exercicios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'treino_id': 1,
          'nome': nome,
          'series': series,
          'reps': reps,
        }),
      );
      if (response.statusCode == 201) _buscarTodosOsExercicios();
    } catch (e) {
      print('Erro ao criar exercício: $e');
    }
  }

  Future<void> _editarExercicioGlobal(
    int id,
    String nome,
    int series,
    String reps,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/exercicios/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'series': series, 'reps': reps}),
      );
      if (response.statusCode == 200) _buscarTodosOsExercicios();
    } catch (e) {
      print('Erro ao editar exercício: $e');
    }
  }

  Future<void> _deletarExercicioGlobal(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}/exercicios/$id'),
      );
      if (response.statusCode == 200) _buscarTodosOsExercicios();
    } catch (e) {
      print('Erro ao deletar exercício: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC107),
        onPressed: () => _mostrarDialogoForm(isEdit: false),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 25),
            color: const Color(0xFF161616),
            child: const Center(
              child: Text(
                'Dicionário de Exercícios',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFFC107),
                      ),
                    ),
                  )
                : _exerciciosGlobais.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum exercício no banco. Toque no + para criar!',
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _exerciciosGlobais.length,
                    itemBuilder: (context, index) {
                      final item = _exerciciosGlobais[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF161616),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              color: Color(0xFFFFC107),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            item['nome'] ?? 'Exercício',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${item['series']} séries x ${item['reps']} reps',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () => _mostrarDialogoForm(
                                  isEdit: true,
                                  id: item['id'],
                                  nomeAt: item['nome'],
                                  serAt: item['series'],
                                  repAt: item['reps'].toString(),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () =>
                                    _deletarExercicioGlobal(item['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // pop-up para coletar dados do formulário de criação/edição
  void _mostrarDialogoForm({
    required bool isEdit,
    int? id,
    String? nomeAt,
    int? serAt,
    String? repAt,
  }) {
    final TextEditingController nomeCtrl = TextEditingController(
      text: isEdit ? nomeAt : '',
    );
    final TextEditingController seriesCtrl = TextEditingController(
      text: isEdit ? serAt.toString() : '',
    );
    final TextEditingController repsCtrl = TextEditingController(
      text: isEdit ? repAt : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161616),
        title: Text(
          isEdit ? 'Editar Exercício' : 'Novo Exercício',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: seriesCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Séries'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: repsCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Repetições'),
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
              if (nomeCtrl.text.isNotEmpty &&
                  seriesCtrl.text.isNotEmpty &&
                  repsCtrl.text.isNotEmpty) {
                int s = int.tryParse(seriesCtrl.text) ?? 3;
                if (isEdit && id != null) {
                  _editarExercicioGlobal(
                    id,
                    nomeCtrl.text.trim(),
                    s,
                    repsCtrl.text.trim(),
                  );
                } else {
                  _criarExercicioGlobal(
                    nomeCtrl.text.trim(),
                    s,
                    repsCtrl.text.trim(),
                  );
                }
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
