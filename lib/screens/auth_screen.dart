import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verification_screen.dart';
import 'login_screen.dart';
import '../l10n/app_localizations.dart';

class _PhoneMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    final limitedDigits =
        digitsOnly.length > 10 ? digitsOnly.substring(0, 10) : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');
      if (i == 8) buffer.write('-');
      buffer.write(limitedDigits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _touched = false;
  int _loginType = 0;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    setState(() {});
  }

  int _getDigitCount() {
    return _phoneController.text.replaceAll(RegExp(r'\D'), '').length;
  }

  bool get _isPhoneValid => _getDigitCount() == 10;

  String? get _phoneError {
    if (!_touched) return null;
    if (_isPhoneValid) return null;
    final l10n = AppLocalizations.of(context);
    return l10n?.phoneMustHave10Digits ?? 'Номер должен содержать 10 цифр после +7';
  }

  void _onGetCodePressed() {
    setState(() {
      _touched = true;
    });

    if (!_isPhoneValid) return;

    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(
          contactInfo: '+7$digits',
          isEmail: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  l10n?.loginTitle ?? 'Вход',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n?.loginSubtitle ?? 'Войдите в аккаунт для продолжения',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    _buildTabButton(
                      l10n?.byPhone ?? 'По номеру телефона',
                      _loginType == 0,
                      () => setState(() {
                        _loginType = 0;
                        _touched = false;
                        _phoneController.clear();
                      }),
                    ),
                    const SizedBox(width: 20),
                    _buildTabButton(
                      l10n?.byPassword ?? 'По логину и паролю',
                      _loginType == 1,
                      () => setState(() => _loginType = 1),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_loginType == 0)
                  _buildPhoneInput(l10n)
                else
                  _buildPasswordLoginButton(l10n),
                const SizedBox(height: 30),
                if (_loginType == 0)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onGetCodePressed,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor:
                            _isPhoneValid ? Colors.blue : Colors.grey.shade300,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: Text(
                        l10n?.getCode ?? 'Получить код',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isPhoneValid
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Нажимая кнопку, вы соглашаетесь с Условиями использования и Политикой конфиденциальности.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.blue : Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 100,
            color: isActive ? Colors.blue : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput(AppLocalizations? l10n) {
    final error = _phoneError;
    final hasError = error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? Colors.red : Colors.grey.shade300,
              width: hasError ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Text(
                '+7',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _PhoneMaskFormatter(),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '(___) ___-__-__',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (_) {
                    if (!_touched && _getDigitCount() > 0) {
                      setState(() => _touched = true);
                    }
                  },
                ),
              ),
              if (_isPhoneValid)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    error,
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPasswordLoginButton(AppLocalizations? l10n) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
            ),
            child: Text(
              l10n?.login ?? 'Войти',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(isRegistration: true),
              ),
            );
          },
          child: Text(
            l10n?.register ?? 'Регистрация',
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
