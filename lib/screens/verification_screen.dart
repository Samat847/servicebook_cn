import 'package:flutter/material.dart';
import 'dart:async';
import 'profile_screen.dart';
import '../services/car_storage.dart';

class VerificationScreen extends StatefulWidget {
  final String contactInfo;
  final bool isEmail;
  
  const VerificationScreen({
    super.key,
    required this.contactInfo,
    required this.isEmail,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 60;
  late Timer _timer;
  String _maskedContact = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    _maskContactInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _maskContactInfo() {
    if (widget.isEmail) {
      _maskedContact = widget.contactInfo;
    } else {
      final phone = widget.contactInfo.replaceAll(RegExp(r'\D'), '');
      if (phone.length >= 6) {
        final lastFour = phone.substring(phone.length - 4);
        final middle = phone.substring(phone.length - 6, phone.length - 4);
        _maskedContact = '+7 •••• $middle $lastFour';
      } else {
        _maskedContact = widget.contactInfo;
      }
    }
  }

  void _onCodeChanged(int index, String value) {
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isNotEmpty) {
      _controllers[index].text = digitsOnly[0];
      _controllers[index].selection = TextSelection.collapsed(offset: 1);
      if (index < 5) FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else {
      _controllers[index].clear();
      if (index > 0) FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) _verifyCode(code);
  }

  void _verifyCode(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    Future.delayed(const Duration(seconds: 1), () async {
      // Сохраняем статус авторизации и контактные данные
      await CarStorage.saveAuthStatus(true);
      await CarStorage.saveContact(widget.contactInfo, widget.isEmail);
      
      Navigator.pop(context);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEmail ? 'Email подтвержден!' : 'Номер подтвержден!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _resendCode() {
    if (_secondsRemaining > 0) return;
    setState(() => _secondsRemaining = 60);
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isEmail ? 'Код отправлен повторно' : 'SMS отправлено повторно'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _clearAllFields() {
    for (var controller in _controllers) controller.clear();
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  Widget _buildCodeField(int index) {
    return Container(
      width: 48,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: _controllers[index].text.isNotEmpty ? Colors.blue : Colors.grey.shade400,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: _controllers[index].text.isNotEmpty ? Colors.blue.shade50 : Colors.white,
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) => _onCodeChanged(index, value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.isEmail ? 'Подтверждение email' : 'Подтверждение номера'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearAllFields,
            tooltip: 'Очистить',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                widget.isEmail ? 'Подтвердите email' : 'Подтвердите номер',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.isEmail
                    ? 'Введите 6-значный код из письма на ${widget.contactInfo}'
                    : 'Введите код из SMS на $_maskedContact',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildCodeField(index)),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Повторная отправка через',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(_secondsRemaining),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _secondsRemaining > 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (_secondsRemaining == 0)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _resendCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('Отправить код повторно', style: TextStyle(fontSize: 16)),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final code = _controllers.map((c) => c.text).join();
                    if (code.length == 6) {
                      _verifyCode(code);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Введите все 6 цифр'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Подтвердить',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    widget.isEmail ? 'Изменить email' : 'Изменить номер',
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}