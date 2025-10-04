import 'package:flutter/material.dart';

// NOVO: Criei uma página de destino simples para onde o usuário irá após o login.
// Você pode substituir isso pela sua tela principal (HomePage).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        backgroundColor: const Color.fromARGB(255, 1, 41, 88),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Login realizado com sucesso!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class Telalogin extends StatefulWidget {
  const Telalogin({super.key}); // chave para estar validando

  @override
  State<Telalogin> createState() => _TelaloginState(); // inicializa o estado
}

class _TelaloginState extends State<Telalogin> {
  // Esta variável agora controla se a tela está em modo 'Login' ou 'Cadastro'
  bool isSingUp = false;
  bool _obscurePassword = true;
  bool _submitting = false;

  // variaveis de controle
  final _formKey = GlobalKey<FormState>();
  final _nameCrtl = TextEditingController();
  final _emailCrtl = TextEditingController();
  final _senhaCrtl = TextEditingController();

  @override
  // limpa as informações
  void dispose() {
    _nameCrtl.dispose();
    _emailCrtl.dispose();
    _senhaCrtl.dispose();
    super.dispose();
  }

  // Validador de nome (usado apenas no cadastro)
  String? _validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    if (value.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um email';
    }
    // Usei a validação do seu amigo, que é um pouco mais completa
    final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null; // Retorna null se o email for válido
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null; // Retorna null se a senha for válida
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    FocusScope.of(context).unfocus(); // Fecha o teclado
    setState(() => _submitting = true);

    try {
      // Simula uma espera de rede (ex: chamada para API, Firebase, etc.)
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      final mode = isSingUp ? 'Cadastro' : 'Login';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[700],
          content: Text('$mode realizado com sucesso!'),
        ),
      );

      // Navega para a HomePage após o sucesso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Falha ao autenticar. Tente novamente mais tarde.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 41, 88),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/img/logogeral.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(250, 255, 255, 255),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // LÓGICA PRINCIPAL: Campo de nome que só aparece se for cadastro
                        if (isSingUp)
                          TextFormField(
                            controller: _nameCrtl,
                            decoration: const InputDecoration(
                              labelText: 'Nome Completo',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(66, 3, 19, 118),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            validator: _validarNome,
                          ),
                        if (isSingUp) const SizedBox(height: 18),

                        TextFormField(
                          controller: _emailCrtl,
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
                          validator: _validarEmail,
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _senhaCrtl,
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
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          keyboardType: TextInputType.text,
                          validator: _validarSenha,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                1,
                                41,
                                88,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            // LÓGICA PRINCIPAL: O texto do botão muda
                            child: _submitting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isSingUp ? 'Cadastrar' : 'Entrar',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          // LÓGICA PRINCIPAL: Inverte o modo da tela
                          onPressed: () {
                            setState(() {
                              isSingUp = !isSingUp;
                            });
                          },
                          // LÓGICA PRINCIPAL: O texto do link também muda
                          child: Text(
                            isSingUp
                                ? 'Já tem uma conta? Entre aqui'
                                : 'Primeiro acesso? Cadastre-se',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
