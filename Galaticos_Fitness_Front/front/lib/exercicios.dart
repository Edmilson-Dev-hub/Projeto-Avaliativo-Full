import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class Exercicios extends StatefulWidget {
  final String titulo;
  final int? treinoId;

  const Exercicios({super.key, required this.titulo, this.treinoId});

  @override
  State<Exercicios> createState() => _ExerciciosState();
}

class _ExerciciosState extends State<Exercicios> {
  List<dynamic> _listaExercicios = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarExerciciosDoBanco();
  }

  // exercicios filtrados pelo id
  Future<void> _buscarExerciciosDoBanco() async {
    if (widget.treinoId == null) {
      setState(() => _carregando = false);
      return;
    }
    setState(() => _carregando = true);
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiService.baseUrl}/exercicios?treino_id=${widget.treinoId}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _listaExercicios = jsonDecode(response.body);
          _carregando = false;
        });
      }
    } catch (e) {
      print('Erro ao buscar exercícios: $e');
      setState(() => _carregando = false);
    }
  }

  Future<void> _cadastrarExercicio(String nome, int series, String reps) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/exercicios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'treino_id': widget.treinoId,
          'nome': nome,
          'series': series,
          'reps': reps,
        }),
      );

      if (response.statusCode == 201) {
        _buscarExerciciosDoBanco();
      }
    } catch (e) {
      print('Erro ao cadastrar exercício: $e');
    }
  }

  Future<void> _atualizarExercicio(
    int idExercicio,
    String nome,
    int series,
    String reps,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/exercicios/$idExercicio'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'series': series, 'reps': reps}),
      );

      if (response.statusCode == 200) {
        _buscarExerciciosDoBanco();
      }
    } catch (e) {
      print('Erro ao atualizar exercício: $e');
    }
  }

  Future<void> _deletarExercicio(int idExercicio) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}/exercicios/$idExercicio'),
      );

      if (response.statusCode == 200) {
        _buscarExerciciosDoBanco();
      }
    } catch (e) {
      print('Erro ao deletar exercício: $e');
    }
  }

  Future<void> _concluirTreinoNoHistorico() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/historico'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': ApiService.usuarioId ?? 1,
          'treino_id': widget.treinoId ?? 1,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Treino Concluído! Salvo no histórico.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      print('Erro ao salvar histórico: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616),
        elevation: 0,
        title: Text(
          widget.titulo,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_box_outlined,
              color: Color(0xFFFFC107),
              size: 28,
            ),
            onPressed: () => _mostrarDialogoExercicio(isEdit: false),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoItem(Icons.access_time, '60 min', 'Duração'),
                _infoItem(
                  Icons.fitness_center,
                  '${_listaExercicios.length}',
                  'Exercícios',
                ),
                _infoItem(Icons.bar_chart, 'Intensidade', 'Foco'),
              ],
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
                : _listaExercicios.isEmpty
                ? const Center(
                    child: Text('Nenhum exercício cadastrado neste treino.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: _listaExercicios.length,
                    itemBuilder: (context, index) {
                      final exercicio = _listaExercicios[index];
                      return _buildExercicioCard(
                        id: exercicio['id'],
                        nome: exercicio['nome'],
                        series: exercicio['series'],
                        reps: exercicio['reps'].toString(),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _concluirTreinoNoHistorico(),
                child: const Text(
                  'Concluir Treino',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFFC107), size: 24),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildExercicioCard({
    required int id,
    required String nome,
    required int series,
    required String reps,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '$series Séries x $reps Repetições',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
              onPressed: () => _mostrarDialogoExercicio(
                isEdit: true,
                id: id,
                nomeAtual: nome,
                seriesAtual: series,
                repsAtual: reps,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _deletarExercicio(id),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoExercicio({
    required bool isEdit,
    int? id,
    String? nomeAtual,
    int? seriesAtual,
    String? repsAtual,
  }) {
    final TextEditingController nomeCtrl = TextEditingController(
      text: isEdit ? nomeAtual : '',
    );
    final TextEditingController seriesCtrl = TextEditingController(
      text: isEdit ? seriesAtual.toString() : '',
    );
    final TextEditingController repsCtrl = TextEditingController(
      text: isEdit ? repsAtual : '',
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
              decoration: _buildInputDecoration('Nome do Exercício'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: seriesCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Quantidade de Séries'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: repsCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Repetições (ex: 12 ou Falha)'),
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
                int series = int.tryParse(seriesCtrl.text) ?? 3;
                if (isEdit && id != null) {
                  _atualizarExercicio(
                    id,
                    nomeCtrl.text.trim(),
                    series,
                    repsCtrl.text.trim(),
                  );
                } else {
                  _cadastrarExercicio(
                    nomeCtrl.text.trim(),
                    series,
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
