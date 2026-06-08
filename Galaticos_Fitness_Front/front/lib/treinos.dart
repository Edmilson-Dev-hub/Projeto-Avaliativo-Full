// OBJETO DE ESTUDO: LIB/TREINOS.DART
import 'package:flutter/material.dart';
import 'exercicios.dart'; // Importa a tela de exercícios para navegação

class Treinos extends StatelessWidget {
  const Treinos({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController é OBRIGATÓRIO para fazer as abas funcionarem
    return DefaultTabController(
      length: 2, // Quantidade de abas (Meus treinos e Todos os treinos)
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // Mantém o fundo claro padrão
        // Botão Flutuante Amarelo de "+" no canto inferior
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Ação futura para adicionar treino
          },
          backgroundColor: const Color(0xFFFFC107),
          child: const Icon(Icons.add, color: Colors.black, size: 30),
        ),

        body: Column(
          children: [
            // 1. Cabeçalho Escuro da Tela de Treinos
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 0),
              color: const Color(0xFF161616),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Treinos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Configuração visual das Abas
                  const TabBar(
                    indicatorColor: Color(
                      0xFFFFC107,
                    ), // Linha amarela embaixo da aba ativa
                    labelColor: Color(0xFFFFC107), // Texto amarelo na aba ativa
                    unselectedLabelColor:
                        Colors.grey, // Texto cinza na aba inativa
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: [
                      Tab(text: 'Meus treinos'),
                      Tab(text: 'Todos os treinos'),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Conteúdo que muda ao clicar nas Abas
            Expanded(
              child: TabBarView(
                children: [
                  // Conteúdo da Primeira Aba: "Meus treinos"
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: const [
                      WorkoutCard(
                        title: 'Peito e Tríceps',
                        exercises: '6 exercícios',
                      ),
                      WorkoutCard(
                        title: 'Costas e Bíceps',
                        exercises: '6 exercícios',
                      ),
                      WorkoutCard(title: 'Pernas', exercises: '7 exercícios'),
                      WorkoutCard(title: 'Ombros', exercises: '4 exercícios'),
                      WorkoutCard(title: 'Abdômen', exercises: '4 exercícios'),
                    ],
                  ),

                  // Conteúdo da Segunda Aba: "Todos os treinos"
                  const Center(
                    child: Text(
                      'Em breve novos treinos!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget customizado para renderizar cada linha de treino da lista
class WorkoutCard extends StatelessWidget {
  final String title;
  final String exercises;

  const WorkoutCard({super.key, required this.title, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            color: Colors.amber,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          exercises,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Exercicios(
                titulo: title,
              ), // 'title' é o nome do treino clicado
            ),
          );
        },
      ),
    );
  }
}
