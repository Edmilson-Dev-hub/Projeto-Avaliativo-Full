import 'package:flutter/material.dart';

class Treinos extends StatelessWidget {
  const Treinos({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFFFC107),
          child: const Icon(Icons.add, color: Colors.black, size: 30),
        ),
        body: Column(
          children: [
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
                  // barra de abas(tabs)
                  const TabBar(
                    indicatorColor: Color(0xFFFFC107),
                    labelColor: Color(0xFFFFC107),
                    unselectedLabelColor: Colors.white,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: [
                      Tab(text: 'Meus Treinos'),
                      Tab(text: 'Todos os treinos'),
                    ],
                  ),
                ],
              ),
            ),
            // 'conteúdo' das abas
            Expanded(
              child: TabBarView(
                children: [
                  // conteúdo da aba 'Meus Treinos'
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      WorkoutCard(
                        title: 'Peito e triceps',
                        exercises: '6 exercicios',
                      ),
                      WorkoutCard(
                        title: 'Costa e Bíceps',
                        exercises: '6 exercicios',
                      ),
                      WorkoutCard(title: 'Pernas', exercises: '7 exercicios'),
                      WorkoutCard(title: 'Ombros', exercises: '4 exercicios'),
                      WorkoutCard(title: 'Abdômen', exercises: '4 exercicios'),
                    ],
                  ),
                  // conteúdo da aba 'Todos os treinos'
                  const Center(
                    child: Text(
                      'Novos treinos em breve',
                      style: TextStyle(color: Colors.grey),
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

// widget para os cards da lista de treinos
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
        onTap: () {},
      ),
    );
  }
}
