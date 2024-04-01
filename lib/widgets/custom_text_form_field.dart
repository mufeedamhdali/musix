import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final bool readOnly;
  final TextEditingController controller;
  final TextStyle? hintStyle;

  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle? errorStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final type;
  final TextStyle? style;
  final maxLines;
  final double marginVertical;
  final double marginHorizontal;
  final double paddingVertical;
  final double paddingHorizontal;
  final Function(String)? onChanged;
  final TextCapitalization? textCapitalization;

  const CustomTextFormField({
    Key? key,
    this.hintStyle,
    this.errorStyle,
    this.readOnly = false,
    this.style,
    required this.controller,
    this.maxLines = 1,
    this.type = TextInputType.text,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.enabledBorder,
    this.focusedBorder,
    this.prefixIcon,
    this.suffixIcon,
    this.marginVertical = 20 ,
    this.marginHorizontal = 0 ,
    this.paddingVertical = 10 ,
    this.paddingHorizontal = 5 ,
    this.onChanged ,
    this.textCapitalization ,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.only(left: widget.paddingVertical, right: widget.paddingVertical, top: widget.paddingHorizontal, bottom: widget.paddingHorizontal),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(5, 5),
            blurRadius: 15,
            color: Theme.of(context).shadowColor,
            spreadRadius: 2,
          )
        ],
      ),
      margin: EdgeInsets.only(left: widget.marginVertical, right: widget.marginVertical, top: widget.marginHorizontal, bottom: widget.marginHorizontal),
      child: TextFormField(
        textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
        onChanged: widget.onChanged,
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          errorStyle: const TextStyle(color: Colors.red),
          hintStyle: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.normal,
              fontSize: 16),
          hintText: widget.hintText,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColorLight)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColorLight)),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon,
        ),
        obscureText: widget.obscureText && _obscureText,
        validator: widget.validator,
      ),
    );
  }
}
