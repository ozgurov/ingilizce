import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../services/tts_service.dart';

class MemoryGame extends StatefulWidget {
  final String category;
  
  const MemoryGame({super.key, required this.category});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final TTSService _tts = TTSService();
  late List<Map<String, dynamic>> _itemList;
  late List<Map<String, dynamic>> _gameCards;
  bool _isLoading = true;
  int _score = 0;
  int _attempts = 0;
  
  // Hafıza oyunu için seçilen kartlar
  Map<String, dynamic>? _firstCard;
  Map<String, dynamic>? _secondCard;
  bool _isCheckingMatch = false;
  bool _gameCompleted = false;
  
  // Zamanlayıcı
  int _timeInSeconds = 0;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timeInSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeInSeconds++;
      });
    });
  }
  
  void _stopTimer() {
    _timer?.cancel();
  }
  
  void _loadItems() {
    // Kategori seçimine göre uygun verileri yükle
    setState(() {
      _isLoading = true;
      _firstCard = null;
      _secondCard = null;
      _isCheckingMatch = false;
      _score = 0;
      _attempts = 0;
      _gameCompleted = false;
    });
    
    // Seçilen kategoriye göre liste oluştur
    switch(widget.category) {
      case 'animals':
        _itemList = [
          {'name': 'Dog', 'nameTR': 'Köpek', 'image': 'assets/images/animals/dog.png'},
          {'name': 'Cat', 'nameTR': 'Kedi', 'image': 'assets/images/animals/cat.png'},
          {'name': 'Lion', 'nameTR': 'Aslan', 'image': 'assets/images/animals/lion.png'},
          {'name': 'Elephant', 'nameTR': 'Fil', 'image': 'assets/images/animals/elephant.png'},
          {'name': 'Monkey', 'nameTR': 'Maymun', 'image': 'assets/images/animals/monkey.png'},
          {'name': 'Bird', 'nameTR': 'Kuş', 'image': 'assets/images/animals/bird.png'},
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
        ];
        break;
      default:
        _itemList = [];
    }
    
    // Oyun için 4 öğe seç
    final random = Random();
    final selectedItems = <Map<String, dynamic>>[];
    final availableItems = List<Map<String, dynamic>>.from(_itemList);
    
    while (selectedItems.length < 4 && availableItems.isNotEmpty) {
      final index = random.nextInt(availableItems.length);
      selectedItems.add(availableItems[index]);
      availableItems.removeAt(index);
    }
    
    // Her karttan 2 adet oluştur (eşleri için)
    _gameCards = [];
    
    for (final item in selectedItems) {
      // Her karttan iki adet ekle (eşleşme için)
      _gameCards.add({
        ...item,
        'isFlipped': false,
        'isMatched': false,
        'id': UniqueKey().toString(),
      });
      
      _gameCards.add({
        ...item,
        'isFlipped': false,
        'isMatched': false,
        'id': UniqueKey().toString(),
      });
    }
    
    // Kartları karıştır
    _gameCards.shuffle();
    
    setState(() {
      _isLoading = false;
    });
    
    _startTimer();
  }
  
  void _flipCard(Map<String, dynamic> card) {
    if (_isCheckingMatch) return; // Eşleşme kontrol edilirken bekle
    if (card['isMatched']) return; // Eşleşen kartı yeniden açma
    if (card['isFlipped']) return; // Zaten açık olan kartı yeniden açma
    if (_firstCard != null && _secondCard != null) return; // İki kart zaten açıksa işlem yapma
    
    final String cardId = card['id'];
    
    setState(() {
      // Kartı çevir
      for (var c in _gameCards) {
        if (c['id'] == cardId) {
          c['isFlipped'] = true;
        }
      }
      
      // Kelimeyi seslendir
      _tts.speakEnglish(card['name']);
      
      // İlk ve ikinci kart kontrolü
      if (_firstCard == null) {
        _firstCard = card;
      } else {
        _secondCard = card;
        _checkMatch();
      }
    });
  }
  
  void _checkMatch() {
    _isCheckingMatch = true;
    _attempts++;
    
    // İki kart da seçildiyse
    if (_firstCard != null && _secondCard != null) {
      // Eşleşme kontrolü
      if (_firstCard!['name'] == _secondCard!['name']) {
        // Eşleşme başarılı
        setState(() {
          // Eşleşen kartları işaretle
          for (var card in _gameCards) {
            if (card['name'] == _firstCard!['name']) {
              card['isMatched'] = true;
            }
          }
          
          _score += 10;
          
          // Yeni kart seçimine hazırlan
          _firstCard = null;
          _secondCard = null;
          _isCheckingMatch = false;
          
          // Tüm kartlar eşleşti mi kontrol et
          _checkGameCompletion();
        });
        
        // Başarı bildirimi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doğru eşleşme!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        // Eşleşme başarısız, kısa bir süre kartları göster sonra kapat
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            // Kartları geri çevir
            for (var card in _gameCards) {
              if (card['id'] == _firstCard!['id'] || card['id'] == _secondCard!['id']) {
                card['isFlipped'] = false;
              }
            }
            
            if (_score > 0) _score -= 1; // Yanlış eşleşme için puan düşürme
            
            // Yeni kart seçimine hazırlan
            _firstCard = null;
            _secondCard = null;
            _isCheckingMatch = false;
          });
        });
      }
    }
  }
  
  void _checkGameCompletion() {
    bool allMatched = _gameCards.every((card) => card['isMatched']);
    
    if (allMatched) {
      _gameCompleted = true;
      _stopTimer();
      
      // Oyun bittiğinde tebrik mesajı
      Future.delayed(const Duration(milliseconds: 500), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Tebrikler!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tüm eşleşmeleri buldun!'),
                const SizedBox(height: 16),
                Text('Puan: $_score'),
                Text('Deneme Sayısı: $_attempts'),
                Text('Süre: $_timeInSeconds saniye'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _loadItems(); // Yeni oyun başlat
                },
                child: const Text('Yeni Oyun'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hafıza Kartları - ${widget.category.capitalize()}'),
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
                      'Süre: $_timeInSeconds sn',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _loadItems,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Yeni Oyun'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _gameCards.length,
                  itemBuilder: (context, index) {
                    final card = _gameCards[index];
                    return _buildCard(card);
                  },
                ),
              ),
            ],
          ),
    );
  }
  
  Widget _buildCard(Map<String, dynamic> card) {
    final bool isFlipped = card['isFlipped'];
    final bool isMatched = card['isMatched'];
    
    return GestureDetector(
      onTap: () {
        if (!isFlipped && !isMatched) {
          _flipCard(card);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isFlipped 
          ? Matrix4.identity() 
          : (Matrix4.identity()..rotateY(3.14)),
        transformAlignment: Alignment.center,
        child: Card(
          elevation: isMatched ? 1 : (isFlipped ? 8 : 4),
          color: isMatched 
            ? Colors.green.shade100
            : (isFlipped ? Colors.white : Theme.of(context).colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isMatched
              ? BorderSide(color: Colors.green, width: 2)
              : BorderSide.none,
          ),
          child: isFlipped || isMatched
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          card['image'],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Resim yüklenemediğinde yerine metin göster
                            return Container(
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Text(
                                  card['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
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
                    const SizedBox(height: 8),
                    Text(
                      card['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : const Center(
                child: Icon(
                  Icons.question_mark,
                  size: 48,
                  color: Colors.white,
                ),
              ),
        ),
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