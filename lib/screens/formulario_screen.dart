import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/moeda.dart';
import '../models/conversao.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _valorController = TextEditingController();
  final ApiService apiService = ApiService();

  final List<Moeda> moedas = [
    Moeda(nome: 'Real', codigo: 'BRL'),
    Moeda(nome: 'Dólar', codigo: 'USD'),
    Moeda(nome: 'Euro', codigo: 'EUR'),
    Moeda(nome: 'Libra Esterlina', codigo: 'GBP'),
    Moeda(nome: 'Iene', codigo: 'JPY'),
    Moeda(nome: 'Kwanza', codigo: 'AOA'),
  ];

  Moeda? _moedaOrigem;
  Moeda? _moedaDestino;

  double obterTaxaConversao(Moeda origem, Moeda destino) {
    const taxasDeCambio = {
      'BRL': 1.0,
      'USD': 5.80,
      'EUR': 6.0,
      'GBP': 7.20,
      'JPY': 0.035,
      'AOA': 0.020,
    };

    double taxaOrigem = taxasDeCambio[origem.codigo] ?? 1.0;
    double taxaDestino = taxasDeCambio[destino.codigo] ?? 1.0;

    if (origem.codigo == 'BRL') {
      return taxaDestino;
    }
    if (destino.codigo == 'BRL') {
      return 1 / taxaOrigem;
    }
    return (taxaOrigem / taxaDestino);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Conversão'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButton<Moeda>(
              hint: const Text('Selecione a moeda de origem'),
              value: _moedaOrigem,
              onChanged: (moeda) {
                setState(() {
                  _moedaOrigem = moeda;
                });
              },
              items: moedas.map((moeda) {
                return DropdownMenuItem<Moeda>(
                  value: moeda,
                  child: Text(moeda.nome),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            DropdownButton<Moeda>(
              hint: const Text('Selecione a moeda de destino'),
              value: _moedaDestino,
              onChanged: (moeda) {
                setState(() {
                  _moedaDestino = moeda;
                });
              },
              items: moedas.map((moeda) {
                return DropdownMenuItem<Moeda>(
                  value: moeda,
                  child: Text(moeda.nome),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_moedaOrigem != null && _moedaDestino != null) {
                  double valorOriginal = double.tryParse(_valorController.text) ?? 0.0;
                  double taxaConversao = obterTaxaConversao(_moedaOrigem!, _moedaDestino!);
                  double valorConvertido = valorOriginal * taxaConversao;

                  String valorConvertidoFormatado = NumberFormat('##0.00').format(valorConvertido);
                  double valorConvertidoFinal = double.tryParse(valorConvertidoFormatado) ?? 0.0;

                  Conversao conversao = Conversao(
                    id: null,
                    moedaOrigem: _moedaOrigem!,
                    moedaDestino: _moedaDestino!,
                    valorOriginal: valorOriginal,
                    valorConvertido: valorConvertidoFinal,
                  );

                  apiService.criarConversao(conversao).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Conversão: $valorConvertidoFormatado')),
                    );
                    Navigator.pop(context);
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erro ao adicionar conversão')),
                    );
                  });
                }
              },
              child: const Text('Adicionar Conversão'),
            ),
          ],
        ),
      ),
    );
  }
}
