import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SignupWizardWidget extends StatefulWidget {
  final VoidCallback onSignupComplete;
  const SignupWizardWidget({required this.onSignupComplete, super.key});

  @override
  State<SignupWizardWidget> createState() => _SignupWizardWidgetState();
}

class _SignupWizardWidgetState extends State<SignupWizardWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production
  int _currentStep = 0;
  bool _loading = false;

  // Step 1
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscurePass = true;

  // Step 2
  final _storeNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();

  // Step 3 documents
  final Map<String, String?> _uploadedDocs = {
    'Aadhaar Card': null,
    'PAN Card': null,
    'GST Certificate': null,
    'Shop License': null,
    'Bank Proof': null,
  };

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _storeNameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pinCtrl.dispose();
    _yearsCtrl.dispose();
    super.dispose();
  }

  void _next() async {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      setState(() => _loading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _loading = false);
      widget.onSignupComplete();
    }
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepIndicator(currentStep: _currentStep),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildCurrentStep(),
            ),
          ),
        ),
        _buildNavButtons(),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _Step1Form(
          key: ValueKey('step1'),
          formKey: _formKeys[0],
          nameCtrl: _nameCtrl,
          emailCtrl: _emailCtrl,
          phoneCtrl: _phoneCtrl,
          passCtrl: _passCtrl,
          confirmPassCtrl: _confirmPassCtrl,
          obscurePass: _obscurePass,
          onTogglePass: () => setState(() => _obscurePass = !_obscurePass),
        );
      case 1:
        return _Step2Form(
          key: ValueKey('step2'),
          formKey: _formKeys[1],
          storeNameCtrl: _storeNameCtrl,
          addressCtrl: _addressCtrl,
          cityCtrl: _cityCtrl,
          stateCtrl: _stateCtrl,
          pinCtrl: _pinCtrl,
          yearsCtrl: _yearsCtrl,
        );
      case 2:
        return _Step3Docs(
          key: ValueKey('step3'),
          formKey: _formKeys[2],
          uploadedDocs: _uploadedDocs,
          onUpload: (doc) => setState(() => _uploadedDocs[doc] = '$doc.pdf'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _back,
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _next,
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _currentStep < 2 ? 'Continue' : 'Submit Application',
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  static const _labels = ['Personal Info', 'Store Details', 'Documents'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppTheme.surfaceLight,
      child: Row(
        children: List.generate(3, (i) {
          final isActive = i == currentStep;
          final isDone = i < currentStep;
          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDone || isActive
                            ? AppTheme.primary
                            : Colors.white,
                        border: Border.all(
                          color: isDone || isActive
                              ? AppTheme.primary
                              : const Color(0xFFE0E0E0),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isDone
                            ? const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              )
                            : Text(
                                '${i + 1}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isActive
                                      ? Colors.white
                                      : AppTheme.textSecondary,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _labels[i],
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isActive
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (i < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      color: i < currentStep
                          ? AppTheme.primary
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _Step1Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl,
      emailCtrl,
      phoneCtrl,
      passCtrl,
      confirmPassCtrl;
  final bool obscurePass;
  final VoidCallback onTogglePass;

  const _Step1Form({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.passCtrl,
    required this.confirmPassCtrl,
    required this.obscurePass,
    required this.onTogglePass,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Full Name'),
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              hintText: 'Rajesh Kumar',
              prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 14),
          _FieldLabel('Email Address'),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'rajesh@rkmobile.in',
              prefixIcon: Icon(Icons.email_outlined, size: 18),
            ),
            validator: (v) =>
                v == null || !v.contains('@') ? 'Valid email required' : null,
          ),
          const SizedBox(height: 14),
          _FieldLabel('Phone Number'),
          TextFormField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: '+91 98765 43210',
              prefixIcon: Icon(Icons.phone_outlined, size: 18),
            ),
            validator: (v) =>
                v == null || v.length < 10 ? 'Valid phone required' : null,
          ),
          const SizedBox(height: 14),
          _FieldLabel('Password'),
          TextFormField(
            controller: passCtrl,
            obscureText: obscurePass,
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePass
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
                onPressed: onTogglePass,
              ),
            ),
            validator: (v) =>
                v == null || v.length < 8 ? 'Min 8 characters' : null,
          ),
          const SizedBox(height: 14),
          _FieldLabel('Confirm Password'),
          TextFormField(
            controller: confirmPassCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: '••••••••',
              prefixIcon: Icon(Icons.lock_outline_rounded, size: 18),
            ),
            validator: (v) =>
                v != passCtrl.text ? 'Passwords do not match' : null,
          ),
        ],
      ),
    );
  }
}

class _Step2Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController storeNameCtrl,
      addressCtrl,
      cityCtrl,
      stateCtrl,
      pinCtrl,
      yearsCtrl;

  const _Step2Form({
    super.key,
    required this.formKey,
    required this.storeNameCtrl,
    required this.addressCtrl,
    required this.cityCtrl,
    required this.stateCtrl,
    required this.pinCtrl,
    required this.yearsCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Store Name'),
          TextFormField(
            controller: storeNameCtrl,
            decoration: const InputDecoration(
              hintText: 'RK Mobile Store',
              prefixIcon: Icon(Icons.store_outlined, size: 18),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Store name required' : null,
          ),
          const SizedBox(height: 14),
          _FieldLabel('Store Address'),
          TextFormField(
            controller: addressCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: '123, Linking Road, Bandra West',
              prefixIcon: Icon(Icons.location_on_outlined, size: 18),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Address required' : null,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('City'),
                    TextFormField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(hintText: 'Mumbai'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('State'),
                    TextFormField(
                      controller: stateCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Maharashtra',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('PIN Code'),
                    TextFormField(
                      controller: pinCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '400050'),
                      validator: (v) =>
                          v == null || v.length != 6 ? 'Invalid PIN' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Years in Business'),
                    TextFormField(
                      controller: yearsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '5'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step3Docs extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, String?> uploadedDocs;
  final Function(String) onUpload;

  const _Step3Docs({
    super.key,
    required this.formKey,
    required this.uploadedDocs,
    required this.onUpload,
  });

  static const _docIcons = {
    'Aadhaar Card': Icons.credit_card_outlined,
    'PAN Card': Icons.badge_outlined,
    'GST Certificate': Icons.receipt_outlined,
    'Shop License': Icons.store_outlined,
    'Bank Proof': Icons.account_balance_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Required Documents',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All documents are required for partner verification',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ...uploadedDocs.entries.map((entry) {
            final uploaded = entry.value != null;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: uploaded
                    ? AppTheme.primary.withAlpha(10)
                    : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: uploaded
                      ? AppTheme.primary.withAlpha(77)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: uploaded
                          ? AppTheme.primary.withAlpha(26)
                          : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _docIcons[entry.key] ?? Icons.description_outlined,
                      size: 20,
                      color: uploaded
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          uploaded ? entry.value! : 'No file uploaded',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: uploaded
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onUpload(entry.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: uploaded ? Colors.transparent : AppTheme.primary,
                        borderRadius: BorderRadius.circular(6),
                        border: uploaded
                            ? Border.all(color: AppTheme.primary)
                            : null,
                      ),
                      child: Text(
                        uploaded ? 'Change' : 'Upload',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: uploaded ? AppTheme.primary : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
}
