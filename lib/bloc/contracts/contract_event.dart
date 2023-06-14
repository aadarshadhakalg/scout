import 'package:scout/models/contract_model.dart';

sealed class ContractEvent {}

class CreateContractEvent extends ContractEvent {
  final String email;
  final String title;
  final String description;

  CreateContractEvent(this.email, this.title, this.description);
}

class FetchContract extends ContractEvent {}

class DeclineContract extends ContractEvent {
  final Contract contract;

  DeclineContract(this.contract);
}

class AcceptContract extends ContractEvent {
  final Contract contract;

  AcceptContract(this.contract);
}

class ToggleHoldContract extends ContractEvent {
  final Contract contract;

  ToggleHoldContract(this.contract);
}

class EndContract extends ContractEvent {
  final Contract contract;

  EndContract(this.contract);
}
