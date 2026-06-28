import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/health_article.dart';
import '../models/ai_food_analysis.dart';
import '../models/ai_medication_analysis.dart';

class PersistentCacheService {
  static final PersistentCacheService _instance = PersistentCacheService._internal();
  factory PersistentCacheService() => _instance;
  PersistentCacheService._internal();

  static const String _wikiKeyPrefix = 'cache_wiki_';
  static const String _foodKeyPrefix = 'cache_food_';
  static const String _medKeyPrefix = 'cache_med_';

  // --- Pet Wiki Caching ---
  
  Future<void> saveWiki(String petKey, List<HealthArticle> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = articles.map((a) => a.toJson()).toList();
    await prefs.setString('$_wikiKeyPrefix$petKey', json.encode(jsonList));
  }

  Future<List<HealthArticle>?> getWiki(String petKey) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_wikiKeyPrefix$petKey');
    if (data == null) return null;
    
    try {
      final List decoded = json.decode(data);
      return decoded.map((a) => HealthArticle.fromJson(a)).toList();
    } catch (e) {
      return null;
    }
  }

  // --- Food Safety Caching ---

  Future<void> saveFood(String foodName, AiFoodAnalysis analysis) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_foodKeyPrefix${foodName.toLowerCase()}', json.encode(analysis.toJson()));
  }

  Future<AiFoodAnalysis?> getFood(String foodName) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_foodKeyPrefix${foodName.toLowerCase()}');
    if (data == null) return null;

    try {
      return AiFoodAnalysis.fromJson(json.decode(data));
    } catch (e) {
      return null;
    }
  }

  // --- Medication Caching ---

  Future<void> saveMed(String medName, AiMedicationAnalysis analysis) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_medKeyPrefix${medName.toLowerCase()}', json.encode(analysis.toJson()));
  }

  Future<AiMedicationAnalysis?> getMed(String medName) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_medKeyPrefix${medName.toLowerCase()}');
    if (data == null) return null;

    try {
      return AiMedicationAnalysis.fromJson(json.decode(data));
    } catch (e) {
      return null;
    }
  }

  // --- Gemini API Key Storage ---
  static const String _userGeminiKey = 'user_gemini_api_key';
  static const _secureStorage = FlutterSecureStorage();

  Future<void> saveUserGeminiKey(String key) async {
    if (key.isEmpty) {
      await _secureStorage.delete(key: _userGeminiKey);
    } else {
      await _secureStorage.write(key: _userGeminiKey, value: key);
    }
  }

  Future<String> getUserGeminiKey() async {
    try {
      return await _secureStorage.read(key: _userGeminiKey) ?? '';
    } catch (e) {
      return '';
    }
  }

  static const String _factsKeyPrefix = 'cache_facts_';
  static const String _newsKey = 'cache_news';

  // --- Facts Caching ---
  Future<void> saveFacts(String petKey, List<String> facts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('$_factsKeyPrefix$petKey', facts);
  }

  Future<List<String>?> getFacts(String petKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('$_factsKeyPrefix$petKey');
  }

  // --- News Caching ---
  Future<void> saveNews(List<HealthArticle> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = articles.map((a) => a.toJson()).toList();
    await prefs.setString(_newsKey, json.encode(jsonList));
  }

  Future<List<HealthArticle>?> getNews() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_newsKey);
    if (data == null) return null;
    
    try {
      final List decoded = json.decode(data);
      return decoded.map((a) => HealthArticle.fromJson(a)).toList();
    } catch (e) {
      return null;
    }
  }

  // --- System ---

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        await prefs.remove(key);
      }
    }
  }
}
