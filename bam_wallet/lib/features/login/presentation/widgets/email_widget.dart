import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EmailWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? labelText;

  const EmailWidget({
    super.key,
    required this.controller,
    this.validator,
    this.labelText,
  });

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  bool _isDirty = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.label_email,
        hintText: AppLocalizations.of(context)!.enter_your_email,
        prefixIcon: const Icon(Icons.email),
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
