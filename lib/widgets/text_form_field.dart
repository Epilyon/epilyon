import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EpiTextFormField extends StatelessWidget
{
  final TextEditingController controller;
  final bool number;
  final bool readonly;
  final void Function() callback;
  final void Function() onTap;

  EpiTextFormField({
    this.controller,
    this.number = false,
    this.readonly = false,
    this.callback,
    this.onTap
  });

  @override
  Widget build(BuildContext context)
  {
    return TextFormField(
      validator: emptyValidator,
      controller: controller,
      readOnly: readonly,
      maxLines: 1,
      style: TextStyle(color: Color(0xFF5D6874)),
      inputFormatters: number ? [TextInputFormatter.withFunction((oldv, newv) {
        return newv.text.contains(new RegExp(r"[^0-9]")) ? oldv : newv;
      })] : [],
      onFieldSubmitted: (_) {
        if (callback != null){
          callback();
        }
      },
      onTap: onTap,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFCC0000), width: 1.25)
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFCC0000), width: 1.25)
          ),
          isDense: true,
          fillColor: Color(0xFFE9E9E9),
          filled: true,
          contentPadding: EdgeInsets.only(
              top: 22.5,
              bottom: 0.0,
              left: 17.5,
              right: 10.0
          )
      ),
    );
  }

  String emptyValidator(String value)
  {
    if (value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }

    return null;
  }
}