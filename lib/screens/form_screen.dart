import 'package:flutter/material.dart';
import 'flag_game_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();

  void _comecarJogo() {
    String nome = _nomeController.text;
    String idade = _idadeController.text;

    if (nome.isEmpty || idade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome e idade!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlagGameScreen(nome: nome, idade: idade),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz de Bandeiras')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AQUI ESTÁ A LOGO
            Image.asset(
              'assets/images/logo2.png', // ajuste conforme o seu caminho
              height: 400,
            ),
            const SizedBox(height: 24),

            // Campos de texto
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Idade'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Cor de fundo do botão
                  foregroundColor: Colors.white, // Cor do texto e ícones
               ),
              onPressed: _comecarJogo,
              child: const Text('Começar'),
            ),
          ],
        ),
      ),
    );
  }
}