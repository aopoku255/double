import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/model/profile_model.dart';
import 'package:doubles/src/service/auth/signin_service.dart';
import 'package:doubles/src/service/profile_service.dart';
import 'package:doubles/src/widgets/button.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:doubles/src/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>(); // ✅ form key

  ProfileModel? _profile;
  bool _isLoading = true;
  bool _isSaveLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _spouseNameController = TextEditingController();
  final TextEditingController _spousePhoneController = TextEditingController();
  final TextEditingController _spouseAgeController = TextEditingController();
  final TextEditingController _marriageDurationController =
  TextEditingController();

  String? selectedGender;
  String? selectedAge;
  String? selecteSpousedAge;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final profileService = ProfileService();
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("userId");

    final profile = await profileService.getUserProfile(userId.toString());

    if (mounted && profile != null) {
      setState(() {
        _profile = profile;
        _firstNameController.text = profile.data.firstName ?? '';
        _lastNameController.text = profile.data.lastName ?? '';
        _emailController.text = profile.data.email ?? '';
        _phoneController.text = _profile?.data.phone ?? '';
        _ageController.text = _profile?.data.age.toString() ?? '';
        selectedGender = _profile?.data.gender ?? '';
        selectedAge = _profile?.data.age.toString() ?? '';
        _occupationController.text = _profile?.data.occupation ?? '';
        _spouseNameController.text = _profile?.data.nameOfSpouse ?? '';
        _spousePhoneController.text = _profile?.data.phoneNumberOfSpouse ?? '';
        selecteSpousedAge = _profile?.data.ageOfSpouse.toString() ?? '';
        _marriageDurationController.text =
            _profile?.data.marriageDuration ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _occupationController.dispose();
    _ageController.dispose();
    _spouseNameController.dispose();
    _spousePhoneController.dispose();
    _spouseAgeController.dispose();
    _marriageDurationController.dispose();
    super.dispose();
  }

  // ✅ validator function for min 2 chars
  String? _validateMin2Chars(String? value, {bool isPhone = false}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (isPhone) {
      if (value.length != 10) {
        return 'Phone number must be exactly 10 digits';
      }
    } else {
      if (value.length < 2) {
        return 'Must be at least 2 characters';
      }
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/home");
            },
            child: const Icon(BootstrapIcons.arrow_left)),
        title: const MainText(text: "Profile", color: Colors.black),
        centerTitle: true,
      ),
      bottomSheet: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Button(
          isLoading: _isSaveLoading,
          text: "Save",
          onTap: () async {
            if (!_formKey.currentState!.validate()) return; // ✅ check form

            try {
              setState(() => _isSaveLoading = true);
              final updatedData = {
                "firstName": _firstNameController.text,
                "lastName": _lastNameController.text,
                "email": _emailController.text,
                "phone": _phoneController.text,
                "gender": selectedGender,
                "occupation": _occupationController.text,
                "age": selectedAge,
                "nameOfSpouse": _spouseNameController.text,
                "phoneNumberOfSpouse": _spousePhoneController.text,
                "ageOfSpouse": selecteSpousedAge,
                "marriageDuration": _marriageDurationController.text,
                "firstTimeUser": false
              };
              setState(() => _isSaveLoading = false);
              await SignInService().updateUser(updatedData);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile updated successfully")),
              );
            } catch (e) {
              setState(() => _isSaveLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error updating profile: $e")),
              );
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Form( // ✅ wrap in Form
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFieldInput(
                  label: 'First Name',
                  controller: _firstNameController,
                  validator: _validateMin2Chars,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Last Name',
                  controller: _lastNameController,
                  validator: _validateMin2Chars,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Email',
                  controller: _emailController,
                  validator: _validateMin2Chars,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Phone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) => _validateMin2Chars(v, isPhone: true),
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Gender',
                  dropdownItems: ['Male', 'Female'],
                  value: selectedGender ?? "Male",
                  onChanged: (val) {
                    setState(() {
                      selectedGender = val!;
                      _genderController.text = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Occupation',
                  controller: _occupationController,
                  validator: _validateMin2Chars,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Age',
                  dropdownItems: ['18 - 34', '35 - 49', '50 and above'],
                  value: selectedAge ?? "18 - 34",
                  onChanged: (val) {
                    setState(() {
                      selectedAge = val!;
                      _ageController.text = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Name of Spouse',
                  controller: _spouseNameController,
                  validator: _validateMin2Chars,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Phone Number of Spouse',
                  controller: _spousePhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) => _validateMin2Chars(v, isPhone: true),
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'Spouse Age',
                  dropdownItems: ['18 - 34', '35 - 49', '50 and above'],
                  value: selecteSpousedAge ?? "18 - 34",
                  onChanged: (val) {
                    setState(() {
                      selecteSpousedAge = val!;
                      _spouseAgeController.text = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  label: 'How long have you been married',
                  controller: _marriageDurationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // only numbers
                    LengthLimitingTextInputFormatter(2),    // max 3 digits
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
