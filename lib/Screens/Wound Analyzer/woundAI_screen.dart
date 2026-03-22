import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:furrr/Screens/Wound Analyzer/woundAI_results.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/ai_analysis_service.dart';
import 'package:furrr/models/ai_health_analysis.dart';
import '../../theme/app_colors.dart';

class WoundAiScreen extends StatefulWidget {
  const WoundAiScreen({super.key});

  @override
  State<WoundAiScreen> createState() => _WoundAiScreenState();
}

class _WoundAiScreenState extends State<WoundAiScreen> {
  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }
  File? _image;
  bool _isAnalyzing = false;

  final ImagePicker _picker = ImagePicker();

  // 📷 CAMERA
  Future<void> _pickFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 🖼 GALLERY
  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 📌 BOTTOM SHEET
  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.surface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Image",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),

              // Camera
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),

              // Gallery
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ ANALYZE
  void _analyzeImage() async {
    if (_image == null || _isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final analysis = await AiAnalysisService().analyzeWound(_image!);

      if (!mounted) return;

      setState(() {
        _isAnalyzing = false;
      });

      // 🚀 Navigate with real analysis data
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WoundResultScreen(analysis: analysis),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error analyzing image: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
          child: Column(
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 15),
                  Text(
                    TranslationService.t('wound_analyzer'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Take or upload a photo — AI checks severity instantly",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: Center(
                  child: _image == null
                      ? _buildUploadUI()
                      : _buildPreviewUI(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📷 Upload UI
  Widget _buildUploadUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _showImageSourcePicker,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 60,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Tap to Capture Photo",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Take wound image",
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // 🖼 Preview UI
  Widget _buildPreviewUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(
            _image!,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),

        // Change image
        Row(
          children: [
            const Icon(Icons.refresh,
                size: 18, color: Color(0xFF6B8F7B)),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: _showImageSourcePicker,
              child: const Text(
                "Use a different photo",
                style: TextStyle(
                  color: Color(0xFF6B8F7B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Analyze Button
        GestureDetector(
          onTap: _isAnalyzing ? null : _analyzeImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: _isAnalyzing
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          TranslationService.t('analyze_ai'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}