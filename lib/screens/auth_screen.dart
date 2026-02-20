import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verification_screen.dart';
import 'login_screen.dart';
import '../l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _phoneError = '';
  bool _isPhoneValid = false;
  
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
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    setState(() {
      if (digits.length == 10) {
        _isPhoneValid = true;
        _phoneError = '';
      } else {
        _isPhoneValid = false;
        if (_phoneController.text.isNotEmpty && digits.isNotEmpty) {
          _phoneError = AppLocalizations.of(context)?.phoneMustHave10Digits ?? 'Номер должен содержать 10 цифр после +7';
        } else {
          _phoneError = '';
        }
      }
    });
  }

  String _formatPhoneNumber(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    
    String result = '+7';
    if (digits.length > 1) {
      result += ' (${digits.substring(1, digits.length > 4 ? 4 : digits.length)}';
    }
    if (digits.length > 4) {
      result += ') ${digits.substring(4, digits.length > 7 ? 7 : digits.length)}';
    }
    if (digits.length > 7) {
      result += '-${digits.substring(7, digits.length > 9 ? 9 : digits.length)}';
    }
    if (digits.length > 9) {
      result += '-${digits.substring(9)}';
    }
    return result;
  }

  void _onPhoneInputChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 10 digits only
    if (digits.length > 10) {
      return;
    }
    
    final formatted = _formatPhoneNumber(digits);
    if (formatted != _phoneController.text) {
      _phoneController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _onGetCodePressed(BuildContext context) {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty) {
      setState(() {
        _phoneError = AppLocalizations.of(context)?.enterPhoneNumber ?? 'Введите номер телефона';
        _isPhoneValid = false;
      });
      return;
    }

    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      setState(() {
        _phoneError = AppLocalizations.of(context)?.phoneMustHave10Digits ?? 'Номер должен содержать 10 цифр после +7';
        _isPhoneValid = false;
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(
          contactInfo: '+$digits',
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
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Row(
                  children: [
                    _buildTabButton(
                      l10n?.byPhone ?? 'По номеру телефона', 
                      _loginType == 0, 
                      () => setState(() => _loginType = 0)
                    ),
                    const SizedBox(width: 20),
                    _buildTabButton(
                      l10n?.byPassword ?? 'По логину и паролю', 
                      _loginType == 1, 
                      () => setState(() => _loginType = 1)
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
                      onPressed: _isPhoneValid ? () => _onGetCodePressed(context) : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _isPhoneValid ? Colors.blue : Colors.grey.shade300,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: Text(
                        l10n?.getCode ?? 'Получить код',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isPhoneValid ? Colors.white : Colors.grey.shade600,
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
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: _phoneError.isNotEmpty ? Colors.red : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Text(
                '+7',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: l10n?.phoneHint ?? 'Введите номер телефона',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: _onPhoneInputChanged,
                ),
              ),
              if (_isPhoneValid)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
        ),
        if (_phoneError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              _phoneError,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
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
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
