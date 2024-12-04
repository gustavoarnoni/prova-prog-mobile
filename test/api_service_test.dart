import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:conversor_de_moedas/services/api_service.dart';
import 'package:conversor_de_moedas/models/conversao.dart';
import 'package:conversor_de_moedas/models/moeda.dart';

void main() {
  group('ApiService', () {
    test('deve criar uma conversão com sucesso', () async {

      final conversao = Conversao(
        id: null,
        moedaOrigem: Moeda(codigo: 'USD', nome: 'Dólar'),
        moedaDestino: Moeda(codigo: 'BRL', nome: 'Real'),
        valorOriginal: 100.0,
        valorConvertido: 500.0,
      );

      final apiService = ApiService();

      try {
        await apiService.criarConversao(conversao);
      } catch (e) {
        fail('A criação da conversão falhou com erro: $e');
      }
    });

    test('deve falhar ao criar uma conversão se a API retornar erro', () async {

      final conversao = Conversao(
        id: null,
        moedaOrigem: Moeda(codigo: 'USD', nome: 'Dólar'),
        moedaDestino: Moeda(codigo: 'BRL', nome: 'Real'),
        valorOriginal: 100.0,
        valorConvertido: 500.0,
      );

      final apiService = ApiService();

      final http.Response response =
          http.Response('Erro ao criar conversão', 500);

      try {
        await apiService.criarConversao(conversao);
        fail('Esperado erro ao criar conversão');
      } catch (e) {
        expect(e.toString(), contains('Falha ao criar conversão'));
      }
    });
  });
}
