import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../services/ai_analysis_service.dart';
import '../../services/tts_service.dart';
import '../../services/persistent_cache_service.dart';
import '../../models/health_article.dart';
import '../../theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthRiskScreen extends StatefulWidget {
  const HealthRiskScreen({super.key});

  @override
  State<HealthRiskScreen> createState() => _HealthRiskScreenState();
}

class _HealthRiskScreenState extends State<HealthRiskScreen> {
  List<HealthArticle> _articles = [];
  List<HealthArticle> _news = [];
  List<String> _facts = [];
  
  bool _isLoading = true;
  int _activeTab = 0; // 0: Care Guides, 1: News & Alerts
  int _activeFactIndex = 0;
  final PageController _pageController = PageController();

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
    _pageController.dispose();
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
    if (!mounted) return;
    setState(() => _isLoading = true);

    final pet = PetProfileService().currentPet;
    final petKey = "${pet.breed}_${pet.age}".replaceAll(' ', '_');

    try {
      // 1. Fetch Care Guides (Breed Specific)
      List<HealthArticle> articles = [];
      final memoryCached = PetProfileService().wikiCache;
      if (memoryCached != null && memoryCached.isNotEmpty) {
        articles = memoryCached;
      } else {
        final persistentCached = await PersistentCacheService().getWiki(petKey);
        if (persistentCached != null && persistentCached.isNotEmpty) {
          articles = persistentCached;
          PetProfileService().setWikiCache(articles);
        } else {
          articles = await AiAnalysisService().generateHealthFeed(pet);
          if (articles.isNotEmpty) {
            PetProfileService().setWikiCache(articles);
            await PersistentCacheService().saveWiki(petKey, articles);
          }
        }
      }

      // 2. Fetch Facts (Breed Specific)
      List<String> facts = [];
      final cachedFacts = await PersistentCacheService().getFacts(petKey);
      if (cachedFacts != null && cachedFacts.isNotEmpty) {
        facts = cachedFacts;
      } else {
        facts = await AiAnalysisService().generateBreedFacts(pet);
        if (facts.isNotEmpty) {
          await PersistentCacheService().saveFacts(petKey, facts);
        }
      }

      // 3. Fetch Pet News & Alerts
      List<HealthArticle> news = [];
      final cachedNews = await PersistentCacheService().getNews();
      if (cachedNews != null && cachedNews.isNotEmpty) {
        news = cachedNews;
      } else {
        news = await AiAnalysisService().generatePetNews();
        if (news.isNotEmpty) {
          await PersistentCacheService().saveNews(news);
        }
      }

      if (mounted) {
        setState(() {
          _articles = articles;
          _facts = facts;
          _news = news;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getArticleImage(String title, List<String> tags) {
    final lowerTitle = title.toLowerCase();
    final tagStr = tags.join(' ').toLowerCase();

    if (lowerTitle.contains('diet') || lowerTitle.contains('food') || lowerTitle.contains('nutrition') || tagStr.contains('nutrition')) {
      return 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=600&auto=format&fit=crop&q=80'; // Dog food bowl
    }
    if (lowerTitle.contains('grooming') || lowerTitle.contains('clean') || tagStr.contains('maintenance') || tagStr.contains('grooming')) {
      return 'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=600&auto=format&fit=crop&q=80'; // Grooming
    }
    if (lowerTitle.contains('heart') || lowerTitle.contains('genetic') || tagStr.contains('genetic') || lowerTitle.contains('hip') || lowerTitle.contains('joint')) {
      return 'https://images.unsplash.com/photo-1581888227599-779811939961?w=600&auto=format&fit=crop&q=80'; // Vet exam
    }
    if (lowerTitle.contains('infection') || lowerTitle.contains('disease') || lowerTitle.contains('parasite') || tagStr.contains('infection') || tagStr.contains('alert')) {
      return 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=600&auto=format&fit=crop&q=80'; // Stethoscope/Sickness
    }
    if (lowerTitle.contains('behavior') || lowerTitle.contains('train') || lowerTitle.contains('exercise') || lowerTitle.contains('play')) {
      return 'https://images.unsplash.com/photo-1541599540903-216a46ca1ad0?w=600&auto=format&fit=crop&q=80'; // Running dog
    }
    // Default puppy
    return 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=600&auto=format&fit=crop&q=80';
  }

  @override
  Widget build(BuildContext context) {
    final pet = PetProfileService().currentPet;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const CustomBackButton(),
        leadingWidth: 60,
        title: Text(
          TranslationService.t('health_risks'),
          style: GoogleFonts.pangolin(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _fetchWikiFeed,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryOrange),
          ),
        ],
      ),
      body: _isLoading 
          ? _buildLoadingState(pet.breed) 
          : Column(
              children: [
                if (_facts.isNotEmpty) _buildFactsCarousel(pet.breed),
                _buildSegmentedControl(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _activeTab == 0
                        ? (_articles.isEmpty ? _buildEmptyState() : _buildWikiFeed(_articles))
                        : (_news.isEmpty ? _buildEmptyState() : _buildWikiFeed(_news)),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoadingState(String breed) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryOrange),
          const SizedBox(height: 24),
          Text(
            "Accessing Furrr Pet Wiki...",
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Fetching breed archives for ${breed}s",
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(color: Colors.black54),
            ),
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
          const Icon(Icons.menu_book_rounded, size: 64, color: Colors.black26),
          const SizedBox(height: 16),
          Text(
            "No articles available currently.",
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: _fetchWikiFeed,
            child: Text(
              "Try again",
              style: GoogleFonts.pangolin(
                textStyle: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactsCarousel(String breed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 125,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _activeFactIndex = index;
              });
            },
            itemCount: _facts.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6EE), // Soft Orange Tint
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryOrange.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, size: 36, color: AppColors.primaryOrange),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$breed Quick Fact",
                            style: GoogleFonts.pangolin(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AppColors.primaryOrange,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _facts[index],
                            style: GoogleFonts.pangolin(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _facts.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _activeFactIndex == index ? 16 : 6,
                  decoration: BoxDecoration(
                    color: _activeFactIndex == index ? AppColors.primaryOrange : Colors.black12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabButton(0, "Care Guides")),
          Expanded(child: _buildTabButton(1, "News & Alerts")),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final bool isActive = _activeTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.pangolin(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isActive ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWikiFeed(List<HealthArticle> feedList) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: feedList.length,
      itemBuilder: (context, index) => _buildWikiArticle(feedList[index]),
    );
  }

  Widget _buildWikiArticle(HealthArticle article) {
    final imageUrl = _getArticleImage(article.title, article.tags);

    return Card(
      key: ValueKey(article.title),
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.04),
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic article image banner
          Image.network(
            imageUrl,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 140,
              color: const Color(0xFFFFF6EE),
              child: const Icon(Icons.image_not_supported_outlined, color: AppColors.primaryOrange),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        article.title,
                        style: GoogleFonts.pangolin(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
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
                      icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryOrange),
                      tooltip: "Read Aloud",
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: article.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag.toUpperCase(),
                      style: GoogleFonts.pangolin(
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  article.summary,
                  style: GoogleFonts.pangolin(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: Colors.black12, height: 1),
                ),
                ...article.sections.map((section) => _buildSection(section)),
              ],
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
          style: GoogleFonts.pangolin(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        iconColor: AppColors.primaryOrange,
        collapsedIconColor: Colors.black45,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              section.content,
              style: GoogleFonts.pangolin(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
