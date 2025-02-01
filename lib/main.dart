import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = "";
  String _output = "";

  void _adicionarInput(String valor) {
    setState(() {
      _input += valor;
    });
  }

  void _limparTudo() {
    setState(() {
      _input = "";
      _output = "";
    });
  }

  void _calcularResultado() {
    setState(() {
      _output = _avaliarExpressao(_input);
    });
  }

  String _avaliarExpressao(String expressao) {
    try {
      // Substituir símbolos para compatibilidade
      expressao = expressao
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100');

      // Analisar expressão matemática
      Expression exp = Expression.parse(expressao);
      final evaluator = const ExpressionEvaluator();

      // Definir funções matemáticas personalizadas
      final contexto = {
        'sin': (num x) => sin(x * pi / 180), // Graus para radianos
        'cos': (num x) => cos(x * pi / 180),
        'tan': (num x) => tan(x * pi / 180),
        'pi': pi, // Suporte a π
        'e': e, // Suporte a número de Euler
      };

      var resultado = evaluator.eval(exp, contexto);
      return resultado.toString();
    } catch (e) {
      return 'Erro';
    }
  }

  Widget _buildButton(String label, {Color color = Colors.blue, Function()? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.all(20),
          ),
          onPressed: onPressed ?? () => _adicionarInput(label),
          child: Text(label, style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Flutter")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_input, style: TextStyle(fontSize: 24)),
                  Text(_output, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [...'789÷'.split('').map((e) => _buildButton(e))]),
              Row(children: [...'456×'.split('').map((e) => _buildButton(e))]),
              Row(children: [...'123-'.split('').map((e) => _buildButton(e))]),
              Row(children: [...'0.%+'.split('').map((e) => _buildButton(e))]),
              Row(
                children: [
                  _buildButton('sin', onPressed: () => _adicionarInput('sin(')),
                  _buildButton('cos', onPressed: () => _adicionarInput('cos(')),
                  _buildButton('tan', onPressed: () => _adicionarInput('tan(')),
                  _buildButton('C', color: Colors.red, onPressed: _limparTudo),
                ],
              ),
              Row(
                children: [
                  _buildButton('('),
                  _buildButton(')'),
                  _buildButton('=', color: Colors.green, onPressed: _calcularResultado),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
