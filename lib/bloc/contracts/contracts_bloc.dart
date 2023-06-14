import 'package:appwrite/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:scout/bloc/authentication/authentication_cubit.dart';
import 'package:scout/bloc/contracts/contract_event.dart';
import 'package:scout/bloc/contracts/contract_states.dart';
import 'package:scout/services/appwrite.dart';
import 'package:uuid/uuid.dart';

import '../../models/contract_model.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  ContractBloc({
    required AppwriteService appwriteService,
  })  : _appwriteService = appwriteService,
        super(InitialContractState()) {
    on<CreateContractEvent>(createContract);
    on<FetchContract>(fetchContract);
    on<DeclineContract>(declineContract);
    on<AcceptContract>(acceptContract);
    on<ToggleHoldContract>(toggleHoldContract);
    on<EndContract>(endContract);
  }

  final AppwriteService _appwriteService;

  void createContract(CreateContractEvent event, emit) async {
    emit(CreatingContractState());
    try {
      await _appwriteService.databases.createDocument(
        databaseId: "scout",
        collectionId: "contracts",
        documentId: const Uuid().v4(),
        data: {
          "employerId": GetIt.I.get<AuthenticationCubit>().user!.phone,
          "employeeId": event.email,
          "title": event.title,
          "description": event.description,
          "employerName": GetIt.I.get<AuthenticationCubit>().user!.name,
        },
      );

      emit(ContractCreatedState());

      await fetchContract(FetchContract(), emit);
    } catch (e) {
      emit(
        ContractCreationFailedState(
          e.toString(),
        ),
      );
    }
  }

  Future<void> declineContract(DeclineContract event, emit) async {
    await _appwriteService.databases.updateDocument(
      databaseId: "scout",
      collectionId: "contracts",
      documentId: event.contract.$id,
      data: {
        "status": Status.declined.name,
      },
    );
    await fetchContract(FetchContract(), emit);
  }

  Future<void> acceptContract(AcceptContract event, emit) async {
    await _appwriteService.databases.updateDocument(
      databaseId: "scout",
      collectionId: "contracts",
      documentId: event.contract.$id,
      data: {
        "status": Status.active.name,
      },
    );
    await fetchContract(FetchContract(), emit);
  }

  Future<void> toggleHoldContract(ToggleHoldContract event, emit) async {
    await _appwriteService.databases.updateDocument(
      databaseId: "scout",
      collectionId: "contracts",
      documentId: event.contract.$id,
      data: {
        "status": event.contract.status == Status.onhold
            ? Status.active.name
            : Status.onhold.name,
      },
    );
    await fetchContract(FetchContract(), emit);
  }

  Future<void> endContract(EndContract event, emit) async {
    await _appwriteService.databases.updateDocument(
      databaseId: "scout",
      collectionId: "contracts",
      documentId: event.contract.$id,
      data: {
        "status": Status.done.name,
      },
    );
    await fetchContract(FetchContract(), emit);
  }

  Future<void> fetchContract(FetchContract event, emit) async {
    emit(ContractsLoadingState());
    DocumentList contracts = await _appwriteService.databases.listDocuments(
      databaseId: "scout",
      collectionId: "contracts",
    );

    List<Contract> allContracts = contracts.convertTo<Contract>(
      (p0) {
        return Contract.fromJson(p0 as Map<String, dynamic>);
      },
    );

    emit(ContractsFetchedState(allContracts));
  }
}
