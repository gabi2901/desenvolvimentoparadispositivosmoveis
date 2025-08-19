import 'package:flutter/material.dart';

class FlagGameScreen extends StatefulWidget {
  final String nome;
  final String idade;

  const FlagGameScreen({
    super.key,
    required this.nome,
    required this.idade,
  });

  @override
  State<FlagGameScreen> createState() => _FlagGameScreenState();
}

class _FlagGameScreenState extends State<FlagGameScreen> {
  int pontuacao = 0;
  int perguntaAtual = 0;
  String? respostaSelecionada;

  final List<Map<String, dynamic>> perguntas = [
    {'bandeira': 'assets/images/alagoas.png', 'respostaCorreta': 'Alagoas'},
    {'bandeira': 'assets/images/amapa.svg', 'respostaCorreta': 'Amapá'},
    {'bandeira': 'assets/images/amazonas.png', 'respostaCorreta': 'Amazonas'},
    {'bandeira': 'assets/images/bahia.svg', 'respostaCorreta': 'Bahia'},
    {'bandeira': 'assets/images/ceara.png', 'respostaCorreta': 'Ceará'},
    {'bandeira': 'assets/images/df.png', 'respostaCorreta': 'Distrito Federal'},
    {'bandeira': 'assets/images/es.png', 'respostaCorreta': 'Espírito Santo'},
    {'bandeira': 'assets/images/goiais.png', 'respostaCorreta': 'Goiás'},
    {'bandeira': 'assets/images/maranhao.png', 'respostaCorreta': 'Maranhão'},
    {'bandeira': 'assets/images/matogrosso.png', 'respostaCorreta': 'Mato Grosso'},
    {'bandeira': 'assets/images/mtogrossosul.jpg', 'respostaCorreta': 'Mato Grosso do Sul'},
    {'bandeira': 'assets/images/acre.png', 'respostaCorreta': 'Rondônia'}, // ajuste caso 'ocortico' esteja errado
    {'bandeira': 'assets/images/para.png', 'respostaCorreta': 'Pará'},
    {'bandeira': 'assets/images/paraiba.png', 'respostaCorreta': 'Paraíba'},
    {'bandeira': 'assets/images/parana.png', 'respostaCorreta': 'Paraná'},
    {'bandeira': 'assets/images/pernambuco.png', 'respostaCorreta': 'Pernambuco'},
    {'bandeira': 'assets/images/piaui.png', 'respostaCorreta': 'Piauí'},
    {'bandeira': 'assets/images/riograndedonorte.png', 'respostaCorreta': 'Rio Grande do Norte'},
    {'bandeira': 'assets/images/riograndesul.png', 'respostaCorreta': 'Rio Grande do Sul'},
    {'bandeira': 'assets/images/rj.png', 'respostaCorreta': 'Rio de Janeiro'},
    {'bandeira': 'assets/images/rondonia.png', 'respostaCorreta': 'Rondônia'},
    {'bandeira': 'assets/images/roraima.png', 'respostaCorreta': 'Roraima'},
    {'bandeira': 'assets/images/sc.png', 'respostaCorreta': 'Santa Catarina'},
    {'bandeira': 'assets/images/sergipe.png', 'respostaCorreta': 'Sergipe'},
    {'bandeira': 'assets/images/sp.png', 'respostaCorreta': 'São Paulo'},
    {'bandeira': 'assets/images/tocantins.png', 'respostaCorreta': 'Tocantins'},
  ].map((map) {
    List<String> op = perguntasSimples.map((e) => e['respostaCorreta'] as String).toList();
    op.shuffle();
    return {...map, 'opcoes': op.take(4).toList()};
  }).toList();

  // lista completa para gerar opções variadas
  static List<Map<String, dynamic>> perguntasSimples = [
    {'respostaCorreta': 'Alagoas'},
    {'respostaCorreta': 'Amapá'},
    {'respostaCorreta': 'Amazonas'},
    {'respostaCorreta': 'Bahia'},
    {'respostaCorreta': 'Ceará'},
    {'respostaCorreta': 'Distrito Federal'},
    {'respostaCorreta': 'Espírito Santo'},
    {'respostaCorreta': 'Goiás'},
    {'respostaCorreta': 'Maranhão'},
    {'respostaCorreta': 'Mato Grosso'},
    {'respostaCorreta': 'Mato Grosso do Sul'},
    {'respostaCorreta': 'Pará'},
    {'respostaCorreta': 'Paraíba'},
    {'respostaCorreta': 'Paraná'},
    {'respostaCorreta': 'Pernambuco'},
    {'respostaCorreta': 'Piauí'},
    {'respostaCorreta': 'Rio Grande do Norte'},
    {'respostaCorreta': 'Rio Grande do Sul'},
    {'respostaCorreta': 'Rio de Janeiro'},
    {'respostaCorreta': 'Rondônia'},
    {'respostaCorreta': 'Roraima'},
    {'respostaCorreta': 'Santa Catarina'},
    {'respostaCorreta': 'Sergipe'},
    {'respostaCorreta': 'São Paulo'},
    {'respostaCorreta': 'Tocantins'},
  ];

  void verificarResposta(String resposta) {
    setState(() {
      respostaSelecionada = resposta;
      final correta = perguntas[perguntaAtual]['respostaCorreta'] as String;
      if (resposta == correta) pontuacao++;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (perguntaAtual < perguntas.length - 1) {
        setState(() {
          perguntaAtual++;
          respostaSelecionada = null;
        });
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/result',
          arguments: {
            'nome': widget.nome,
            'idade': widget.idade,
            'pontuacao': pontuacao,
            'total': perguntas.length,
          },
        );
      }
    });
  }

  Color? _getCorBotao(String resposta, String correta) {
    if (respostaSelecionada == null) return null;
    if (resposta == correta) return Colors.green;
    if (resposta == respostaSelecionada) return Colors.red;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pergunta = perguntas[perguntaAtual];
    final correta = pergunta['respostaCorreta'] as String;

    return Scaffold(
      appBar: AppBar(title: Text('Olá, ${widget.nome}!')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Qual estado é essa bandeira?', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Image.asset(pergunta['bandeira'], height: 180),
            const SizedBox(height: 24),
            Column(
              children: List.generate(pergunta['opcoes'].length, (i) {
                final opcao = pergunta['opcoes'][i] as String;
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _getCorBotao(opcao, correta)),
                    onPressed: respostaSelecionada == null ? () => verificarResposta(opcao) : null,
                    child: Text(opcao),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
