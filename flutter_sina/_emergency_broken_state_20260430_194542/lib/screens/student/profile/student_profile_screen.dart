import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../core/theme/theme.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class StudentProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const StudentProfileScreen({
    super.key,
    this.onBack,
  });

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  late final TextEditingController nameCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController addressCtrl;

  bool editMode = false;
  bool photoSelected = false;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: 'دانشجو نمونه');
    phoneCtrl = TextEditingController(text: '+98 912 000 0000');
    emailCtrl = TextEditingController(text: 'student@example.com');
    addressCtrl = TextEditingController(text: 'اراک، خوابگاه دانشجویی');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  void saveProfile() {
    setState(() {
      editMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تغییرات پروفایل ذخیره شد.')),
    );
  }

  void pickPhotoMock() {
    setState(() {
      photoSelected = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('انتخاب عکس در نسخه دیتابیس واقعی کامل می‌شود.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;
    final bool rtl = isRtlLang(lang);

    return Directionality(
      textDirection: textDirectionOf(lang),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          if (widget.onBack != null)
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              leading: const Icon(Icons.arrow_back, size: 20),
              title: Text(
                rtl ? 'بازگشت' : 'Back',
                style: const TextStyle(fontSize: 13),
              ),
              onTap: widget.onBack,
            ),
          SectionCard(
            title: appText(lang, 'profile'),
            icon: Icons.person_outline,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: editMode
                  ? _ProfileEditView(
                      nameCtrl: nameCtrl,
                      phoneCtrl: phoneCtrl,
                      emailCtrl: emailCtrl,
                      addressCtrl: addressCtrl,
                      rtl: rtl,
                      photoSelected: photoSelected,
                      onPickPhoto: pickPhotoMock,
                      onCancel: () {
                        setState(() {
                          editMode = false;
                        });
                      },
                      onSave: saveProfile,
                    )
                  : _ProfileDisplayView(
                      name: nameCtrl.text,
                      phone: phoneCtrl.text,
                      email: emailCtrl.text,
                      address: addressCtrl.text,
                      rtl: rtl,
                      photoSelected: photoSelected,
                      onEdit: () {
                        setState(() {
                          editMode = true;
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDisplayView extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String address;
  final bool rtl;
  final bool photoSelected;
  final VoidCallback onEdit;

  const _ProfileDisplayView({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.rtl,
    required this.photoSelected,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Icon(
            photoSelected ? Icons.check : Icons.person_outline,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          's001',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        _ProfileInfoTile(
          icon: Icons.phone_outlined,
          title: rtl ? 'شماره تماس' : 'Phone',
          value: phone,
        ),
        _ProfileInfoTile(
          icon: Icons.email_outlined,
          title: rtl ? 'ایمیل' : 'Email',
          value: email,
        ),
        _ProfileInfoTile(
          icon: Icons.location_on_outlined,
          title: rtl ? 'آدرس' : 'Address',
          value: address,
        ),
        _ProfileInfoTile(
          icon: Icons.badge_outlined,
          title: rtl ? 'شماره دانشجویی' : 'Student Number',
          value: 's001',
          locked: true,
          note: rtl ? 'فقط واحد آموزش می‌تواند تغییر دهد.' : 'Only Education Office can edit.',
        ),
        _ProfileInfoTile(
          icon: Icons.credit_card_outlined,
          title: rtl ? 'شماره پاسپورت' : 'Passport Number',
          value: 'P-000000',
          locked: true,
          note: rtl ? 'فقط واحد آموزش می‌تواند تغییر دهد.' : 'Only Education Office can edit.',
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: Text(rtl ? 'ویرایش پروفایل' : 'Edit Profile'),
          ),
        ),
      ],
    );
  }
}

class _ProfileEditView extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController addressCtrl;
  final bool rtl;
  final bool photoSelected;
  final VoidCallback onPickPhoto;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _ProfileEditView({
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.addressCtrl,
    required this.rtl,
    required this.photoSelected,
    required this.onPickPhoto,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Icon(
                photoSelected ? Icons.check : Icons.person_outline,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            IconButton.filled(
              onPressed: onPickPhoto,
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _EditableField(
          controller: nameCtrl,
          label: rtl ? 'نام و نام خانوادگی' : 'Full Name',
          icon: Icons.person_outline,
        ),
        _EditableField(
          controller: phoneCtrl,
          label: rtl ? 'شماره تماس' : 'Phone',
          icon: Icons.phone_outlined,
        ),
        _EditableField(
          controller: emailCtrl,
          label: rtl ? 'ایمیل' : 'Email',
          icon: Icons.email_outlined,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: addressCtrl,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: rtl ? 'آدرس' : 'Address',
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
          ),
        ),
        _ReadOnlyField(
          title: rtl ? 'شماره دانشجویی' : 'Student Number',
          value: 's001',
          reason: rtl
              ? 'فقط توسط واحد آموزش قابل تغییر است.'
              : 'Only Education Office can edit this.',
        ),
        const SizedBox(height: 10),
        _ReadOnlyField(
          title: rtl ? 'شماره پاسپورت' : 'Passport Number',
          value: 'P-000000',
          reason: rtl
              ? 'فقط توسط واحد آموزش قابل تغییر است.'
              : 'Only Education Office can edit this.',
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
                label: Text(rtl ? 'انصراف' : 'Cancel'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.save_outlined),
                label: Text(rtl ? 'ذخیره' : 'Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool locked;
  final String? note;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.locked = false,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      leading: Icon(icon, size: 19),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
      subtitle: Text(
        note == null ? value : '$value\n$note',
        style: const TextStyle(fontSize: 10),
      ),
      trailing: locked ? const Icon(Icons.lock_outline, size: 16) : null,
    );
  }
}

class _EditableField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _EditableField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String title;
  final String value;
  final String reason;

  const _ReadOnlyField({
    required this.title,
    required this.value,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: title,
        helperText: reason,
        prefixIcon: const Icon(Icons.lock_outline),
      ),
    );
  }
}
