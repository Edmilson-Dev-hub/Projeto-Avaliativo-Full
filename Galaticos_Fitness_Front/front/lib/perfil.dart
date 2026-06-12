import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';
import 'login.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  // função do whatsapp
  Future<void> _abrirWhatsApp() async {
    const String numeroWhats = "5583986379361";
    const String mensagem =
        "Olá! Preciso de suporte com o app Galaticos Fitness.";

    final Uri url = Uri.parse(
      "https://wa.me/$numeroWhats?text=${Uri.encodeComponent(mensagem)}",
    );

    try {
      if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
        // Abriu com sucesso
      } else {
        throw 'Não foi possível abrir o WhatsApp';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao redirecionar para o WhatsApp.'),
          ),
        );
      }
    }
  }

  Future<void> _solicitarAlteracaoSenha() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
        ),
      ),
    );

    bool sucesso = await ApiService.enviarEmailAlterarSenha();

    if (mounted) {
      Navigator.pop(context); // Fecha o loading

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(sucesso ? 'E-mail Enviado!' : 'Ops!'),
          content: Text(
            sucesso
                ? 'Enviamos um link de redefinição de senha seguro para o e-mail: ${ApiService.usuarioEmail}. Verifique sua caixa de entrada.'
                : 'Não conseguimos processar o envio. Tente novamente mais tarde.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFFFC107)),
              ),
            ),
          ],
        ),
      );
    }
  }

  // funcao logout
  void _efetuarLogout() {
    ApiService.deslogar();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaLogin()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String nomeUsuario = ApiService.usuarioNome ?? 'Usuário';
    String emailUsuario = ApiService.usuarioEmail ?? 'email@provedor.com';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // deixando o topo do perfil com usuario que ta logado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 35),
              decoration: const BoxDecoration(
                color: Color(0xFF161616),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFFFC107),
                    child: Icon(Icons.person, size: 55, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nomeUsuario,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    emailUsuario,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Segurança',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.lock_reset_rounded,
                            color: Colors.black87,
                          ),
                          title: const Text('Alterar senha'),
                          subtitle: const Text(
                            'Enviar link seguro para o e-mail',
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: _solicitarAlteracaoSenha,
                        ),
                        const Divider(height: 1, indent: 50, endIndent: 16),
                        ListTile(
                          leading: const Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                          ),
                          title: const Text(
                            'Sair da conta',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Sair do App'),
                                content: const Text(
                                  'Tem certeza que deseja encerrar sua sessão atual?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _efetuarLogout();
                                    },
                                    child: const Text(
                                      'Sair',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Suporte',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.green,
                      ),
                      title: const Text('Ajuda e suporte'),
                      subtitle: const Text('Falar com a equipe no WhatsApp'),
                      trailing: const Icon(
                        Icons.open_in_new_rounded,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: _abrirWhatsApp,
                    ), // ListTile
                  ), // Card
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
