import 'package:flutter/material.dart';
import '../models/dog_profile.dart';

class PetProfileService extends ChangeNotifier {
  static final PetProfileService _instance = PetProfileService._internal();
  factory PetProfileService() => _instance;
  PetProfileService._internal();

  DogProfile _currentPet = sampleDog;
  DogProfile get currentPet => _currentPet;

  void updateProfile(DogProfile newProfile) {
    _currentPet = newProfile;
    notifyListeners();
  }

  // Breed-specific dynamic content
  Map<String, dynamic> getBreedSpecificContent() {
    final breed = _currentPet.breed.toLowerCase();
    
    if (breed.contains('pug')) {
      return {
        'tip': 'Pugs are prone to overheating. Keep ${_currentPet.name} cool during summer and avoid over-exercising.',
        'risks': [
          {'title': 'Brachycephalic Syndrome', 'severity': 'High', 'description': 'Flat faces cause airflow issues, leading to snoring and overheating.', 'prevention': 'Use a harness, avoid extreme heat.'},
          {'title': 'Skin Fold Infections', 'severity': 'Medium', 'description': 'Bacteria Grows in wrinkles.', 'prevention': 'Clean folds daily with wipes.'},
          {'title': 'Eye Injuries', 'severity': 'High', 'description': 'Bulging eyes are prone to scratches.', 'prevention': 'Avoid thorny bushes.'},
        ],
        'food_warning': 'Pugs gain weight very easily. Monitor calories.',
        'med_note': 'Be cautious with anesthesia for flat-faced breeds.',
      };
    } else if (breed.contains('golden') || breed.contains('retriever')) {
      return {
        'tip': 'Golden Retrievers need lots of exercise. Ensure at least 60 mins of active play daily.',
        'risks': [
          {'title': 'Hip Dysplasia', 'severity': 'High', 'description': 'Joint issue common in large breeds.', 'prevention': 'Maintain healthy weight.'},
          {'title': 'Ear Infections', 'severity': 'Medium', 'description': 'Floppy ears trap moisture.', 'prevention': 'Clean ears weekly.'},
          {'title': 'Heart Issues', 'severity': 'Medium', 'description': 'Common in older Goldens.', 'prevention': 'Regular vet checkups.'},
        ],
        'food_warning': 'Retriever breeds are prone to obesity. High protein is best.',
        'med_note': 'Check for skin allergies before starting new meds.',
      };
    } else if (breed.contains('shepherd')) {
      return {
        'tip': 'German Shepherds are highly intelligent. Incorporate mental stimulation into training.',
        'risks': [
          {'title': 'Hip & Elbow Dysplasia', 'severity': 'High', 'description': 'Joint misalignment causing pain.', 'prevention': 'Low impact activity.'},
          {'title': 'Bloat', 'severity': 'High', 'description': 'Stomach twists, life threatening.', 'prevention': 'Use slow feeder bowls.'},
          {'title': 'Gastric Torsion', 'severity': 'High', 'description': 'Sudden stomach twisting.', 'prevention': 'Avoid exercise after meals.'},
        ],
        'food_warning': 'Needs joint supporting nutrients like Glucosamine.',
        'med_note': 'Monitor for gastrointestinal sensitivity.',
      };
    } else if (breed.contains('beagle')) {
      return {
        'tip': 'Beagles have a strong sense of smell. Keep them on a leash as they may wander off.',
        'risks': [
          {'title': 'Epilepsy', 'severity': 'Medium', 'description': 'Seizures common in Beagles.', 'prevention': 'Avoid known triggers.'},
          {'title': 'Cherry Eye', 'severity': 'Medium', 'description': 'Prolapsed gland in the eye.', 'prevention': 'Keep eyes clean.'},
          {'title': 'Hypothyroidism', 'severity': 'Medium', 'description': 'Low thyroid hormone levels.', 'prevention': 'Periodic blood tests.'},
        ],
        'food_warning': 'They are food-driven. Use slow feeders.',
        'med_note': 'Ear meds are needed for floppy-eared breeds.',
      };
    } else {
      return {
        'tip': 'Indies are hardy and adaptable. Focus on regular vaccination and a balanced local diet.',
        'risks': [
          {'title': 'Tick Fever', 'severity': 'Medium', 'description': 'Bacterial infection from ticks.', 'prevention': 'Use tick prevention collars.'},
          {'title': 'Parvovirus', 'severity': 'High', 'description': 'Severe viral infection.', 'prevention': 'Ensure full vaccination course.'},
          {'title': 'Rabies', 'severity': 'High', 'description': 'Fatal viral disease.', 'prevention': 'Annual booster is mandatory.'},
        ],
        'food_warning': 'Avoid fatty scraps from the table for ${_currentPet.name}.',
        'med_note': 'Monthly flea/tick prevention is essential for ${_currentPet.name}.',
      };
    }
  }
}
