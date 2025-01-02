import 'package:bond/config/constant.dart';
import 'package:bond/features/knowledge_unit/ui/add_unit_dialog.dart';
import 'package:bond/shared/styles/styles.dart';
import 'package:bond/shared/widget/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bond/features/knowledge_base/models/knowledge.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_bloc.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_event.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_state.dart';
import 'package:go_router/go_router.dart';

class UnitScreen extends StatelessWidget {
  final Knowledge knowledge;

  const UnitScreen({super.key, required this.knowledge});

  static String imagePath(String type) {
    switch (type) {
      case 'web':
        return webImagePath;
      case 'confluence':
        return confluenceImagePath;
      case 'drive':
        return driveImagePath;
      case 'slack':
        return slackImagePath;
      default:
        return localFileImagePath;
    }
  }

  static String bytesToSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const prefixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    int index = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && index < prefixes.length - 1) {
      size /= 1024;
      index++;
    }
    return '${size.toStringAsFixed(2)} ${prefixes[index]}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnitBloc()..add(GetUnitListEvent(knowledge)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(knowledge.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/create-bot');
            },
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Units: ${knowledge.numberUnits}"),
                  Text("Size: ${bytesToSize(knowledge.totalSize)}"),
                  ElevatedButton(
                    onPressed: () => showDialog(
                        builder: (context) {
                          return AddUnitDialog(knowledge: knowledge);
                        },
                        context: context),
                    style: outlined,
                    child: const Text('Add Unit'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        return customSearchBar(context, (query) {
                          context
                              .read<UnitBloc>()
                              .add(SearchUnitEvent(knowledge, query));
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<UnitBloc, UnitState>(
              builder: (context, state) {
                if (state is UnitLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UnitLoaded) {
                  final unitList = state.unitList.units;

                  if (unitList.isEmpty) {
                    return const Center(child: Text('No units found.'));
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: unitList.length,
                      itemBuilder: (context, index) {
                        final unit = unitList[index];
                        return Card(
                          child: ListTile(
                            title: Text(unit.name,
                                style: const TextStyle(color: primaryColor)),
                            subtitle: Text(bytesToSize(unit.size)),
                            leading: Image.asset(imagePath(unit.type),
                                width: 40, height: 40),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: unit.status,
                                  activeTrackColor: primaryColor,
                                  onChanged: (value) {
                                    context.read<UnitBloc>().add(
                                        UpdateStatusUnitEvent(unit.id,
                                            value ? 'Active' : 'Inactive'));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    context.read<UnitBloc>().add(
                                        DeleteUnitEvent(knowledge, unit.id));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is UnitError) {
                  return Center(child: Text(state.error));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
