import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PasswordWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? labelText;

  const PasswordWidget({
    super.key,
    required this.controller,
    this.validator,
    this.labelText,
  });

  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  late bool _obscureText;
  late bool _isDirty;

  @override
  void initState() {
    super.initState();
    _obscureText = true;
    _isDirty = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.label_password,
        hintText: AppLocalizations.of(context)!.enter_your_password,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.all(16),
      ),
      onChanged: (_) {
        setState(() {
          _isDirty = true;
        });
      },
      validator: _isDirty ? widget.validator : null,
    );
  }
}
