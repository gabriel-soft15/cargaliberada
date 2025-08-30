import 'package:flutter/material.dart';

class Telalogin extends StatefulWidget {
  const Telalogin({super.key});

  @override
  State<Telalogin> createState() => _TelaloginState();
}

class _TelaloginState extends State<Telalogin> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 252, 252),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ajuste esse valor conforme desejar
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 24.0),
                child: Center(
                  child: Image.asset(
                    'lib/img/logocargaliberada.png',
                    height: 300, // Tamanho menor, mais comum em apps
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(250, 255, 255, 255),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: Color.fromARGB(66, 3, 19, 118), // Cor da borda
                    width: 1.0, // Espessura da borda
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
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
                          backgroundColor: Color.fromARGB(
                            255,
                            2,
                            26,
                            179,
                          ), // Cor do botão
                          foregroundColor: Colors.white, // Cor do texto
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Não tem uma conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ); //
  }
}
