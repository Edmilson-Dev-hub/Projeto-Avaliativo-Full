import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000';

  // variáveis globais para guardar a sessão do usuário logado
  static int? usuarioId;
  static String? usuarioNome;
  static String? usuarioEmail;

  // login
  static Future<dynamic> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        var dados = jsonDecode(response.body);
        usuarioId = dados['usuario']['id'];
        usuarioNome = dados['usuario']['nome'];
        usuarioEmail = dados['usuario']['email'];
        return dados;
      }
    } catch (e) {
      print('Erro ao tentar fazer login: $e');
    }
    return null;
  }

  // cadastro
  static Future<bool> cadastrar(String nome, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cadastro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
    }
    return false;
  }

  // metod recuperação de senha
  static Future<bool> recuperarSenha(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recuperar-senha'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao recuperar senha: $e');
    }
    return false;
  }

  static Future<List<dynamic>> buscarHistorico() async {
    try {
      final idUsuario = usuarioId ?? 1;
      final response = await http.get(
        Uri.parse('$baseUrl/historico?usuario_id=$idUsuario'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Erro ao buscar histórico: $e');
    }
    return [];
  }

  // lista de todos os treinos
  static Future<List<dynamic>> buscarTreinos() async {
    try {
      final idUsuario = usuarioId ?? 1;
      final response = await http.get(
        Uri.parse('$baseUrl/treinos?usuario_id=$idUsuario'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Erro ao buscar treinos: $e');
    }
    return [];
  }

  static void deslogar() {
    usuarioId = null;
    usuarioNome = null;
    usuarioEmail = null;
  }

  static Future<bool> enviarEmailAlterarSenha() async {
    try {
      if (usuarioEmail == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/recuperar-senha'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': usuarioEmail}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao solicitar alteração de senha: $e');
    }
    return false;
  }
}
