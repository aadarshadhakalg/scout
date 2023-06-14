import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scout/services/appwrite.dart';

import 'contracts_screen.dart';

class SetNameView extends StatefulWidget {
  const SetNameView({super.key});

  @override
  State<SetNameView> createState() => _SetNameViewState();
}

class _SetNameViewState extends State<SetNameView> {
  final TextEditingController _nameController = TextEditingController();
  final RoundedLoadingButtonController _roundedLoadingButtonController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameController,
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedLoadingButton(
              controller: _roundedLoadingButtonController,
              onPressed: () async {
                await AppwriteService()
                    .account
                    .updateName(name: _nameController.text);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const ContractsScreen(),
                  ),
                );
              },
              child: const Text("Set Name"),
            ),
          ],
        ),
      ),
    );
  }
}
