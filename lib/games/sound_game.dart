import 'package:flutter/material.dart';
import 'dart:math';
import '../services/tts_service.dart';

class SoundGame extends StatefulWidget {
  final String category;
  
  const SoundGame({super.key, required this.category});

  @override
  State<SoundGame> createState() => _SoundGameState();
}

class _SoundGameState extends State<SoundGame> {
  final TTSService _tts = TTSService();
  late List<Map<String, dynamic>> _itemList;
  late List<Map<String, dynamic>> _currentOptions;
  late Map<String, dynamic> _correctAnswer;
  bool _isLoading = true;
  int _score = 0;
  int _round = 1;
  int _maxRounds = 5;
  bool _hasAnswered = false;
  Map<String, dynamic>? _selectedAnswer;
  
  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  
  void _loadItems() {
    // Kategori seçimine göre uygun verileri yükle
    setState(() {
      _isLoading = true;
      _hasAnswered = false;
      _selectedAnswer = null;
    });
    
    switch(widget.category) {
      case 'animals':
        _itemList = [
          {'name': 'Dog', 'nameTR': 'Köpek', 'image': 'assets/images/animals/dog.png'},
          {'name': 'Cat', 'nameTR': 'Kedi', 'image': 'assets/images/animals/cat.png'},
          {'name': 'Lion', 'nameTR': 'Aslan', 'image': 'assets/images/animals/lion.png'},
          {'name': 'Elephant', 'nameTR': 'Fil', 'image': 'assets/images/animals/elephant.png'},
          {'name': 'Monkey', 'nameTR': 'Maymun', 'image': 'assets/images/animals/monkey.png'},
          {'name': 'Bird', 'nameTR': 'Kuş', 'image': 'assets/images/animals/bird.png'},
          {'name': 'Sheep', 'nameTR': 'Koyun', 'image': 'assets/images/animals/sheep.png'},
          {'name': 'Cow', 'nameTR': 'İnek', 'image': 'assets/images/animals/cow.png'},
        ];
        break;
      case 'colors':
        _itemList = [
          {'name': 'Red', 'nameTR': 'Kırmızı', 'image': 'assets/images/colors/red.png'},
          {'name': 'Blue', 'nameTR': 'Mavi', 'image': 'assets/images/colors/blue.png'},
          {'name': 'Green', 'nameTR': 'Yeşil', 'image': 'assets/images/colors/green.png'},
          {'name': 'Yellow', 'nameTR': 'Sarı', 'image': 'assets/images/colors/yellow.png'},
          {'name': 'Purple', 'nameTR': 'Mor', 'image': 'assets/images/colors/purple.png'},
          {'name': 'Orange', 'nameTR': 'Turuncu', 'image': 'assets/images/colors/orange.png'},
          {'name': 'Black', 'nameTR': 'Siyah', 'image': 'assets/images/colors/black.png'},
          {'name': 'White', 'nameTR': 'Beyaz', 'image': 'assets/images/colors/white.png'},
        ];
        break;
      case 'numbers':
        _itemList = [
          {'name': 'One', 'nameTR': 'Bir', 'number': 1, 'image': 'assets/images/numbers/one.png'},
          {'name': 'Two', 'nameTR': 'İki', 'number': 2, 'image': 'assets/images/numbers/two.png'},
          {'name': 'Three', 'nameTR': 'Üç', 'number': 3, 'image': 'assets/images/numbers/three.png'},
          {'name': 'Four', 'nameTR': 'Dört', 'number': 4, 'image': 'assets/images/numbers/four.png'},
          {'name': 'Five', 'nameTR': 'Beş', 'number': 5, 'image': 'assets/images/numbers/five.png'},
          {'name': 'Six', 'nameTR': 'Altı', 'number': 6, 'image': 'assets/images/numbers/six.png'},
          {'name': 'Seven', 'nameTR': 'Yedi', 'number': 7, 'image': 'assets/images/numbers/seven.png'},
          {'name': 'Eight', 'nameTR': 'Sekiz', 'number': 8, 'image': 'assets/images/numbers/eight.png'},
        ];
        break;
      default:
        _itemList = [];
    }
    
    _setupQuestion();
  }
  
  void _setupQuestion() {
    // Resim listesini karıştır
    final shuffledItems = List<Map<String, dynamic>>.from(_itemList)..shuffle();
    
    // 3 farklı seçenek oluştur
    _currentOptions = shuffledItems.take(3).toList();
    
    // Doğru cevabı belirle (rastgele)
    final random = Random();
    _correctAnswer = _currentOptions[random.nextInt(_currentOptions.length)];
    
    setState(() {
      _isLoading = false;
      _hasAnswered = false;
      _selectedAnswer = null;
    });
    
    // 1 saniye bekledikten sonra sesi çal
    Future.delayed(const Duration(milliseconds: 1000), () {
      _playQuestionSound();
    });
  }
  
  void _playQuestionSound() {
    _tts.speakEnglish(_correctAnswer['name']);
  }
  
  void _checkAnswer(Map<String, dynamic> selectedAnswer) {
    setState(() {
      _selectedAnswer = selectedAnswer;
      _hasAnswered = true;
    });
    
    final bool isCorrect = selectedAnswer['name'] == _correctAnswer['name'];
    
    if (isCorrect) {
      // Doğru cevap
      setState(() {
        _score += 10;
      });
      
      // Başarı bildirimi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doğru!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // Yanlış cevap
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yanlış! Doğru cevap: ${_correctAnswer['name']}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    
    // Sonraki soruya geç veya oyunu bitir
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_round < _maxRounds) {
        setState(() {
          _round++;
        });
        _setupQuestion();
      } else {
        _showGameOver();
      }
    });
  }
  
  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Oyun Bitti!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tebrikler, oyunu tamamladın!'),
            const SizedBox(height: 16),
            Text('Puanın: $_score / ${_maxRounds * 10}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Oyunu yeniden başlat
              setState(() {
                _score = 0;
                _round = 1;
              });
              _loadItems();
            },
            child: const Text('Yeniden Oyna'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doğru Sesi Seç - ${widget.category.capitalize()}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Puan: $_score',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Soru: $_round / $_maxRounds',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Sesi tekrar çalma butonu
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    const Text(
                      'Duyduğun sesin resmini bul',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _playQuestionSound,
                      icon: const Icon(Icons.volume_up, size: 32),
                      label: const Text(
                        'Sesi Tekrar Dinle',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Seçenekler
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _currentOptions.length,
                    itemBuilder: (context, index) {
                      final option = _currentOptions[index];
                      final bool isSelected = _selectedAnswer == option;
                      final bool isCorrect = _hasAnswered && option['name'] == _correctAnswer['name'];
                      final bool isWrong = _hasAnswered && isSelected && !isCorrect;
                      
                      return Card(
                        elevation: isSelected ? 8 : 4,
                        color: isCorrect 
                          ? Colors.green.shade100 
                          : (isWrong ? Colors.red.shade100 : null),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: isCorrect
                            ? const BorderSide(color: Colors.green, width: 3)
                            : (isWrong 
                                ? const BorderSide(color: Colors.red, width: 3)
                                : BorderSide.none),
                        ),
                        child: InkWell(
                          onTap: _hasAnswered ? null : () => _checkAnswer(option),
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    option['image'],
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Resim yüklenemediğinde yerine metin göster
                                      return Container(
                                        color: Colors.grey.shade200,
                                        child: Center(
                                          child: Text(
                                            option['name'],
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (_hasAnswered)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    option['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

// String extension metodu
extension StringExtension on String {
  String capitalize() {
    return isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  }
} 