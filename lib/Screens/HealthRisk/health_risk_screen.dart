import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../services/ai_analysis_service.dart';
import '../../services/tts_service.dart';
import '../../services/persistent_cache_service.dart';
import '../../models/health_article.dart';
import '../../theme/app_colors.dart';
import 'package:lottie/lottie.dart';

class HealthRiskScreen extends StatefulWidget {
  const HealthRiskScreen({super.key});

  @override
  State<HealthRiskScreen> createState() => _HealthRiskScreenState();
}

class _HealthRiskScreenState extends State<HealthRiskScreen> {
  List<HealthArticle> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
    PetProfileService().addListener(_onProfileChanged);
    TtsService().init();
    _fetchWikiFeed();
  }

  @override
  void dispose() {
    TtsService().stop();
    TranslationService().removeListener(_onLanguageChanged);
    PetProfileService().removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onProfileChanged() {
    if (mounted) {
      _fetchWikiFeed();
    }
  }

  Future<void> _fetchWikiFeed() async {
    final pet = PetProfileService().currentPet;
    final petKey = "${pet.breed}_${pet.age}".replaceAll(' ', '_');

    // 1. Check Memory Cache first
    final memoryCached = PetProfileService().wikiCache;
    if (memoryCached != null && memoryCached.isNotEmpty) {
      if (mounted) setState(() { _articles = memoryCached; _isLoading = false; });
      return;
    }

    // 2. Check Persistent Cache
    final persistentCached = await PersistentCacheService().getWiki(petKey);
    if (persistentCached != null && persistentCached.isNotEmpty) {
      PetProfileService().setWikiCache(persistentCached);
      if (mounted) setState(() { _articles = persistentCached; _isLoading = false; });
      return;
    }

    // 3. Fetch if not cached
    setState(() => _isLoading = true);
    final articles = await AiAnalysisService().generateHealthFeed(pet);
    
    if (mounted) {
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
      // 4. Save to both caches
      if (articles.isNotEmpty) {
        PetProfileService().setWikiCache(articles);
        await PersistentCacheService().saveWiki(petKey, articles);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const CustomBackButton(),
        leadingWidth: 60,
        title: Text(
          TranslationService.t('health_risks'),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _fetchWikiFeed,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
          ),
        ],
      ),
      body: _isLoading 
          ? _buildLoadingState() 
          : _articles.isEmpty 
              ? _buildEmptyState()
              : _buildWikiFeed(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/loading.json', height: 150),
          const SizedBox(height: 20),
          const Text(
            "Accessing Furrr Pet Wiki...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Fetching breed-specific archives for ${PetProfileService().currentPet.breed}s",
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, size: 80, color: Colors.black12),
          const SizedBox(height: 20),
          const Text("No archives available currently."),
          TextButton(onPressed: _fetchWikiFeed, child: const Text("Try again")),
        ],
      ),
    );
  }

  Widget _buildWikiFeed() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _articles.length,
      itemBuilder: (context, index) => _buildWikiArticle(_articles[index]),
    );
  }

  Widget _buildWikiArticle(HealthArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    fontFamily: 'Serif', // Encyclopedia feel
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  String fullText = "${article.title}. ${article.summary}. ";
                  for (var section in article.sections) {
                    fullText += "${section.title}. ${section.content}. ";
                  }
                  TtsService().speak(fullText);
                },
                icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                tooltip: "Read Aloud",
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: article.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            article.summary,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const Divider(height: 40),
          ...article.sections.map((section) => _buildSection(section)),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              "⁂",
              style: TextStyle(fontSize: 24, color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(HealthSection section) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          section.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              section.content,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
