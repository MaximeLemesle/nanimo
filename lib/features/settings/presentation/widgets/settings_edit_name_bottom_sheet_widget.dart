import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/text_field_widget.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';

class SettingsEditNameBottomSheetWidget extends StatefulWidget {
  final String initialName;

  const SettingsEditNameBottomSheetWidget({
    super.key,
    required this.initialName,
  });

  static Future<void> show(
    BuildContext context, {
    required String initialName,
  }) {
    final cubit = context.read<SettingsCubit>();
    return BottomSheetWidget.show(
      context,
      BlocProvider.value(
        value: cubit,
        child: SettingsEditNameBottomSheetWidget(initialName: initialName),
      ),
    );
  }

  @override
  State<SettingsEditNameBottomSheetWidget> createState() =>
      _SettingsEditNameBottomSheetWidgetState();
}

class _SettingsEditNameBottomSheetWidgetState
    extends State<SettingsEditNameBottomSheetWidget> {
  late final TextEditingController _controller;
  bool _isSaving = false;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
    _isValid = widget.initialName.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final success =
        await context.read<SettingsCubit>().updateUserName(_controller.text);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Modifier mon prénom',
      action: ButtonWidget(
        label: 'Enregistrer',
        fullWidth: true,
        isLoading: _isSaving,
        state: _isValid ? ButtonState.normal : ButtonState.disabled,
        onPressed: _save,
      ),
      children: [
        TextFieldWidget(
          controller: _controller,
          label: null,
          hint: 'Votre prénom',
          textInputAction: TextInputAction.done,
          onChanged: (value) =>
              setState(() => _isValid = value.trim().isNotEmpty),
        ),
      ],
    );
  }
}
