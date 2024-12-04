import 'moeda.dart';

class Conversao {
  final String? id;
  final Moeda moedaOrigem;
  final Moeda moedaDestino;
  final double valorOriginal;
  final double valorConvertido;

  Conversao({
    this.id,
    required this.moedaOrigem,
    required this.moedaDestino,
    required this.valorOriginal,
    required this.valorConvertido,
  });

  factory Conversao.fromJson(Map<String, dynamic> json) {
    return Conversao(
      id: json[
          'id'],
      moedaOrigem:
          Moeda(codigo: json['moedaOrigem'], nome: json['moedaOrigem']),
      moedaDestino:
          Moeda(codigo: json['moedaDestino'], nome: json['moedaDestino']),
      valorOriginal: json['valorOriginal'].toDouble(),
      valorConvertido: json['valorConvertido'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moedaOrigem': moedaOrigem.codigo,
      'moedaDestino': moedaDestino.codigo,
      'valorOriginal': valorOriginal,
      'valorConvertido': valorConvertido,
    };
  }
}
