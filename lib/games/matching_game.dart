import 'package:flutter/material.dart';
import 'dart:math';
import '../services/tts_service.dart';

class MatchingGame extends StatefulWidget {
  final String category;
  
  const MatchingGame({super.key, required this.category});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  final TTSService _tts = TTSService();
  late List<Map<String, dynamic>> _itemList;
  late List<Map<String, dynamic>> _gameItems;
  bool _isLoading = true;
  int _score = 0;
  String? _selectedItemName;
  Map<String, dynamic>? _selectedItem;
  bool _gameCompleted = false;
  
  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  
  void _loadItems() {
    // Kategori seçimine göre uygun verileri yükle
    setState(() {
      _isLoading = true;
    });
    
    switch(widget.category) {
      case 'animals':
        _itemList = [
          {'name': 'Dog', 'nameTR': 'Köpek', 'image': 'assets/images/animals/dog.png'},
          {'name': 'Cat', 'nameTR': 'Kedi', 'image': 'assets/images/animals/cat.png'},
          {'name': 'Lion', 'nameTR': 'Aslan', 'image': 'assets/images/animals/lion.png'},
          {'name': 'Elephant', 'nameTR': 'Fil', 'image': 'assets/images/animals/elephant.png'},
          {'name': 'Monkey', 'nameTR': 'Maymun', 'image': 'assets/images/animals/monkey.png'},
        ];
        break;
      case 'colors':
        _itemList = [
          {'name': 'Red', 'nameTR': 'Kırmızı', 'image': 'assets/images/colors/red.png', 'color': Colors.red},
          {'name': 'Blue', 'nameTR': 'Mavi', 'image': 'assets/images/colors/blue.png', 'color': Colors.blue},
          {'name': 'Green', 'nameTR': 'Yeşil', 'image': 'assets/images/colors/green.png', 'color': Colors.green},
          {'name': 'Yellow', 'nameTR': 'Sarı', 'image': 'assets/images/colors/yellow.png', 'color': Colors.yellow},
          {'name': 'Purple', 'nameTR': 'Mor', 'image': 'assets/images/colors/purple.png', 'color': Colors.purple},
        ];
        break;
      case 'numbers':
        _itemList = [
          {'name': 'One', 'nameTR': 'Bir', 'number': 1, 'image': 'assets/images/numbers/one.png'},
          {'name': 'Two', 'nameTR': 'İki', 'number': 2, 'image': 'assets/images/numbers/two.png'},
          {'name': 'Three', 'nameTR': 'Üç', 'number': 3, 'image': 'assets/images/numbers/three.png'},
          {'name': 'Four', 'nameTR': 'Dört', 'number': 4, 'image': 'assets/images/numbers/four.png'},
          {'name': 'Five', 'nameTR': 'Beş', 'number': 5, 'image': 'assets/images/numbers/five.png'},
        ];
        break;
      default:
        _itemList = [];
    }
    
    // Oyun için 3 öğe seç
    final random = Random();
    final selectedItems = <Map<String, dynamic>>[];
    final availableItems = List<Map<String, dynamic>>.from(_itemList);
    
    while (selectedItems.length < 3 && availableItems.isNotEmpty) {
      final index = random.nextInt(availableItems.length);
      selectedItems.add(availableItems[index]);
      availableItems.removeAt(index);
    }
    
    // Oyun için görüntü ve metin öğelerini oluştur
    _gameItems = [];
    
    // Renkler kategorisi için özel işlem
    if (widget.category == 'colors') {
      // Görüntüler (sadece renk içeren kartlar, metin yok)
      for (final item in selectedItems) {
        _gameItems.add({
          ...item,
          'type': 'color', // Renk gösterimi için özel tip
        });
      }
      
      // Metinler (sadece renk adları, arka plan renksiz)
      for (final item in selectedItems) {
        _gameItems.add({
          ...item,
          'type': 'text',
        });
      }
    } else {
      // Diğer kategoriler için normal işlem
      // Görüntüler
      for (final item in selectedItems) {
        _gameItems.add({
          ...item,
          'type': 'image',
        });
      }
      
      // Metinler (isimler)
      for (final item in selectedItems) {
        _gameItems.add({
          ...item,
          'type': 'text',
        });
      }
    }
    
    // Öğeleri karıştır
    _gameItems.shuffle();
    
    setState(() {
      _isLoading = false;
      _score = 0;
      _selectedItemName = null;
      _selectedItem = null;
      _gameCompleted = false;
    });
  }
  
  void _selectItem(Map<String, dynamic> item) {
    if (_selectedItem == null) {
      // İlk seçim
      setState(() {
        _selectedItem = item;
      });
      
      // Kelimeyi seslendir
      _tts.speakEnglish(item['name']);
    } else {
      // İkinci seçim - eşleşme kontrolü
      if (_selectedItem!['name'] == item['name'] && 
          _selectedItem!['type'] != item['type']) {
        // Eşleşme başarılı
        setState(() {
          _score += 10;
          
          // Seçilen öğeleri listeden kaldır
          _gameItems.removeWhere((element) => 
              element['name'] == item['name']);
          
          _selectedItem = null;
          
          // Oyun tamamlandı mı kontrol et
          if (_gameItems.isEmpty) {
            _gameCompleted = true;
          }
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
        // Eşleşme başarısız
        setState(() {
          if (_score > 0) _score -= 2;
          _selectedItem = null;
        });
        
        // Başarısız bildirimi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Eşleşme başarısız!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eşleştirme Oyunu - ${widget.category.capitalize()}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _gameCompleted
          ? _buildCompletionScreen()
          : _buildGameScreen(),
    );
  }
  
  Widget _buildGameScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Puan: $_score',
                style: const TextStyle(
                  fontSize: 20,
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
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: _gameItems.length,
            itemBuilder: (context, index) {
              final item = _gameItems[index];
              final bool isSelected = _selectedItem == item;
              
              return Card(
                elevation: isSelected ? 8 : 4,
                color: isSelected 
                  ? Theme.of(context).colorScheme.primaryContainer 
                  : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: isSelected
                    ? BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      )
                    : BorderSide.none,
                ),
                child: InkWell(
                  onTap: () => _selectItem(item),
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: item['type'] == 'image'
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            item['image'],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Resim yüklenemediğinde yerine metin göster
                              return Container(
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : item['type'] == 'color' && item.containsKey('color')
                        ? Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: item['color'] as Color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // Renk kartlarında metin yok, sadece renk görünür
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.celebration,
            size: 80,
            color: Colors.amber,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tebrikler!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Puanınız: $_score',
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _loadItems,
            icon: const Icon(Icons.refresh),
            label: const Text('Yeni Oyun'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              textStyle: const TextStyle(fontSize: 20),
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