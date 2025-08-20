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
  int nivel = 1; // Começa no nível 1

  late List<Map<String, dynamic>> perguntas;

  // Lista completa de estados
  static final List<String> todosEstados = [
    'Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Bahia', 'Ceará',
    'Distrito Federal', 'Espírito Santo', 'Goiás', 'Maranhão',
    'Mato Grosso', 'Mato Grosso do Sul', 'Pará', 'Paraíba', 'Paraná',
    'Pernambuco', 'Piauí', 'Rio Grande do Norte', 'Rio Grande do Sul',
    'Rio de Janeiro', 'Rondônia', 'Roraima', 'Santa Catarina', 'Sergipe',
    'São Paulo', 'Tocantins', 'Minas Gerais'
  ];

  @override
  void initState() {
    super.initState();
    perguntas = _buildPerguntasNivel1();
  }

  // ---------------- LISTAS DE PERGUNTAS ----------------
  static List<Map<String, dynamic>> _buildPerguntasNivel1() {
    final base = [
      {'bandeira': 'assets/images/alagoas.png', 'respostaCorreta': 'Alagoas'},
      {'bandeira': 'assets/images/amazonas.png', 'respostaCorreta': 'Amazonas'},
      {'bandeira': 'assets/images/bahia.png', 'respostaCorreta': 'Bahia'},
      {'bandeira': 'assets/images/ceara.png', 'respostaCorreta': 'Ceará'},
      {'bandeira': 'assets/images/df.png', 'respostaCorreta': 'Distrito Federal'},
      {'bandeira': 'assets/images/goiais.png', 'respostaCorreta': 'Goiás'},
      {'bandeira': 'assets/images/maranhao.png', 'respostaCorreta': 'Maranhão'},
      {'bandeira': 'assets/images/matogrosso.png', 'respostaCorreta': 'Mato Grosso'},
      {'bandeira': 'assets/images/para.png', 'respostaCorreta': 'Pará'},
      {'bandeira': 'assets/images/parana.png', 'respostaCorreta': 'Paraná'},
    ];

    return _gerarOpcoes(base);
  }

  static List<Map<String, dynamic>> _buildPerguntasNivel2() {
    final base = [
      {'bandeira': 'assets/images/mtgrossosul.png', 'respostaCorreta': 'Mato Grosso do Sul'},
      {'bandeira': 'assets/images/acre.png', 'respostaCorreta': 'Acre'},
      {'bandeira': 'assets/images/paraiba.png', 'respostaCorreta': 'Paraíba'},
      {'bandeira': 'assets/images/pernambuco.png', 'respostaCorreta': 'Pernambuco'},
      {'bandeira': 'assets/images/piaui.png', 'respostaCorreta': 'Piauí'},
      {'bandeira': 'assets/images/riograndenorte.png', 'respostaCorreta': 'Rio Grande do Norte'},
      {'bandeira': 'assets/images/riograndesul.png', 'respostaCorreta': 'Rio Grande do Sul'},
      {'bandeira': 'assets/images/rj.png', 'respostaCorreta': 'Rio de Janeiro'},
      {'bandeira': 'assets/images/rondonia.png', 'respostaCorreta': 'Rondônia'},
      {'bandeira': 'assets/images/roraima.png', 'respostaCorreta': 'Roraima'},
      {'bandeira': 'assets/images/sc.png', 'respostaCorreta': 'Santa Catarina'},
      {'bandeira': 'assets/images/sergipe.png', 'respostaCorreta': 'Sergipe'},
      {'bandeira': 'assets/images/sp.png', 'respostaCorreta': 'São Paulo'},
      {'bandeira': 'assets/images/tocantins.png', 'respostaCorreta': 'Tocantins'},
      {'bandeira': 'assets/images/mg.png', 'respostaCorreta': 'Minas Gerais'},
      {'bandeira': 'assets/images/es.png', 'respostaCorreta': ' Espírito Santo'},
      {'bandeira': 'assets/images/amapa.png', 'respostaCorreta': 'Amapá'},
    ];

    return _gerarOpcoes(base);
  }

  // Função que gera 4 opções (1 correta + 3 aleatórias)
  static List<Map<String, dynamic>> _gerarOpcoes(List<Map<String, dynamic>> base) {
    final resultado = <Map<String, dynamic>>[];

    for (final q in base) {
      final correta = q['respostaCorreta'] as String;
      final candidatos = List<String>.from(todosEstados)..remove(correta);
      candidatos.shuffle();
      final opcoes = [correta, ...candidatos.take(3)].toList()..shuffle();

      resultado.add({
        'bandeira': q['bandeira'],
        'respostaCorreta': correta,
        'opcoes': opcoes,
      });
    }

    resultado.shuffle();
    return resultado;
  }

  // ----------------- LÓGICA DO JOGO -------------------
  void verificarResposta(String resposta) {
    setState(() {
      respostaSelecionada = resposta;
      final correta = perguntas[perguntaAtual]['respostaCorreta'] as String;
      if (resposta == correta) pontuacao++;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (perguntaAtual < perguntas.length - 1) {
        setState(() {
          perguntaAtual++;
          respostaSelecionada = null;
        });
      } else {
        // Fim do nível
        mostrarResumoNivel();
      }
    });
  }

  void mostrarResumoNivel() {
    final erros = perguntas.length - pontuacao;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Fim do Nível $nivel"),
        content: Text(
          "Acertos: $pontuacao\nErros: $erros",
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          if (nivel == 1)
            TextButton(
              onPressed: () {
                setState(() {
                  nivel = 2;
                  perguntas = _buildPerguntasNivel2();
                  perguntaAtual = 0;
                  pontuacao = 0;
                  respostaSelecionada = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Ir para Nível 2"),
            ),
          TextButton(
            onPressed: () {
              setState(() {
                perguntas = (nivel == 1)
                    ? _buildPerguntasNivel1()
                    : _buildPerguntasNivel2();
                perguntaAtual = 0;
                pontuacao = 0;
                respostaSelecionada = null;
              });
              Navigator.pop(context);
            },
            child: const Text("Reiniciar nível"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Sai do jogo
            },
            child: const Text("Sair"),
          ),
        ],
      ),
    );
  }

  Color? _getCorBotao(String resposta, String correta) {
    if (respostaSelecionada == null) return null;
    if (resposta == correta) return Colors.green;
    if (resposta == respostaSelecionada) return Colors.red;
    return null;
  }

  Widget _buildFlag(String path) {
    return Image.asset(path, height: 180);
  }

  // ---------------- INTERFACE ----------------
  @override
  Widget build(BuildContext context) {
    final pergunta = perguntas[perguntaAtual];
    final correta = pergunta['respostaCorreta'] as String;
    final opcoes = pergunta['opcoes'] as List<String>;
return Scaffold(
 appBar: AppBar(
  leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Image.asset(
      'assets/images/logo2.png',
      height: 100, // altura da logo
      width: 70,  // largura da logo
      fit: BoxFit.contain, // mantém proporção
    ),
  ),
  title: Text('Olá, ${widget.nome}! - Nível $nivel'),
),

  body: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        const Text('Qual estado é essa bandeira?', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 16),
        _buildFlag(pergunta['bandeira'] as String),
        const SizedBox(height: 24),
        Column(
          children: opcoes.map((opcao) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    _getCorBotao(opcao, correta) ?? Colors.grey,
                  ),
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 50),
                  ),
                ),
                onPressed: respostaSelecionada == null
                    ? () => verificarResposta(opcao)
                    : null,
                child: Text(opcao, style: const TextStyle(fontSize: 18)),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  ),
);

  }
}
