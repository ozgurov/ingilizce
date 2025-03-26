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
      },
      {
        'name': 'Blue',
        'nameTR': 'Mavi',
        'color': Colors.blue,
      },
      {
        'name': 'Green',
        'nameTR': 'Yeşil',
        'color': Colors.green,
      },
      {
        'name': 'Yellow',
        'nameTR': 'Sarı',
        'color': Colors.yellow,
      },
      {
        'name': 'Purple',
        'nameTR': 'Mor',
        'color': Colors.purple,
      },
      {
        'name': 'Orange',
        'nameTR': 'Turuncu',
        'color': Colors.orange,
      },
      {
        'name': 'Pink',
        'nameTR': 'Pembe',
        'color': Colors.pink,
      },
      {
        'name': 'Brown',
        'nameTR': 'Kahverengi',
        'color': Colors.brown,
      },
      {
        'name': 'Black',
        'nameTR': 'Siyah',
        'color': Colors.black,
      },
      {
        'name': 'White',
        'nameTR': 'Beyaz',
        'color': Colors.white,
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
              child: Container(
                decoration: BoxDecoration(
                  color: color['color'] as Color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Metin bilgileri için yarı-saydam arka plan
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            color['name'] as String,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: (color['color'] as Color).computeLuminance() > 0.5 ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            color['nameTR'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              color: (color['color'] as Color).computeLuminance() > 0.5 ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      color: (color['color'] as Color).computeLuminance() > 0.5 ? Colors.black : Colors.white,
                      onPressed: () {
                        _playColorSound(color['name'] as String);
                      },
                    ),
                  ],
                ),
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
    await tts.speakEnglish(colorName);
    
    print('$colorName sesini TTS ile çal');
  }
} 