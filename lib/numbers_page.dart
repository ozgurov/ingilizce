import 'package:flutter/material.dart';
import 'services/tts_service.dart';

class NumbersPage extends StatelessWidget {
  const NumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sayı listesi - İngilizce ve Türkçe adları
    final numbersList = [
      {
        'number': 1,
        'name': 'One',
        'nameTR': 'Bir',
        'imageAsset': 'assets/images/numbers/one.png',
      },
      {
        'number': 2,
        'name': 'Two',
        'nameTR': 'İki',
        'imageAsset': 'assets/images/numbers/two.png',
      },
      {
        'number': 3,
        'name': 'Three',
        'nameTR': 'Üç',
        'imageAsset': 'assets/images/numbers/three.png',
      },
      {
        'number': 4,
        'name': 'Four',
        'nameTR': 'Dört',
        'imageAsset': 'assets/images/numbers/four.png',
      },
      {
        'number': 5,
        'name': 'Five',
        'nameTR': 'Beş',
        'imageAsset': 'assets/images/numbers/five.png',
      },
      {
        'number': 6,
        'name': 'Six',
        'nameTR': 'Altı',
        'imageAsset': 'assets/images/numbers/six.png',
      },
      {
        'number': 7,
        'name': 'Seven',
        'nameTR': 'Yedi',
        'imageAsset': 'assets/images/numbers/seven.png',
      },
      {
        'number': 8,
        'name': 'Eight',
        'nameTR': 'Sekiz',
        'imageAsset': 'assets/images/numbers/eight.png',
      },
      {
        'number': 9,
        'name': 'Nine',
        'nameTR': 'Dokuz',
        'imageAsset': 'assets/images/numbers/nine.png',
      },
      {
        'number': 10,
        'name': 'Ten',
        'nameTR': 'On',
        'imageAsset': 'assets/images/numbers/ten.png',
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Sayı görseli tüm karta yayılacak
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      number['imageAsset'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Hata durumunda sayı göster
                        return Container(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Center(
                            child: Text(
                              '${number['number']}',
                              style: TextStyle(
                                fontSize: 90, 
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Alt kısımda şeffaf gradient ve metin
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            number['name'] as String,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            number['nameTR'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            color: Colors.white,
                            onPressed: () {
                              _playNumberSound(number['name'] as String);
                            },
                          ),
                        ],
                      ),
                    ),
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
    await tts.speak(numberName);
    
    print('$numberName sesini TTS ile çal');
  }
} 