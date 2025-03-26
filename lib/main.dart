import 'package:flutter/material.dart';
import 'animals_page.dart';
import 'colors_page.dart';
import 'numbers_page.dart';
import 'services/tts_service.dart';
import 'games/matching_game.dart';
import 'games/memory_game.dart';
import 'games/sound_game.dart';

void main() {
  runApp(const ChildrenEnglishApp());
}

class ChildrenEnglishApp extends StatelessWidget {
  const ChildrenEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AtxKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
        fontFamily: 'Comic Sans MS',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const LearningCategoriesPage(),
    const GamesPage(),
    const ProgressPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AtxKids'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Öğren',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Oyunlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'İlerleme',
          ),
        ],
      ),
    );
  }
}

class LearningCategoriesPage extends StatelessWidget {
  const LearningCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kategori listesi
    final categories = [
      {'name': 'Renkler', 'icon': Icons.color_lens, 'route': '/colors'},
      {'name': 'Hayvanlar', 'icon': Icons.pets, 'route': '/animals'},
      {'name': 'Sayılar', 'icon': Icons.format_list_numbered, 'route': '/numbers'},
      {'name': 'Meyveler', 'icon': Icons.apple, 'route': '/fruits'},
      {'name': 'Aile', 'icon': Icons.family_restroom, 'route': '/family'},
      {'name': 'Vücut', 'icon': Icons.accessibility_new, 'route': '/body'},
    ];
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          title: categories[index]['name'] as String,
          icon: categories[index]['icon'] as IconData,
          onTap: () {
            // Kategori sayfasına geçiş
            final route = categories[index]['route'] as String;
            if (route == '/colors') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ColorsPage()),
              );
            } else if (route == '/animals') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnimalsPage()),
              );
            } else if (route == '/numbers') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NumbersPage()),
              );
            } else {
              // Henüz oluşturulmamış sayfalar için uyarı
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${categories[index]['name']} sayfası yakında eklenecek')),
              );
            }
          },
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Oyun kategorileri
    final games = [
      {
        'name': 'Eşleştirme Oyunu',
        'icon': Icons.extension,
        'description': 'Resimleri ve kelimeleri eşleştir',
        'route': '/matching_game',
      },
      {
        'name': 'Hafıza Kartları',
        'icon': Icons.grid_on,
        'description': 'Kartları çevirip eşlerini bul',
        'route': '/memory_cards',
      },
      {
        'name': 'Doğru Sesi Seç',
        'icon': Icons.volume_up,
        'description': 'Duyduğun kelimenin resmini bul',
        'route': '/sound_game',
      },
      {
        'name': 'Kelime Bulmaca',
        'icon': Icons.search,
        'description': 'Harfleri birleştirerek kelimeyi bul',
        'route': '/word_puzzle',
      },
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Oyun sayfalarına geçiş
              final route = games[index]['route'] as String;
              
              if (route == '/matching_game') {
                _showCategorySelection(context, (category) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchingGame(category: category),
                    ),
                  );
                });
              } else if (route == '/memory_cards') {
                _showCategorySelection(context, (category) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemoryGame(category: category),
                    ),
                  );
                });
              } else if (route == '/sound_game') {
                _showCategorySelection(context, (category) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SoundGame(category: category),
                    ),
                  );
                });
              } else {
                // Henüz oluşturulmamış oyunlar için uyarı
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${games[index]['name']} oyunu yakında eklenecek')),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      games[index]['icon'] as IconData,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          games[index]['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          games[index]['description'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  void _showCategorySelection(BuildContext context, Function(String) onCategorySelected) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Kategori Seçin'),
        children: [
          _buildCategoryOption(context, 'animals', 'Hayvanlar', Icons.pets, onCategorySelected),
          _buildCategoryOption(context, 'colors', 'Renkler', Icons.color_lens, onCategorySelected),
          _buildCategoryOption(context, 'numbers', 'Sayılar', Icons.format_list_numbered, onCategorySelected),
        ],
      ),
    );
  }
  
  Widget _buildCategoryOption(
    BuildContext context,
    String value,
    String title,
    IconData icon,
    Function(String) onCategorySelected,
  ) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        onCategorySelected(value);
      },
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'İlerleme durumunuz yakında burada olacak!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
