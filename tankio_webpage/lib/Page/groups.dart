import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio_webpage/Model/group.dart';
import 'package:tankio_webpage/Provider/group.dart';
import 'package:tankio_webpage/Widget/Modals/create_user.dart';

class GroupsPage extends ConsumerStatefulWidget {
  const GroupsPage({super.key});

  @override
  ConsumerState<GroupsPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<GroupsPage> {
  bool checkAllRows = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadGroups();
    });
  }

  Future<void> loadGroups() async {
    await Future.microtask(() async {
      await ref.read(groupProvider).getListGroups();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = ref.watch(groupProvider);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 2000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const Expanded(flex: 5, child: Text('All users 44')),
                      const SizedBox(width: 16),
                      Container(
                        width: 200,
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.filter_list),
                          label: const Text('Filter'),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return CreateUserModal();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                          ),
                          child: const Text(
                            '+ Add group',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: DataTable(
                            border: TableBorder.all(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent,
                            ),
                            dataRowMinHeight: 80,
                            dataRowMaxHeight: 80,
                            checkboxHorizontalMargin: 10,
                            columnSpacing: 50,
                            dataRowColor: const WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            dataTextStyle: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            headingTextStyle: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                            headingRowColor: WidgetStatePropertyAll(
                              Colors.grey.shade100,
                            ),
                            showBottomBorder: true,
                            showCheckboxColumn: false,
                            sortAscending: true,
                            columns: [
                              DataColumn(
                                label: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      checkAllRows = !checkAllRows;
                                      for (final e in group.listGroups) {
                                        e['check'] = checkAllRows;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    !checkAllRows
                                        ? Icons.check_box_outline_blank_rounded
                                        : Icons.check_box_outlined,
                                  ),
                                ),
                              ),
                              const DataColumn(label: Text('Group Name')),
                              const DataColumn(label: Text('Company Name')),
                              const DataColumn(label: Text('Document Number')),
                              const DataColumn(label: Text('Address')),
                              const DataColumn(
                                label: Text('Fecha de registro'),
                              ),
                              const DataColumn(label: Text('')),
                            ],
                            rows: group.listGroups.map<DataRow>((e) {
                              final GroupModel item = e['group'] as GroupModel;
                              final bool rowChecked = e['check'] == true;

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Icon(
                                      !rowChecked
                                          ? Icons
                                                .check_box_outline_blank_rounded
                                          : Icons.check_box_outlined,
                                    ),
                                    onTap: () {
                                      debugPrint(jsonEncode(item));
                                      setState(() {
                                        e['check'] = !rowChecked;
                                      });
                                    },
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              60,
                                            ),
                                            color: Colors.grey.shade100,
                                          ),
                                          child: const Icon(Icons.group),
                                        ),
                                        Text(item.name),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(item.companyName)),
                                  DataCell(Text(item.documentNumber)),
                                  DataCell(Text(item.address)),
                                  DataCell(Text('${item.registrationDate}')),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        iconSize: 20,
                                        color: Colors.white,
                                        elevation: 10,
                                        shadowColor: const Color(0x22000000),
                                        surfaceTintColor: Colors.white,
                                        splashRadius: 18,
                                        offset: const Offset(0, 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFFE4E7EC),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.more_vert_rounded,
                                          color: Color(0xFF98A2B3),
                                          size: 20,
                                        ),
                                        tooltip: 'Opciones',
                                        onSelected: checkAllRows
                                            ? null
                                            : (value) {
                                                if (value == 'edit') {}
                                                if (value == 'delete') {
                                                  debugPrint(
                                                    'Eliminar ${item.id}',
                                                  );
                                                }
                                                if (value == 'details') {
                                                  debugPrint(
                                                    'Ver detalle ${item.id}',
                                                  );
                                                }
                                              },
                                        itemBuilder: (context) =>
                                            checkAllRows || !rowChecked
                                            ? []
                                            : [
                                                const PopupMenuItem<String>(
                                                  value: 'details',
                                                  height: 44,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .person_outline_rounded,
                                                        size: 18,
                                                        color: Color(
                                                          0xFF667085,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Text('View profile'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'edit',
                                                  height: 44,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit_outlined,
                                                        size: 18,
                                                        color: Color(
                                                          0xFF667085,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Text(
                                                        'Edit details',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'change',
                                                  height: 44,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.key_outlined,
                                                        size: 18,
                                                        color: Color(
                                                          0xFF667085,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Text('Change permission'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'export',
                                                  height: 44,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.upload_outlined,
                                                        size: 18,
                                                        color: Color(
                                                          0xFF667085,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Text('Export details'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'delete',
                                                  height: 44,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        size: 18,
                                                        color: Color(
                                                          0xFFD92D20,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Text(
                                                        'Delete user',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFFD92D20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
