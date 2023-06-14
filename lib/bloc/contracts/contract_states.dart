import 'package:scout/models/contract_model.dart';

sealed class ContractState {}

class InitialContractState extends ContractState {}

class CreatingContractState extends ContractState {}

class ContractCreatedState extends ContractState {}

class ContractCreationFailedState extends ContractState {
  final String message;

  ContractCreationFailedState(this.message);
}

class ContractsLoadingState extends ContractState {}

class ContractsFetchedState extends ContractState {
  final List<Contract> contracts;

  ContractsFetchedState(this.contracts);
}
