import 'package:flutter/material.dart';

enum VaccineStatus { upToDate, dueSoon, overdue }

class Vaccine {
  final String name;
  final String lastGiven;
  final String dueDate;

  const Vaccine({
    required this.name,
    required this.lastGiven,
    required this.dueDate,
  });

  VaccineStatus get status {
    final due = DateTime.tryParse(dueDate);
    if (due == null) return VaccineStatus.upToDate;
    final today = DateTime.now();
    final diff = due.difference(today).inDays;
    if (diff < 0) return VaccineStatus.overdue;
    if (diff <= 30) return VaccineStatus.dueSoon;
    return VaccineStatus.upToDate;
  }

  int get daysLeft {
    final due = DateTime.tryParse(dueDate);
    if (due == null) return 0;
    return due.difference(DateTime.now()).inDays;
  }

  String get formattedDue {
    final due = DateTime.tryParse(dueDate);
    if (due == null) return dueDate;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${due.day} ${months[due.month - 1]} ${due.year}';
  }

  String get formattedLast {
    final d = DateTime.tryParse(lastGiven);
    if (d == null) return lastGiven;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class DogProfile {
  final String name;
  final String breed;
  final String gender;
  final String dob;
  final String weight;
  final bool spayed;
  final String allergies;
  final String conditions;
  final String lastCheckup;
  final String nextVaccine;
  final String vetName;
  final String ownerName;
  final String ownerPhone;
  final String location;
  final List<Vaccine> vaccines;

  const DogProfile({
    required this.name,
    required this.breed,
    required this.gender,
    required this.dob,
    required this.weight,
    required this.spayed,
    required this.allergies,
    required this.conditions,
    required this.lastCheckup,
    required this.nextVaccine,
    required this.vetName,
    required this.ownerName,
    required this.ownerPhone,
    required this.location,
    required this.vaccines,
  });

  DogProfile copyWith({
    String? name,
    String? breed,
    String? gender,
    String? dob,
    String? weight,
    bool? spayed,
    String? allergies,
    String? conditions,
    String? lastCheckup,
    String? nextVaccine,
    String? vetName,
    String? ownerName,
    String? ownerPhone,
    String? location,
    List<Vaccine>? vaccines,
  }) {
    return DogProfile(
      name: name ?? this.name,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      weight: weight ?? this.weight,
      spayed: spayed ?? this.spayed,
      allergies: allergies ?? this.allergies,
      conditions: conditions ?? this.conditions,
      lastCheckup: lastCheckup ?? this.lastCheckup,
      nextVaccine: nextVaccine ?? this.nextVaccine,
      vetName: vetName ?? this.vetName,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      location: location ?? this.location,
      vaccines: vaccines ?? this.vaccines,
    );
  }

  String get age {
    final birth = DateTime.tryParse(dob);
    if (birth == null) return '—';
    final now = DateTime.now();
    int years = now.year - birth.year;
    int months = now.month - birth.month;
    if (now.day < birth.day) months--;
    if (months < 0) {
      years--;
      months += 12;
    }
    if (years > 0) return '$years yr${years > 1 ? 's' : ''} $months mo';
    return '$months months';
  }
}

final sampleDog = DogProfile(
  name: 'Brownie',
  breed: 'Pug',
  gender: 'Male',
  dob: '2022-03-10',
  weight: '8',
  spayed: false,
  allergies: 'None',
  conditions: 'None',
  lastCheckup: '2025-01-12',
  nextVaccine: '2025-09-01',
  vetName: 'PawCare Clinic',
  ownerName: 'Arjun',
  ownerPhone: '+91 98765 43210',
  location: 'Madhapur',
  vaccines: const [
    Vaccine(name: 'Rabies', lastGiven: '2024-09-01', dueDate: '2025-09-01'),
    Vaccine(name: 'DHPP', lastGiven: '2024-09-01', dueDate: '2025-09-01'),
    Vaccine(name: 'Bordetella', lastGiven: '2024-06-15', dueDate: '2025-06-15'),
  ],
);
