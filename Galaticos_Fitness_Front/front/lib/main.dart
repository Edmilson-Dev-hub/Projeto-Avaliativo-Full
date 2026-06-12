import 'dart:convert';
import 'package:flutter/material.dart';
import 'treinos.dart';
import 'exercicios.dart';
import 'perfil.dart';
import 'login.dart';
import 'lista_geral_exercicios.dart';
import 'api_service.dart';

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
      home: const TelaLogin(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const Treinos(),
    const ListaGeralExercicios(),
    const Perfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: _currentIndex == 0, child: _screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFFC107),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Exercícios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<dynamic> _historicoReal = [];
  bool _carregando = true;

  String _treinoNomeTela = 'Carregando...';
  String _treinoFocoTela = 'Buscando...';
  int _treinoIdTela = 1;

  @override
  void initState() {
    super.initState();
    _sincronizarTreinoABC();
  }

  Future<void> _sincronizarTreinoABC() async {
    if (!mounted) return;
    setState(() => _carregando = true);

    try {
      List<dynamic> historico = await ApiService.buscarHistorico();
      List<dynamic> treinosDoBanco = await ApiService.buscarTreinos();

      if (treinosDoBanco.isNotEmpty) {
        int indiceProximo = historico.length % treinosDoBanco.length;

        var proximoTreinoReal = treinosDoBanco[indiceProximo];

        if (mounted) {
          setState(() {
            _historicoReal = historico;
            _treinoNomeTela = proximoTreinoReal['nome_treino'] ?? 'Treino';
            _treinoFocoTela = proximoTreinoReal['foco'] ?? 'Geral';
            _treinoIdTela = proximoTreinoReal['id'];
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _historicoReal = historico;
            _treinoNomeTela = 'Crie um Treino';
            _treinoFocoTela = 'Vá na aba Treinos';
            _treinoIdTela = 1;
          });
        }
      }
    } catch (e) {
      print('Erro na sincronização: $e');
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String nomeUsuario = ApiService.usuarioNome ?? 'Edmilson';

    return RefreshIndicator(
      color: const Color(0xFFFFC107),
      onRefresh: _sincronizarTreinoABC,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cabeçalho
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              decoration: const BoxDecoration(color: Color(0xFF161616)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Olá, $nomeUsuario!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(' 💪', style: TextStyle(fontSize: 24)),
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

            // 2. Seção: Seu Progresso
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Seu progresso',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ProgressCard(
                      icon: Icons.local_fire_department_rounded,
                      value: '${_historicoReal.length}',
                      label: 'Treinos\nconcluídos',
                      iconColor: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
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

            const SizedBox(height: 25),

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _treinoNomeTela,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _treinoFocoTela,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _carregando
                          ? null
                          : () async {
                              // Abre a tela de Exercícios passando o ID e título reais do próximo treino da fila do MySQL
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Exercicios(
                                    titulo: _treinoNomeTela,
                                    treinoId: _treinoIdTela,
                                  ),
                                ),
                              );
                              _sincronizarTreinoABC();
                            },
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

            // 4. Seção: Últimos Treinos Realizados
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Últimos treinos realizados',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _carregando
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFFC107),
                      ),
                    ),
                  )
                : _historicoReal.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Center(
                      child: Text(
                        'Nenhum treino concluído ainda. Vamos treinar!',
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _historicoReal.length,
                      itemBuilder: (context, index) {
                        final item = _historicoReal[index];

                        String dataFormatada = item['data_conclusao'] != null
                            ? item['data_conclusao']
                                  .toString()
                                  .substring(0, 10)
                                  .replaceAll('-', '/')
                            : 'Recentemente';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: PastWorkoutTile(
                            title: item['nome_treino'] ?? 'Treino Realizado',
                            date: dataFormatada,
                            icon: Icons.check_circle_outline_rounded,
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const ProgressCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class PastWorkoutTile extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;

  const PastWorkoutTile({
    super.key,
    required this.title,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF8F9FA),
            radius: 22,
            child: Icon(icon, color: Colors.black54, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
        ],
      ),
    );
  }
}
