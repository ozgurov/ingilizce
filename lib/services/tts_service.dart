import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  
  TTSService._internal();
  
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  String _currentLanguage = "en-US";
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // TTS motorunu yapılandır
      await _flutterTts.setLanguage("en-US"); // İngilizce konuşma
      _currentLanguage = "en-US";
      
      // Bazı durumlarda TTS farklı dil kodları kullanabilir
      // Eğer 'en-US' çalışmazsa, 'en_US' veya 'en' deneyelim
      await _setLanguageWithFallback();
      
      await _flutterTts.setPitch(1.0); // Normal pitch
      await _flutterTts.setSpeechRate(0.5); // Yavaş konuşma hızı (çocuklar için)
      await _flutterTts.setVolume(1.0); // Tam ses
      
      // TTS için İngilizce sesli okumayı zorlamak için ek ayarlar
      await _flutterTts.setVoice({"name": "en-US-language", "locale": "en-US"});
      
      _isInitialized = true;
    } catch (e) {
      print("TTS başlatma hatası: $e");
    }
  }
  
  Future<void> _setLanguageWithFallback() async {
    // Dil kodları için olası alternatifleri dene
    final possibleLanguageCodes = ["en-US", "en_US", "en", "en-GB"];
    
    for (final langCode in possibleLanguageCodes) {
      try {
        final result = await _flutterTts.setLanguage(langCode);
        if (result == 1) {
          _currentLanguage = langCode;
          print("Kullanılan TTS dili: $langCode");
          break; // Başarılı olduğunda döngüden çık
        }
      } catch (e) {
        // Hata durumunda bir sonraki dil kodunu dene
        continue;
      }
    }
  }
  
  Future<void> speak(String text) async {
    await initialize();
    
    // Her konuşma öncesi dil ayarını yeniden kontrol et
    if (_currentLanguage != "en-US") {
      await _setLanguageWithFallback();
    }
    
    // Web platformunda ekstra önlem
    try {
      // Web'de dil ve ses için ek ayar
      final voices = await _flutterTts.getVoices;
      if (voices != null) {
        // Mevcut sesler içinde İngilizce olanı bul ve ayarla
        final englishVoices = voices.where((voice) => 
            voice.toString().contains('en') || 
            voice.toString().contains('EN') || 
            voice.toString().toLowerCase().contains('english'));
        
        if (englishVoices.isNotEmpty) {
          // Ses ayarını doğru formatta yap (Map<String, String> olmalı)
          final voiceMap = <String, String>{'name': englishVoices.first.toString(), 'locale': 'en-US'};
          await _flutterTts.setVoice(voiceMap);
        }
      }
    } catch (e) {
      // Ses ayarlama hatası, seslerle ilgili hata olabilir, standart ayarlarla devam et
      print("Ses ayarlama hatası: $e");
    }
    
    await _flutterTts.speak(text);
  }
  
  Future<void> stop() async {
    await _flutterTts.stop();
  }
  
  // Belirli dili kullanarak konuşma (ihtiyaç olursa Türkçe kelimeler için)
  Future<void> speakWithLanguage(String text, String language) async {
    await initialize();
    
    // Dil değiştirme gerekiyorsa değiştir
    if (_currentLanguage != language) {
      await _flutterTts.setLanguage(language);
      _currentLanguage = language;
    }
    
    await _flutterTts.speak(text);
  }
  
  // İngilizce telaffuz için özel metot
  Future<void> speakEnglish(String text) async {
    await initialize();
    await _setLanguageWithFallback();
    await _flutterTts.speak(text);
  }
  
  // Dil kodları
  static const String englishUS = "en-US";
  static const String turkishTR = "tr-TR";
} 