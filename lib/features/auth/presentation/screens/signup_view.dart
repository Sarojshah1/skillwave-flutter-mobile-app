import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';

import 'login_view.dart';

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // Confirm password controller
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true; // Confirm password obscure flag
  File? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera, color: Colors.blueAccent),
              title: Text('Camera', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blueAccent),
              title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(child: Text('🎉 Congratulations', style: TextStyle(fontWeight: FontWeight.bold))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(SkillWaveAppAssets.congrats, height: 120.h),
              SizedBox(height: 20),
              Text(
                'Your account is ready to use. You will be redirected to the home page in a few seconds.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                ),
                child: Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final user = SignUpEntity(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        role: 'student',
      );

      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(SignUpRequested(user: user, profilePicture: _profileImage));
      if(authBloc.state is SignupSuccess){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful!')),
        );
      }
    }
  }

  bool _isPasswordValid(String password) {
    // Password validation: At least one uppercase, one special character, and one number
    final passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
    return passwordRegExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('assets/icons/appicon.png', height: 100)),
                  SizedBox(height: 30),
                  Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Join SkillWave and start your learning journey!",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : AssetImage('assets/images/profile.jpg') as ImageProvider,
                            ),
                          ),
                          if (_profileImage == null)
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.add_a_photo, color: Colors.blueAccent),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(_nameController, 'Full Name', Icons.person),
                  SizedBox(height: 20),
                  _buildTextField(_emailController, 'Email', Icons.email),
                  SizedBox(height: 20),
                  _buildPasswordField(),
                  SizedBox(height: 20),
                  _buildConfirmPasswordField(),
                  SizedBox(height: 20),
                  _buildTextField(_bioController, 'Tell us about yourself', Icons.info, maxLines: 3),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _handleSignup,
                      icon: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                      label: Text('Sign Up', style: TextStyle(fontSize: 20, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor:
                            Colors.blueAccent
                           ,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginView()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hint';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "Password",
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade600,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (!_isPasswordValid(value)) {
          return 'Password must contain at least 1 uppercase letter, 1 number, and 1 special character';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        hintText: "Confirm Password",
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade600,
          ),
          onPressed: _toggleConfirmPasswordVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

}
