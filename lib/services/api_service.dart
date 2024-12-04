import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/conversao.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000/conversoes';

  static int nextId = 1;

  Future<void> criarConversao(Conversao conversao) async {

    final conversaoComId = Conversao(
      id: nextId.toString(),
      moedaOrigem: conversao.moedaOrigem,
      moedaDestino: conversao.moedaDestino,
      valorOriginal: conversao.valorOriginal,
      valorConvertido: conversao.valorConvertido,
    );

    nextId++;

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(conversaoComId.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao criar conversão');
    }
  }

  Future<List<Conversao>> obterConversoes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        nextId = data.map((e) => int.tryParse(e['id'] ?? '0') ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      }
      return data.map((json) => Conversao.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar conversões');
    }
  }

  Future<void> deletarConversao(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar conversão');
    }
  }

  Future<void> editarConversao(Conversao conversao) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${conversao.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(conversao.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao editar conversão');
    }
  }
}
