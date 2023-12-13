import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class HelperFunctions {
  static void pickCountry(
      BuildContext context, TextEditingController controller) {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        controller.text = '${country.flagEmoji} ${country.name}';
      },
    );
  }

  static String? emailValidation(value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    // Email validation pattern
    String emailPattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    RegExp regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidation(value) {
    {
      if (value!.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters long';
      }
      return null;
    }
  }

  static String? generalValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the textfield';
    } else
      return null;
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        content: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(seconds: 1),
          child: Text(message,
              style: TextStyle(color: CColors.t4, fontWeight: FontWeight.bold)),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: CColors.white,
      ),
    );
  }
}
