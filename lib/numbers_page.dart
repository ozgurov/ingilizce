import 'package:flutter/material.dart';
import 'services/tts_service.dart';

class NumbersPage extends StatelessWidget {
  const NumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sayı listesi - İngilizce ve Türkçe adları
    final numbersList = [
      {
        'name': 'One',
        'nameTR': 'Bir',
        'number': 1,
      },
      {
        'name': 'Two',
        'nameTR': 'İki',
        'number': 2,
      },
      {
        'name': 'Three',
        'nameTR': 'Üç',
        'number': 3,
      },
      {
        'name': 'Four',
        'nameTR': 'Dört',
        'number': 4,
      },
      {
        'name': 'Five',
        'nameTR': 'Beş',
        'number': 5,
      },
      {
        'name': 'Six',
        'nameTR': 'Altı',
        'number': 6,
      },
      {
        'name': 'Seven',
        'nameTR': 'Yedi',
        'number': 7,
      },
      {
        'name': 'Eight',
        'nameTR': 'Sekiz',
        'number': 8,
      },
      {
        'name': 'Nine',
        'nameTR': 'Dokuz',
        'number': 9,
      },
      {
        'name': 'Ten',
        'nameTR': 'On',
        'number': 10,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayılar - Numbers'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: numbersList.length,
        itemBuilder: (context, index) {
          final number = numbersList[index];
          
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                _playNumberSound(number['name'] as String);
              },
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sayı gösterimi için container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (number['number'] as int).toString(),
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    number['name'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    number['nameTR'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      _playNumberSound(number['name'] as String);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Ses çalma fonksiyonu - TTS kullanarak
  void _playNumberSound(String numberName) async {
    // TTS servisini kullanarak sayı adını seslendir
    final tts = TTSService();
    await tts.speakEnglish(numberName);
    
    print('$numberName sesini TTS ile çal');
  }
} 