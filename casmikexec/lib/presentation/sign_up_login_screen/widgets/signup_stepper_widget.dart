import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class SignupStepperWidget extends StatefulWidget {
  final VoidCallback onSignupComplete;
  final VoidCallback onSwitchToLogin;

  const SignupStepperWidget({
    super.key,
    required this.onSignupComplete,
    required this.onSwitchToLogin,
  });

  @override
  State<SignupStepperWidget> createState() => _SignupStepperWidgetState();
}

class _SignupStepperWidgetState extends State<SignupStepperWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production
  int _step = 0;
  final _step1Key = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  String _selectedCity = 'Mumbai';
  String _selectedVehicle = 'Bike';
  bool _isLoading = false;

  final Map<String, bool> _documents = {
    'Aadhaar Card': false,
    'PAN Card': false,
    "Driver's License": false,
    'Vehicle RC': false,
  };

  final _cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Pune',
  ];
  final _vehicles = [
    {'type': 'Bike', 'icon': Icons.two_wheeler_rounded},
    {'type': 'Scooter', 'icon': Icons.electric_scooter_rounded},
    {'type': 'Car', 'icon': Icons.directions_car_rounded},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_step == 0) {
      if (!_step1Key.currentState!.validate()) return;
    }
    if (_step == 2) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _isLoading = false);
      widget.onSignupComplete();
      return;
    }
    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Step ${_step + 1} of 3',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),
        // Step indicator
        Row(
          children: List.generate(3, (i) {
            final isActive = i == _step;
            final isDone = i < _step;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: isDone || isActive
                      ? AppTheme.primary
                      : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 28),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _step == 0
              ? _buildStep1()
              : _step == 1
              ? _buildStep2()
              : _buildStep3(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            if (_step > 0)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => setState(() => _step--),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                    side: BorderSide(color: AppTheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (_step > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _nextStep,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(_step == 2 ? 'Submit Application' : 'Continue'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already registered? ',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            GestureDetector(
              onTap: widget.onSwitchToLogin,
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _step1Key,
      child: Column(
        key: const ValueKey('step1'),
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              prefixIcon: Icon(Icons.phone_rounded),
              hintText: '+91 XXXXX XXXXX',
            ),
            validator: (v) =>
                v == null || v.length < 10 ? 'Enter valid number' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) =>
                v == null || !v.contains('@') ? 'Enter valid email' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Create Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) =>
                v == null || v.length < 6 ? 'Min 6 characters' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your City',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: _selectedCity,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
          items: _cities
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) => setState(() => _selectedCity = v!),
        ),
        const SizedBox(height: 20),
        const Text(
          'Vehicle Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _vehicles.map((v) {
            final isSelected = _selectedVehicle == v['type'];
            return Expanded(
              child: GestureDetector(
                onTap: () =>
                    setState(() => _selectedVehicle = v['type'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: v['type'] != 'Car' ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary.withAlpha(26)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        v['icon'] as IconData,
                        size: 32,
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        v['type'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final docIcons = {
      'Aadhaar Card': Icons.credit_card_rounded,
      'PAN Card': Icons.badge_outlined,
      "Driver's License": Icons.drive_eta_rounded,
      'Vehicle RC': Icons.document_scanner_outlined,
    };
    return Column(
      key: const ValueKey('step3'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Documents',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'All documents required for verification',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 14),
        ...(_documents.keys.map((doc) {
          final uploaded = _documents[doc]!;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: uploaded
                  ? AppTheme.primary.withAlpha(15)
                  : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: uploaded
                    ? AppTheme.primary.withAlpha(102)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: uploaded
                        ? AppTheme.primary.withAlpha(38)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    docIcons[doc]!,
                    size: 20,
                    color: uploaded ? AppTheme.primary : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        uploaded ? 'Uploaded ✓' : 'Tap to upload',
                        style: TextStyle(
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
                  onTap: () => setState(() => _documents[doc] = !uploaded),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: uploaded
                          ? AppTheme.primary.withAlpha(26)
                          : AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      uploaded ? 'Change' : 'Upload',
                      style: TextStyle(
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
        })),
      ],
    );
  }
}
