import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/model/profile_model.dart';
import 'package:doubles/src/service/auth/signin_service.dart';
import 'package:doubles/src/service/profile_service.dart';
import 'package:doubles/src/widgets/button.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:doubles/src/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileModel? _profile;
  bool _isLoading = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  TextEditingController _spouseNameController = TextEditingController();
  final TextEditingController _spousePhoneController = TextEditingController();
  final TextEditingController _spouseAgeController = TextEditingController();
  final TextEditingController _marriageDurationController = TextEditingController();

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final profileService = ProfileService();
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("userId");
    print("User ID: ${userId}");
    final profile = await profileService.getUserProfile(userId.toString());

    if (mounted && profile != null) {
      print(profile.data.gender);
      setState(() {
        _profile = profile;
        _firstNameController.text = profile.data.firstName ?? '';
        _lastNameController.text = profile.data.lastName ?? '';
        _emailController.text = profile.data.email ?? '';
        _phoneController.text = _profile?.data.phone ?? '';
        _ageController.text = _profile?.data.age.toString() ??  '';
        selectedGender = _profile?.data.gender ?? ''; // 👈 set selected gender here
        _occupationController.text = _profile?.data.occupation ?? '';
        _spouseNameController.text = _profile?.data.nameOfSpouse ?? '';
        _spousePhoneController.text = _profile?.data.phoneNumberOfSpouse ?? '';
        _spouseAgeController.text = _profile?.data.ageOfSpouse.toString() ?? '';
        _marriageDurationController.text = _profile?.data.marriageDuration ?? '';
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pushNamed(context, "/home");
          },
            child: Icon(BootstrapIcons.arrow_left)),
        title: const MainText(text: "Profile", color: Colors.black),
        centerTitle: true,
      ),
      bottomSheet: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Button(
          text: "Save",
          onTap: () async {
            try {
              final updatedData = {
                "firstName": _firstNameController.text,
                "lastName": _lastNameController.text,
                "email": _emailController.text,
                "phone": _phoneController.text,
                "gender": selectedGender, // use selectedGender, not controller
                "occupation": _occupationController.text,
                "age": _ageController.text,
                "nameOfSpouse": _spouseNameController.text,
                "phoneNumberOfSpouse": _spousePhoneController.text,
                "ageOfSpouse": _spouseAgeController.text,
                "marriageDuration": _marriageDurationController.text,
                "firstTimeUser": false
              };

              final response = await SignInService().updateUser(updatedData);



              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile updated successfully")),
              );
            } catch (e) {
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
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFieldInput(label: 'First Name', controller: _firstNameController),
              const SizedBox(height: 20),
              TextFieldInput(label: 'Last Name', controller: _lastNameController),
              const SizedBox(height: 20),
              TextFieldInput(label: 'Email', controller: _emailController),
              const SizedBox(height: 20),
              TextFieldInput(label: 'Phone', controller: _phoneController),
              const SizedBox(height: 20),
              TextFieldInput(
                label: 'Gender',
                dropdownItems: ['Male', 'Female'],
                value: selectedGender == null ? "Male" : selectedGender,
                onChanged: (val) {
                  setState(() {
                    selectedGender = val!;
                    _genderController.text = val;
                  });
                },
              ),

              const SizedBox(height: 20),
              TextFieldInput(label: 'Occupation', controller: _occupationController),
              const SizedBox(height: 20),
              TextFieldInput(label: 'Age', controller: _ageController),
              const SizedBox(height: 20),
              TextFieldInput(label: 'Name of Spouse', controller: _spouseNameController),
              const SizedBox(height: 20),
              TextFieldInput(label: 'Phone Number of Spouse', controller: _spousePhoneController),
              const SizedBox(height: 20),
              TextFieldInput(label: 'Age of Spouse', controller: _spouseAgeController),
              const SizedBox(height: 20),
              TextFieldInput(label: 'How long have you been married', controller: _marriageDurationController),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }
}
