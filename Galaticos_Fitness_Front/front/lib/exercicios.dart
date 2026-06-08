// OBJETO DE ESTUDO: LIB/EXERCICIOS.DART
import 'package:flutter/material.dart';

class Exercicios extends StatelessWidget {
  final String titulo;
  const Exercicios({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Top escuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Infos (duração, quantidade, nivel)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161616),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoItem(Icons.access_time, '60 min', 'Duração'),
                        _infoItem(Icons.fitness_center, '6', 'Exercícios'),
                        _infoItem(Icons.bar_chart, 'Intermediário', 'Nível'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Exercícios',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // Lista de exercícios
                  _cardExercicio('Supino Reto', '3 séries de 12 reps'),
                  _cardExercicio('Supino inclinado', '3 séries de 12 reps'),
                  _cardExercicio('Crucifixo', '3 séries de 12 reps'),
                  _cardExercicio('Triceps Pulley', '3 séries de 12 reps'),
                  _cardExercicio('Triceps Testa', '3 séries de 12 reps'),
                ],
              ),
            ),
          ),
          // Botão inferior amarelo
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Iniciar Treino',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } // <-- O MÉTODO BUILD TERMINA EXATAMENTE AQUI!

  // AGORA AS FUNÇÕES AUXILIARES FICAM FORA DO BUILD, COMO MÉTODOS DA CLASSE:

  // Widget para as infos (duração, quantidade, nivel)
  Widget _infoItem(IconData icon, String valor, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFFC107)),
        const SizedBox(height: 5),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // Widget para cards de exercicio
  Widget _cardExercicio(String nome, String series) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(series),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
