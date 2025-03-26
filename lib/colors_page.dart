import 'package:flutter/material.dart';
import 'services/tts_service.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Renk listesi - İngilizce ve Türkçe adları
    final colorsList = [
      {
        'name': 'Red',
        'nameTR': 'Kırmızı',
        'color': Colors.red,
        'imageAsset': 'assets/images/colors/red.png',
      },
      {
        'name': 'Blue',
        'nameTR': 'Mavi',
        'color': Colors.blue,
        'imageAsset': 'assets/images/colors/blue.png',
      },
      {
        'name': 'Green',
        'nameTR': 'Yeşil',
        'color': Colors.green,
        'imageAsset': 'assets/images/colors/green.png',
      },
      {
        'name': 'Yellow',
        'nameTR': 'Sarı',
        'color': Colors.yellow,
        'imageAsset': 'assets/images/colors/yellow.png',
      },
      {
        'name': 'Purple',
        'nameTR': 'Mor',
        'color': Colors.purple,
        'imageAsset': 'assets/images/colors/purple.png',
      },
      {
        'name': 'Orange',
        'nameTR': 'Turuncu',
        'color': Colors.orange,
        'imageAsset': 'assets/images/colors/orange.png',
      },
      {
        'name': 'Pink',
        'nameTR': 'Pembe',
        'color': Colors.pink,
        'imageAsset': 'assets/images/colors/pink.png',
      },
      {
        'name': 'Brown',
        'nameTR': 'Kahverengi',
        'color': Colors.brown,
        'imageAsset': 'assets/images/colors/brown.png',
      },
      {
        'name': 'Black',
        'nameTR': 'Siyah',
        'color': Colors.black,
        'imageAsset': 'assets/images/colors/black.png',
      },
      {
        'name': 'White',
        'nameTR': 'Beyaz',
        'color': Colors.white,
        'imageAsset': 'assets/images/colors/white.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renkler - Colors'),
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
        itemCount: colorsList.length,
        itemBuilder: (context, index) {
          final color = colorsList[index];
          
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                _playColorSound(color['name'] as String);
              },
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Renk görseli tüm karta yayılacak
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      color['imageAsset'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Hata durumunda sadece renk göster
                        return Container(
                          color: color['color'] as Color,
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
                            color['name'] as String,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            color['nameTR'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            color: Colors.white,
                            onPressed: () {
                              _playColorSound(color['name'] as String);
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
  void _playColorSound(String colorName) async {
    // TTS servisini kullanarak renk adını seslendir
    final tts = TTSService();
    await tts.speak(colorName);
    
    print('$colorName sesini TTS ile çal');
  }
} 