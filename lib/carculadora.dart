import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'Limpar';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularResultado() {
    try {
      String expressaoModificada = _expressao
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100');

      final expression = Expression.parse(expressaoModificada);
      const evaluator = ExpressionEvaluator();

      final contexto = {
        'sin': (num x) => sin(x.toDouble()),
        'cos': (num x) => cos(x.toDouble()),
        'tan': (num x) => tan(x.toDouble()),
      };

      var resultado = evaluator.eval(expression, contexto);
      _resultado = resultado.toString();
    } catch (e) {
      _resultado = 'Erro na expressão';
    }
  }

  Widget _botao(String valor) {
    return TextButton(
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('×'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('0'),
              _botao('.'),
              _botao('%'),
              _botao('+'),
              _botao('sin('),
              _botao('cos('),
              _botao('tan('),
              _botao(')'),
              _botao('='),
            ],
          ),
        ),
        Expanded(
          child: _botao(_limpar),
        )
      ],
    );
  }
}
