import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Telalogin extends StatefulWidget {
  const Telalogin({super.key});

  @override
  State<Telalogin> createState() => _TelaloginState();
}

class _TelaloginState extends State<Telalogin> {
  bool _obscurePassword = true;
  bool _jaCadastrado = false;

  @override
  void initState() {
    super.initState();
    _verificarCadastro();
  }

  Future<void> _verificarCadastro() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _jaCadastrado = prefs.getBool('jaCadastrado') ?? false;
    });
  }

  Future<void> _salvarCadastro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('jaCadastrado', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 41, 88),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                child: Image.asset(
                  'lib/img/logogeral.png',
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(250, 255, 255, 255),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: Color.fromARGB(66, 3, 19, 118),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(66, 3, 19, 118),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 18),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(66, 2, 26, 179),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 1, 41, 88),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Só mostra o botão se ainda não cadastrou
                    if (!_jaCadastrado)
                      TextButton(
                        onPressed: () async {
                          final resultado = await Navigator.pushNamed(
                            context,
                            '/telaCadastro',
                          );
                          if (resultado == true) {
                            await _salvarCadastro();
                            setState(() {
                              _jaCadastrado = true;
                            });
                          }
                        },
                        child: const Text('Primeiro acesso? Clique aqui'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
