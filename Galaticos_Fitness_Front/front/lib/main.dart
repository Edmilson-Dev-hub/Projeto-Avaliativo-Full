import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galaticos Fitness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //cabeçalho
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF161616),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Olá, Fulano!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bora treinar hoje?',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // seu progresso
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Seu progresso',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // <-- O 'const' saiu daqui para não dar erro com as cores
                      const Expanded(
                        child: ProgressCard(
                          icon: Icons.local_fire_department_rounded,
                          value: '12',
                          label: 'Treinos\nconcluídos',
                          iconColor: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ProgressCard(
                          icon: Icons.calendar_month_rounded,
                          value: '5',
                          label: 'Dias\nseguidos',
                          iconColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: ProgressCard(
                          icon: Icons.emoji_events_rounded,
                          value: '1',
                          label: 'Meta\nsemanal',
                          iconColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // proximo treino
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Próximo treino',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF161616),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          color: Colors.amber,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxistAlignment.start,
                          children: const [
                            Text(
                              'Peito e Tríceps',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Hoje ° 18:00',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Iniciar Treino',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: const [
                    PastWorkoutTile(
                      title: 'Costa e Bíceps',
                      date: '08/05/2024',
                      icon: Icons.accessibility_new_sharp,
                    ),
                    SizedBox(height: 10),
                    PastWorkoutTile(
                      title: 'Pernas',
                      date: '06/05/2024',
                      icon: Icons.directions_run_rounded,
                    ),
                    SizedBox(height: 10),
                    PastWorkoutTile(
                      title: 'Peito',
                      date: '04/05/204',
                      icon: Icons.sports_martial_arts_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
