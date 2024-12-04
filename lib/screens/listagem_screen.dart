import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/conversao.dart';

class ListagemScreen extends StatefulWidget {
  const ListagemScreen({super.key});

  @override
  _ListagemScreenState createState() => _ListagemScreenState();
}

class _ListagemScreenState extends State<ListagemScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Conversao>> conversoes;

  @override
  void initState() {
    super.initState();
    conversoes = apiService.obterConversoes();
  }

  void _deletarConversao(String id) {
    apiService.deletarConversao(id).then((_) {
      setState(() {
        conversoes = apiService.obterConversoes();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conversão deletada')));
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao deletar')));
    });
  }

  void _editarConversao(Conversao conversao) {
    final updatedConversao = Conversao(
      id: conversao.id,
      moedaOrigem: conversao.moedaOrigem,
      moedaDestino: conversao.moedaDestino,
      valorOriginal: conversao.valorOriginal + 10,
      valorConvertido: conversao.valorConvertido + 1,
    );

    apiService.editarConversao(updatedConversao).then((_) {
      setState(() {
        conversoes = apiService.obterConversoes();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conversão editada')));
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao editar')));
    });
  }

  void _showEditDialog(Conversao conversao) {
    final valorOriginalController = TextEditingController(text: conversao.valorOriginal.toString());
    final valorConvertidoController = TextEditingController(text: conversao.valorConvertido.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Conversão'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: valorOriginalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor Original'),
              ),
              TextField(
                controller: valorConvertidoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor Convertido'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final updatedConversao = Conversao(
                  id: conversao.id,
                  moedaOrigem: conversao.moedaOrigem,
                  moedaDestino: conversao.moedaDestino,
                  valorOriginal: double.parse(valorOriginalController.text),
                  valorConvertido: double.parse(valorConvertidoController.text),
                );

                apiService.editarConversao(updatedConversao).then((_) {
                  setState(() {
                    conversoes = apiService.obterConversoes();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conversão editada')));
                  Navigator.of(context).pop();
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao editar')));
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversões Realizadas'),
      ),
      body: FutureBuilder<List<Conversao>>(
        future: conversoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma conversão realizada.'));
          } else {
            final List<Conversao> conversoesList = snapshot.data!;
            return ListView.builder(
              itemCount: conversoesList.length,
              itemBuilder: (context, index) {
                Conversao conversao = conversoesList[index];
                return ListTile(
                  title: Text('${conversao.valorOriginal} ${conversao.moedaOrigem.nome} para ${conversao.valorConvertido} ${conversao.moedaDestino.nome}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(conversao),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletarConversao(conversao.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
