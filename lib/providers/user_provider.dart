import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _nome;
  int? _idade;
  String? _cidade;
  String? _observacao;

  String? get nome => _nome;
  int? get idade => _idade;
  String? get cidade => _cidade;
  String? get observacao => _observacao;

  Future<void> gravarNome(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome_usuario', nome);
    _nome = nome;
    notifyListeners();
  }

  void setIdade(int idade) {
    _idade = idade;
    notifyListeners();
  }

  void setDetalhes(String cidade, String observacao) {
    _cidade = cidade;
    _observacao = observacao;
    notifyListeners();
  }
}