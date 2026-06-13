import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
