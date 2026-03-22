import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../models/dog_profile.dart';
import '../../theme/app_colors.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DogProfile _draft;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _draft = PetProfileService().currentPet.copyWith();
    TranslationService().addListener(_onLanguageChanged);
    PetProfileService().addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    TranslationService().removeListener(_onLanguageChanged);
    PetProfileService().removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onProfileChanged() {
    if (mounted && !_editing) {
      setState(() {
        _draft = PetProfileService().currentPet.copyWith();
      });
    }
  }

  void _save() {
    PetProfileService().updateProfile(_draft);
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(TranslationService.t('profile_saved')),
        backgroundColor: AppColors.background,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _cancel() => setState(() {
        _draft = PetProfileService().currentPet.copyWith();
        _editing = false;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _ProfileHeader(
            dog: _editing ? _draft : PetProfileService().currentPet,
            editing: _editing,
            onEdit: () => setState(() => _editing = true),
            onSave: _save,
            onBack: () => Navigator.pop(context),
          ),
          _TabBar(controller: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _BasicInfoTab(
                  dog: _editing ? _draft : PetProfileService().currentPet,
                  editing: _editing,
                  onChanged: (d) => setState(() => _draft = d),
                ),
                _HealthTab(
                  dog: _editing ? _draft : PetProfileService().currentPet,
                  editing: _editing,
                  onChanged: (d) => setState(() => _draft = d),
                ),
                _VaccinesTab(vaccines: PetProfileService().currentPet.vaccines),
              ],
            ),
          ),
          if (_editing) _SaveBar(onSave: _save, onCancel: _cancel),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final DogProfile dog;
  final bool editing;
  final VoidCallback onEdit, onSave, onBack;

  const _ProfileHeader({
    required this.dog,
    required this.editing,
    required this.onEdit,
    required this.onSave,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.background],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(onTap: onBack),
                  Text(
                    TranslationService.t('pet_profile'),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  _CircleBtn(
                    icon: editing ? Icons.check_rounded : Icons.edit_rounded,
                    onTap: editing ? onSave : onEdit,
                    filled: editing,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.4), width: 2.5),
              ),
              child: const Center(
                child: Text('🐶', style: TextStyle(fontSize: 44)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              dog.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${dog.breed} · ${dog.age} · ${dog.weight} kg',
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Chip(dog.gender),
                const SizedBox(width: 8),
                _Chip(dog.breed),
                const SizedBox(width: 8),
                _Chip(dog.spayed ? 'Spayed' : 'Intact'),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _CircleBtn({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? Colors.white : Colors.white.withOpacity(0.15),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Icon(icon,
            size: 16,
            color: filled ? AppColors.primary : Colors.white),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final TabController controller;
  const _TabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: TabBar(
        controller: controller,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary.withOpacity(0.5),
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: [
          Tab(text: TranslationService.t('basic_info')),
          Tab(text: TranslationService.t('health')),
          Tab(text: TranslationService.t('vaccines')),
        ],
      ),
    );
  }
}

class _BasicInfoTab extends StatelessWidget {
  final DogProfile dog;
  final bool editing;
  final ValueChanged<DogProfile> onChanged;

  const _BasicInfoTab({
    required this.dog,
    required this.editing,
    required this.onChanged,
  });

  static const breeds = [
    'Pug', 'Labrador', 'Golden Retriever', 'German Shepherd',
    'Beagle', 'Bulldog', 'Shih Tzu', 'Husky', 'Rottweiler', 'Indie Dog', 'Other',
  ];

  static const hyderabadLocations = [
    'Jubilee Hills', 'Banjara Hills', 'Gachibowli', 'Madhapur',
    'Kondapur', 'Kukatpally', 'HITEC City', 'Secunderabad',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _Card(
            title: TranslationService.t('identity'),
            icon: Icons.pets,
            children: [
              _Field(
                label: TranslationService.t('name'),
                value: dog.name,
                icon: Icons.label_outline,
                editing: editing,
                onChanged: (v) => onChanged(dog.copyWith(name: v)),
              ),
              _BreedPicker(
                value: dog.breed,
                editing: editing,
                breeds: breeds,
                onChanged: (v) => onChanged(dog.copyWith(breed: v)),
              ),
              _LocationPicker(
                value: dog.location,
                editing: editing,
                locations: hyderabadLocations,
                onChanged: (v) => onChanged(dog.copyWith(location: v)),
              ),
              _ToggleField(
                label: TranslationService.t('gender'),
                value: dog.gender,
                options: const ['Male', 'Female'],
                editing: editing,
                icon: Icons.wc_outlined,
                onChanged: (v) => onChanged(dog.copyWith(gender: v)),
              ),
              _DateField(
                label: TranslationService.t('dob'),
                value: dog.dob,
                icon: Icons.cake_outlined,
                editing: editing,
                onChanged: (v) => onChanged(dog.copyWith(dob: v)),
                suffix: '(${dog.age})',
              ),
              _ToggleField(
                label: TranslationService.t('spayed'),
                value: dog.spayed ? 'Yes' : 'No',
                options: const ['Yes', 'No'],
                editing: editing,
                icon: Icons.health_and_safety_outlined,
                onChanged: (v) => onChanged(dog.copyWith(spayed: v == 'Yes')),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Card(
            title: TranslationService.t('owner_info'),
            icon: Icons.person_outline,
            children: [
              _Field(
                label: TranslationService.t('owner_name'),
                value: dog.ownerName,
                icon: Icons.person_outline,
                editing: editing,
                onChanged: (v) => onChanged(dog.copyWith(ownerName: v)),
              ),
              _Field(
                label: TranslationService.t('phone'),
                value: dog.ownerPhone,
                icon: Icons.phone_outlined,
                editing: editing,
                keyboardType: TextInputType.phone,
                onChanged: (v) => onChanged(dog.copyWith(ownerPhone: v)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthTab extends StatelessWidget {
  final DogProfile dog;
  final bool editing;
  final ValueChanged<DogProfile> onChanged;

  const _HealthTab({
    required this.dog,
    required this.editing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _Card(
            title: TranslationService.t('health_details'),
            icon: Icons.monitor_heart_outlined,
            children: [
              _Field(
                label: TranslationService.t('weight_kg'),
                value: dog.weight,
                icon: Icons.monitor_weight_outlined,
                editing: editing,
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(dog.copyWith(weight: v)),
              ),
              _Field(
                label: TranslationService.t('allergies'),
                value: dog.allergies,
                icon: Icons.warning_amber_outlined,
                editing: editing,
                onChanged: (v) => onChanged(dog.copyWith(allergies: v)),
              ),
              _Field(
                label: TranslationService.t('conditions'),
                value: dog.conditions,
                icon: Icons.assignment_outlined,
                editing: editing,
                onChanged: (v) => onChanged(dog.copyWith(conditions: v)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Card(
            title: TranslationService.t('vet_records'),
            icon: Icons.notification_important_outlined,
            children: [
              _Field(
                label: TranslationService.t('clinic_name'),
                value: dog.vetName,
                icon: Icons.local_hospital_outlined,
                editing: editing,
                onChanged: (v) => onChanged(dog.copyWith(vetName: v)),
              ),
              _DateField(
                label: TranslationService.t('last_checkup_date'),
                value: dog.lastCheckup,
                icon: Icons.history,
                editing: editing,
                onChanged: (v) => onChanged(dog.copyWith(lastCheckup: v)),
              ),
              _DateField(
                label: TranslationService.t('next_vaccine_due'),
                value: dog.nextVaccine,
                icon: Icons.vaccines_outlined,
                editing: editing,
                onChanged: (v) => onChanged(dog.copyWith(nextVaccine: v)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VaccinesTab extends StatelessWidget {
  final List<Vaccine> vaccines;
  const _VaccinesTab({required this.vaccines});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.vaccines, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    TranslationService.t('pet_care_tip'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...vaccines.map((v) => _VaccineCard(vaccine: v)),
        ],
      ),
    );
  }
}

class _VaccineCard extends StatelessWidget {
  final Vaccine vaccine;
  const _VaccineCard({required this.vaccine});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final Color bg;
    final String labelKey;

    switch (vaccine.status) {
      case VaccineStatus.overdue:
        color = AppColors.error;
        bg = AppColors.error.withOpacity(0.12);
        labelKey = 'overdue';
        break;
      case VaccineStatus.dueSoon:
        color = AppColors.accent;
        bg = AppColors.accent.withOpacity(0.12);
        labelKey = 'due_soon';
        break;
      default:
        color = AppColors.primary;
        bg = AppColors.primary.withOpacity(0.12);
        labelKey = 'up_to_date';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.vaccines, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        vaccine.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Text(
                        TranslationService.t(labelKey),
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _VaccineDetail(
                        label: TranslationService.t('last_given'), value: vaccine.formattedLast),
                    const SizedBox(width: 20),
                    _VaccineDetail(
                        label: TranslationService.t('due_date'),
                        value: vaccine.formattedDue,
                        valueColor: color),
                    if (vaccine.status != VaccineStatus.overdue) ...[
                      const SizedBox(width: 20),
                      _VaccineDetail(
                          label: TranslationService.t('days_left'),
                          value: '${vaccine.daysLeft}d',
                          valueColor: color),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccineDetail extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _VaccineDetail({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: valueColor ?? AppColors.textPrimary)),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _Card({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final bool editing;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;

  const _Field({
    required this.label,
    required this.value,
    required this.icon,
    required this.editing,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: label, icon: icon),
          const SizedBox(height: 5),
          editing
              ? TextFormField(
                  initialValue: value,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                )
              : Text(
                  value.isEmpty ? 'Not set' : value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: value.isEmpty ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final bool editing;
  final ValueChanged<String> onChanged;
  final String? suffix;

  const _DateField({
    required this.label,
    required this.value,
    required this.icon,
    required this.editing,
    required this.onChanged,
    this.suffix,
  });

  String _format(String raw) {
    final d = DateTime.tryParse(raw);
    if (d == null) return raw;
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: label, icon: icon),
          const SizedBox(height: 5),
          editing
              ? GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.tryParse(value) ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2035),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primary,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      onChanged(picked.toIso8601String().substring(0, 10));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 15, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          value.isEmpty ? 'Select date' : _format(value),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: value.isEmpty
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    Text(
                      value.isEmpty ? 'Not set' : _format(value),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: value.isEmpty
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (suffix != null) ...[
                      const SizedBox(width: 6),
                      Text(suffix!,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ],
                ),
        ],
      ),
    );
  }
}

class _ToggleField extends StatelessWidget {
  final String label, value;
  final List<String> options;
  final IconData icon;
  final bool editing;
  final ValueChanged<String> onChanged;

  const _ToggleField({
    required this.label,
    required this.value,
    required this.options,
    required this.icon,
    required this.editing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: label, icon: icon),
          const SizedBox(height: 5),
          editing
              ? Row(
                  children: options.map((o) {
                    final selected = value == o;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => onChanged(o),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: selected
                                ? LinearGradient(
                                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)])
                                : null,
                            color: selected ? null : AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            o,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: selected ? AppColors.textDark : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
        ],
      ),
    );
  }
}

class _LocationPicker extends StatelessWidget {
  final String value;
  final bool editing;
  final List<String> locations;
  final ValueChanged<String> onChanged;

  const _LocationPicker({
    required this.value,
    required this.editing,
    required this.locations,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: TranslationService.t('location'), icon: Icons.location_on_outlined),
          const SizedBox(height: 5),
          editing
              ? Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: locations.map((l) {
                    final selected = value == l;
                    return GestureDetector(
                      onTap: () => onChanged(l),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? LinearGradient(
                                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)])
                              : null,
                          color: selected ? null : const Color(0xFFD8F3DC),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          l,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: selected ? AppColors.textDark : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
        ],
      ),
    );
  }
}

class _BreedPicker extends StatelessWidget {
  final String value;
  final bool editing;
  final List<String> breeds;
  final ValueChanged<String> onChanged;

  const _BreedPicker({
    required this.value,
    required this.editing,
    required this.breeds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: TranslationService.t('breed'), icon: Icons.pets),
          const SizedBox(height: 5),
          editing
              ? Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: breeds.map((b) {
                    final selected = value == b;
                    return GestureDetector(
                      onTap: () => onChanged(b),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? LinearGradient(
                                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)])
                              : null,
                          color: selected ? null : const Color(0xFFD8F3DC),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          b,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: selected ? AppColors.textDark : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _FieldLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 11, color: const Color(0xFF7A9E8A)),
        const SizedBox(width: 5),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Color(0xFF7A9E8A),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _SaveBar extends StatelessWidget {
  final VoidCallback onSave, onCancel;
  const _SaveBar({required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: const Border(top: BorderSide(color: Color(0xFFE0EEE6))),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFFE0EEE6)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(TranslationService.t('cancel'),
                  style: const TextStyle(
                      color: Color(0xFF1B2D24), fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                shadowColor: AppColors.primary.withOpacity(0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text(TranslationService.t('save_profile'),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
