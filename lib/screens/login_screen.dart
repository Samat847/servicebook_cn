import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';
import 'profile_screen.dart';
import '../widgets/background_scaffold.dart';

class LoginScreen extends StatefulWidget {
  final bool isRegistration;
  
  const LoginScreen({super.key, this.isRegistration = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _loginError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations? l10n) {
    bool isValid = true;
    
    setState(() {
      _loginError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
    
    if (_loginController.text.trim().isEmpty) {
      setState(() {
        _loginError = l10n?.invalidLogin ?? 'Введите логин';
      });
      isValid = false;
    }
    
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = l10n?.invalidPassword ?? 'Введите пароль';
      });
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = l10n?.passwordTooShort ?? 'Пароль должен содержать минимум 6 символов';
      });
      isValid = false;
    }
    
    if (widget.isRegistration) {
      if (_confirmPasswordController.text.isEmpty) {
        setState(() {
          _confirmPasswordError = l10n?.invalidConfirmPassword ?? 'Подтвердите пароль';
        });
        isValid = false;
      } else if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _confirmPasswordError = l10n?.passwordsDoNotMatch ?? 'Пароли не совпадают';
        });
        isValid = false;
      }
    }
    
    return isValid;
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    
    if (!_validate(l10n)) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (widget.isRegistration) {
        final success = await AuthService.registerUser(
          _loginController.text.trim(),
          _passwordController.text,
        );
        
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n?.accountCreated ?? 'Аккаунт создан успешно'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        } else {
          if (mounted) {
            setState(() {
              _loginError = l10n?.loginFailed ?? 'Неверный логин или пароль';
            });
          }
        }
      } else {
        final success = await AuthService.loginUser(
          _loginController.text.trim(),
          _passwordController.text,
        );
        
        if (success) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        } else {
          if (mounted) {
            setState(() {
              _loginError = l10n?.loginFailed ?? 'Неверный логин или пароль';
              _passwordError = l10n?.loginFailed ?? 'Неверный логин или пароль';
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.error ?? 'Ошибка'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRegistration = widget.isRegistration;
    
    return BackgroundScaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          isRegistration 
            ? (l10n?.registerTitle ?? 'Регистрация')
            : (l10n?.loginTitle ?? 'Вход'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              Text(
                isRegistration 
                  ? (l10n?.registerSubtitle ?? 'Создайте аккаунт для сохранения данных')
                  : (l10n?.loginSubtitle ?? 'Войдите в аккаунт для продолжения'),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 40),
              
              Text(
                l10n?.loginField ?? 'Логин',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  hintText: l10n?.loginHint ?? 'Введите логин или email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: _loginError,
                ),
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 20),
              
              Text(
                l10n?.password ?? 'Пароль',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: l10n?.passwordHint ?? 'Введите пароль',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  errorText: _passwordError,
                ),
                textInputAction: isRegistration ? TextInputAction.next : TextInputAction.done,
                onSubmitted: isRegistration ? null : (_) => _submit(),
              ),
              
              if (isRegistration) ...[
                const SizedBox(height: 20),
                
                Text(
                  l10n?.confirmPassword ?? 'Подтвердите пароль',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: l10n?.confirmPasswordHint ?? 'Введите пароль ещё раз',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    errorText: _confirmPasswordError,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
              ],
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          isRegistration 
                            ? (l10n?.register ?? 'Регистрация')
                            : (l10n?.login ?? 'Войти'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              
              if (!isRegistration) ...[
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Для восстановления пароля обратитесь в поддержку'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    child: const Text(
                      'Забыли пароль?',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
