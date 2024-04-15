import 'package:classfrase_bloc/app_launch.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassFrase 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClassFrase 2'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Calma, vamos te explicar.',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Mudamos de endereço e estamos aperfeiçoando algumas coisas, para construirmos juntos boas classificações. ',
                style: TextStyle(
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Estamos neste novo endereço.',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  appLaunchUrl(
                    'https://classfrase.itio.net.br/',
                  );
                },
                child: const Text(
                  'classfrase.itio.net.br',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '(classfrase.b4a.app já está desativado)',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              const Text(
                '(Memorize o novo endereço)',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              const Text(
                '(Será necessário criar nova senha. Siga os passos no novo link)',
                style: TextStyle(
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                '(Obrigado pelo seu apoio e confiança.)',
                style: TextStyle(
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
