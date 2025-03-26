import 'package:flutter/material.dart';
import 'services/tts_service.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hayvan listesi - İngilizce ve Türkçe adları
    final animalsList = [
      {
        'name': 'Dog',
        'nameTR': 'Köpek',
        'imageAsset': 'assets/images/animals/dog.png',
        'sound': 'assets/sounds/dog.mp3',
      },
      {
        'name': 'Cat',
        'nameTR': 'Kedi',
        'imageAsset': 'assets/images/animals/cat.png',
        'sound': 'assets/sounds/cat.mp3',
      },
      {
        'name': 'Elephant',
        'nameTR': 'Fil',
        'imageAsset': 'assets/images/animals/elephant.png',
        'sound': 'assets/sounds/elephant.mp3',
      },
      {
        'name': 'Lion',
        'nameTR': 'Aslan',
        'imageAsset': 'assets/images/animals/lion.png',
        'sound': 'assets/sounds/lion.mp3',
      },
      {
        'name': 'Monkey',
        'nameTR': 'Maymun',
        'imageAsset': 'assets/images/animals/monkey.png',
        'sound': 'assets/sounds/monkey.mp3',
      },
      {
        'name': 'Bird',
        'nameTR': 'Kuş',
        'imageAsset': 'assets/images/animals/bird.png',
        'sound': 'assets/sounds/bird.mp3',
      },
      {
        'name': 'Fish',
        'nameTR': 'Balık',
        'imageAsset': 'assets/images/animals/fish.png',
        'sound': 'assets/sounds/fish.mp3',
      },
      {
        'name': 'Cow',
        'nameTR': 'İnek',
        'imageAsset': 'assets/images/animals/cow.png',
        'sound': 'assets/sounds/cow.mp3',
      },
      {
        'name': 'Horse',
        'nameTR': 'At',
        'imageAsset': 'assets/images/animals/horse.png',
        'sound': 'assets/sounds/horse.mp3',
      },
      {
        'name': 'Sheep',
        'nameTR': 'Koyun',
        'imageAsset': 'assets/images/animals/sheep.png',
        'sound': 'assets/sounds/sheep.mp3',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hayvanlar - Animals'),
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
        itemCount: animalsList.length,
        itemBuilder: (context, index) {
          final animal = animalsList[index];
          
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                _playAnimalSound(animal['name'] as String);
              },
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Hayvan görseli tüm karta yayılacak
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      animal['imageAsset'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Hata durumunda simge göster
                        return Container(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.pets,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary,
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
                            animal['name'] as String,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            animal['nameTR'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            color: Colors.white,
                            onPressed: () {
                              _playAnimalSound(animal['name'] as String);
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
  void _playAnimalSound(String animalName) async {
    // TTS servisini kullanarak hayvan adını seslendir
    final tts = TTSService();
    await tts.speak(animalName);
    
    print('$animalName sesini TTS ile çal');
  }
} 