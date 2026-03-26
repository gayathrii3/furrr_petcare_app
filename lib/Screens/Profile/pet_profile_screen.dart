import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../models/dog_profile.dart';
import 'package:intl/intl.dart';
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
    _tabController = TabController(length: 2, vsync: this); // Reduced to 2
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
                // Vaccines tab removed
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
          colors: [AppColors.secondary, AppColors.background],
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
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.3), width: 2.5),
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
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
          color: filled ? AppColors.primary : AppColors.secondary,
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Icon(icon,
            size: 16,
            color: filled ? AppColors.textDark : AppColors.primary),
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
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800),
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
            ],
          ),
        ],
      ),
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
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
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
                    fillColor: AppColors.secondary,
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

class _FieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _FieldLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ToggleField extends StatelessWidget {
  final String label, value;
  final List<String> options;
  final bool editing;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const _ToggleField({
    required this.label,
    required this.value,
    required this.options,
    required this.editing,
    required this.icon,
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
          const SizedBox(height: 6),
          editing
              ? Row(
                  children: options
                      .map((o) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(o),
                              selected: value == o,
                              onSelected: (s) => s ? onChanged(o) : null,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                color: value == o ? AppColors.textDark : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                      .toList(),
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
              ? InkWell(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.tryParse(value) ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) {
                      onChanged(DateFormat('yyyy-MM-dd').format(d));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          value.isEmpty ? 'Select Date' : value,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                        const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                      ],
                    ),
                  ),
                )
              : Text(
                  value.isEmpty ? 'Not set' : '$value ${suffix ?? ''}',
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

class _SaveBar extends StatelessWidget {
  final VoidCallback onSave, onCancel;
  const _SaveBar({required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: onCancel,
                child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textDark,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
