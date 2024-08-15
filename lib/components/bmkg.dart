import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/bmkg.dart';
import 'dart:developer';

Widget text(text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black,
      decoration: TextDecoration.none,
      fontSize: 14,
      height: 1,
      fontWeight: FontWeight.normal,
    ),
  );
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  ModelBmkg? dataBmkg;

  Future<void> _getDataBmkg() async {
    try {
      final http.Response response = await http.get(
          Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'));
      if (response.statusCode == 200) {
        setState(() {
          dataBmkg = ModelBmkg.fromJson(json.decode(response.body));
        });
        log(jsonEncode(dataBmkg));
      }
    } catch (_) {}
  }

  @override
  void initState() {
    _getDataBmkg();
    super.initState();
  }

  @override
  void dispose() {
    // dataBmkg = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WHATIF BMKG'),
      ),
      body: RefreshIndicator(
        onRefresh: _getDataBmkg,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: dataBmkg?.infogempa?.gempa.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black12,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Table(
                    columnWidths: const {
                      0: FractionColumnWidth(.25),
                      1: FractionColumnWidth(.75),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text('Tanggal'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text(
                                  "${dataBmkg?.infogempa?.gempa[index].tanggal ?? '-'} ${dataBmkg?.infogempa?.gempa[index].jam ?? '-'}"),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text('Lintang'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text(
                                  dataBmkg?.infogempa?.gempa[index].lintang ??
                                      '-'),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text('Bujur'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text(
                                  dataBmkg?.infogempa?.gempa[index].bujur ??
                                      '-'),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text('Magnitude'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text(
                                  dataBmkg?.infogempa?.gempa[index].magnitude ??
                                      '-'),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text('Kedalaman'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text(
                                  dataBmkg?.infogempa?.gempa[index].kedalaman ??
                                      '-'),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text('Wilayah'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text(
                                  dataBmkg?.infogempa?.gempa[index].wilayah ??
                                      '-'),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text('Potensi'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: text(
                                  dataBmkg?.infogempa?.gempa[index].potensi ??
                                      '-'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // text(dataBmkg?.infogempa?.gempa[index].coordinates ?? ''),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
