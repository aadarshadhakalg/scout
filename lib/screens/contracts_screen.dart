import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:scout/bloc/authentication/authentication_cubit.dart';
import 'package:scout/bloc/contracts/contract_event.dart';
import 'package:scout/bloc/contracts/contract_states.dart';
import 'package:scout/bloc/contracts/contracts_bloc.dart';
import 'package:scout/models/contract_model.dart';
import 'package:scout/screens/auth_screen.dart';
import 'package:scout/screens/contract_track.dart';
import 'package:scout/screens/manage_profile.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  List<Contract>? contracts;

  @override
  void initState() {
    super.initState();
    GetIt.I.get<ContractBloc>().add(FetchContract());
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: BlocListener<ContractBloc, ContractState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is ContractsFetchedState) {
            contracts = state.contracts
                .where(
                  (element) =>
                      element.status != Status.pending &&
                      element.status != Status.declined &&
                      element.employerId !=
                          GetIt.I.get<AuthenticationCubit>().user!.phone,
                )
                .toList();

            setState(() {});
          }
        },
        bloc: GetIt.I.get<ContractBloc>(),
        child: Column(
          children: [
            ListTile(
              title: const Text(
                "My Contracts",
              ),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isDense: true,
                  onChanged: (Object? value) {},
                  value: "all",
                  focusColor: Colors.transparent,
                  items: const [
                    DropdownMenuItem(value: "all", child: Text("All")),
                    DropdownMenuItem(value: "active", child: Text("Active")),
                    DropdownMenuItem(value: "onhold", child: Text("On Hold")),
                    DropdownMenuItem(value: "done", child: Text("Done")),
                  ],
                ),
              ),
            ),
            Expanded(
              child: contracts == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: contracts!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ContractTrackScreen(
                                  contract: contracts![index],
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: contracts![index].status ==
                                    Status.onhold
                                ? Colors.amber
                                : contracts![index].status == Status.declined
                                    ? Colors.red
                                    : contracts![index].status == Status.done
                                        ? Colors.green
                                        : Colors.blue,
                            child: Text(
                              contracts![index]
                                  .status
                                  .name
                                  .characters
                                  .first
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(contracts![index].title),
                          subtitle: FutureBuilder<Object>(
                            future: null,
                            builder: (context, snapshot) {
                              return Text(
                                contracts![index].employerName ??
                                    contracts![index].employerId,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
              title: Text(GetIt.I.get<AuthenticationCubit>().user!.name),
              subtitle: Text(GetIt.I.get<AuthenticationCubit>().user!.phone),
              trailing: IconButton(
                tooltip: "Logout",
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await GetIt.I.get<AuthenticationCubit>().logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuthenticationScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
