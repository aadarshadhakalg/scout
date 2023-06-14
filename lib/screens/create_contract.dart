import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scout/bloc/contracts/contract_event.dart';
import 'package:scout/bloc/contracts/contracts_bloc.dart';
import 'package:scout/services/phone_validation.dart';
import 'package:scout/widgets/custom_form_field.dart';

import '../bloc/contracts/contract_states.dart';

class CreateContract extends StatelessWidget {
  CreateContract({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final RoundedLoadingButtonController _roundedButtonController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomFormField(
              help: 'Phone',
              child: TextFormField(
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  NPPhoneValidator(errorText: "Not a valid phone number"),
                ]),
                controller: _phoneController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomFormField(
              help: 'Title',
              child: TextFormField(
                validator: RequiredValidator(errorText: "Required"),
                controller: _titleController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomFormField(
              help: 'Description',
              child: TextFormField(
                controller: _descriptionController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocListener<ContractBloc, ContractState>(
              bloc: GetIt.I.get<ContractBloc>(),
              listener: (context, state) {
                if (state is ContractCreatedState) {
                  _roundedButtonController.stop();
                }
              },
              child: RoundedLoadingButton(
                controller: _roundedButtonController,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    GetIt.I.get<ContractBloc>().add(
                          CreateContractEvent(
                            _phoneController.text,
                            _titleController.text,
                            _descriptionController.text,
                          ),
                        );
                  }
                },
                color: Colors.redAccent,
                child: const Text(
                  "Send",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
