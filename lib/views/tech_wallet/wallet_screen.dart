import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/views/tech_wallet/wallet_detail.dart';

import '../../const/color.dart';
import '../../widgets/app_bars.dart';
import '../../widgets/custom_input_fields.dart';

class Wallet extends StatefulWidget {
  Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final TextEditingController bankName = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController iban = TextEditingController();
  final TextEditingController accNumber = TextEditingController();
  String? selectedBank;
  bool hasBankAccount = false; // Track if the user has added a bank account
  final List<Map<String, String>> banks = [
    {'name': 'ADCB', 'image': 'assets/images/bank.png'},
    {'name': 'HSBC', 'image': 'assets/images/hsbc.png'},
    {'name': 'DIB', 'image': 'assets/images/duabi_islamic.jpg'},
    {
      'name': 'Standard Chartered',
      'image': 'assets/images/standard_charter.png'
    },
    {'name': 'CBD', 'image': 'assets/images/standard_charter.png'},
  ];

  void _addBankAccount() {
    // Simulate adding the bank account
    setState(() {
      hasBankAccount = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Close the keyboard when tapping outside
      },
      child: Scaffold(
        appBar: MyAppBar(
          isMenu: false,
          isNotification: false,
          isTitle: true,
          title: 'Wallet',
          isSecondIcon: false,
          onBackTap: () {
            Get.back();
          },
        ),
        backgroundColor: AppColors.secondary,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),

                // Display Add Bank Form or Wallet Details based on hasBankAccount
                if (!hasBankAccount) ...[
                  _buildBankForm(),
                ] else
                  ...[
                    // _buildWalletDetails(),

                    // Add button to add another bank account
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hasBankAccount = false; // Show the form again
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.31.r),
                          color: AppColors.primary,
                        ),
                        child: Center(
                          child: Text(
                            "Add Bank Account",
                            style: jost600(19.sp, AppColors.secondary),
                          ),
                        ),
                      ),
                    ),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankForm() {
    return Column(
      children: [
        SizedBox(height: 120.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(13.31.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 13.0.h),
                child: Text(
                  'Add Bank Account',
                  style: jost600(19.sp, AppColors.secondary),
                ),
              ),
              SizedBox(height: 26.h),
              DropdownButtonFormField<String>(
                value: selectedBank,
                hint: Text(
                    "Bank Name", style: jost400(14.65.sp, AppColors.primary)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.secondary,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h, horizontal: 12.w),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0.r)),
                ),
                icon: Icon(
                    Icons.keyboard_arrow_down_sharp, color: Colors.black),
                items: banks.map((bank) {
                  return DropdownMenuItem<String>(
                    value: bank['name'],
                    child: Row(
                      children: [
                        Image.asset(bank['image']!, width: 24.w, height: 24.h),
                        SizedBox(width: 10.w),
                        Text(bank['name']!),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBank = value;
                  });
                },
              ),
              SizedBox(height: 11.h),
              CustomInputField(controller: name,
                  hintText: "Full Name",
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h, horizontal: 12.w)),
              SizedBox(height: 11.h),
              CustomInputField(controller: iban,
                  hintText: "IBAN",
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h, horizontal: 12.w)),
              SizedBox(height: 11.h),
              CustomInputField(controller: accNumber,
                  hintText: "Account Number",
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h, horizontal: 12.w)),
              SizedBox(height: 26.h),
              GestureDetector(
                onTap: () {
                  _addBankAccount();
                  Get.to(WalletDetail(
                    name: name.text,
                    iban: iban.text,
                    bankName: selectedBank ?? "Bank",
                    bankImage: banks.firstWhere((bank) =>
                    bank['name'] == selectedBank, orElse: () =>
                    {
                      'image': 'assets/images/bank.png'
                    })['image']!,
                    accNumber: accNumber.text,
                  ));
                },
                child: Container(
                  height: 51.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.31.r),
                    color: AppColors.secondary,
                  ),
                  child: Center(
                    child: Text(
                        "Add", style: jost600(19.sp, AppColors.primary)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
//
//   Widget _buildWalletDetails() {
//     return Column(
//       children: [
//         SizedBox(height: 20.h),
//         Text('Your Wallet Details', style: jost600(19.sp, AppColors.primary)),
//         // Display wallet information here, e.g., balance, transactions, etc.
//         // Example:
//         Text('Bank Name: $selectedBank', style: jost400(16.sp, Colors.black)),
//         // Additional details as needed
//       ],
//     );
//   }
// }
