import 'package:flutter/material.dart';
import 'package:re_portal_frontend/modules/profile/widgets/profile_textfields.dart';
import 'package:re_portal_frontend/modules/shared/widgets/colors.dart';
import 'package:re_portal_frontend/modules/shared/widgets/custom_buttons.dart';

class MyAccount extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  const MyAccount(
      {super.key,
      required this.name,
      required this.phone,
      required this.email});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.name;
    _phoneController.text = widget.phone;
    _emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary10,
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: 130,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFCCBAE),
                        Color(0xFFF87988),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 64,
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Color(0xFFFCCBAE),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: CustomColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ProfileTextField(
                    controller: _nameController,
                    icon: const Icon(Icons.person),
                    hint: 'Name',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextField(
                    controller: _phoneController,
                    icon: const Icon(Icons.phone),
                    hint: 'Phone',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextField(
                    controller: _emailController,
                    icon: const Icon(Icons.email),
                    hint: 'E-mail',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Spacer(),
                  CustomPrimaryButton(
                    title: "Update",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
