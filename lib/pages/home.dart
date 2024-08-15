import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../model/bmkg.dart';
import '../model/usgs.dart';
import '../components/card.dart';
import '../components/text.dart';
import 'package:intl/intl.dart';
import '../utils/format.dart';
import 'dart:developer';

class AnimatedMapControllerPage extends StatefulWidget {
  static const String route = '/map_controller_animated';

  const AnimatedMapControllerPage({super.key});

  @override
  AnimatedMapControllerPageState createState() =>
      AnimatedMapControllerPageState();
}

class AnimatedMapControllerPageState extends State<AnimatedMapControllerPage>
    with TickerProviderStateMixin {
  ModelBmkg? dataBmkg;
  ModelUsgs? dataUsgs;

  Future<void> _getDataBmkg() async {
    try {
      final http.Response response = await http.get(
          Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'));
      if (response.statusCode == 200) {
        setState(() {
          // log(jsonEncode(json.decode(response.body)));
          dataBmkg = ModelBmkg.fromJson(json.decode(response.body));
        });
      }
    } catch (_) {}
  }

  Future<void> _getDataUsgs() async {
    try {
      final String thirtyDaysAgo =
          DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
      final http.Response response = await http.get(Uri.parse(
          "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&minmagnitude=5&starttime=$thirtyDaysAgo&minlatitude=-11.107187&minlongitude=95.011198&maxlatitude=5.907130&maxlongitude=141.020354&limit=15"));
      if (response.statusCode == 200) {
        setState(() {
          // log(jsonEncode(json.decode(response.body)));
          dataUsgs = ModelUsgs.fromJson(json.decode(response.body));
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    _getDataBmkg();
    _getDataUsgs();
    super.initState();
  }

  @override
  void dispose() {
    dataBmkg = null;
    dataUsgs = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatIf BMKG Down'),
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad
          },
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await _getDataBmkg();
            await _getDataUsgs();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(
                              'BMKG',
                              size: 18,
                              weight: FontWeight.bold,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text('Gempabumi Terkini (M ≥ 5.0)'),
                                text(
                                  "Menampilkan ${dataBmkg?.infogempa?.gempa?.length ?? 0} data",
                                  color: Colors.black45,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 6),
                        itemCount: dataBmkg?.infogempa?.gempa?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          String strLatLng =
                              dataBmkg?.infogempa?.gempa?[index].coordinates ??
                                  '';
                          List<double> latLng = [];
                          if (strLatLng.isNotEmpty) {
                            final List<String> listLatLng =
                                strLatLng.split(',');
                            latLng = [
                              double.parse(listLatLng[0]),
                              double.parse(listLatLng[1])
                            ];
                          }
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox.expand(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                      child: Column(
                                        children: [
                                          card(
                                            tanggal: dataBmkg?.infogempa
                                                ?.gempa?[index].tanggal,
                                            jam: dataBmkg
                                                ?.infogempa?.gempa?[index].jam,
                                            lintang: latLng[0],
                                            bujur: latLng[1],
                                            magnitude: dataBmkg?.infogempa
                                                ?.gempa?[index].magnitude,
                                            kedalaman: dataBmkg?.infogempa
                                                ?.gempa?[index].kedalaman,
                                            wilayah: dataBmkg?.infogempa
                                                ?.gempa?[index].wilayah,
                                            potensi: dataBmkg?.infogempa
                                                ?.gempa?[index].potensi,
                                          ),
                                          const SizedBox(height: 12),
                                          Flexible(
                                            child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: FlutterMap(
                                                options: MapOptions(
                                                  initialCenter: LatLng(
                                                      latLng[0], latLng[1]),
                                                  initialZoom: 6.875,
                                                  interactionOptions:
                                                      const InteractionOptions(
                                                    flags: InteractiveFlag.none,
                                                  ),
                                                ),
                                                children: [
                                                  TileLayer(
                                                    urlTemplate:
                                                        'https://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}',
                                                  ),
                                                  MarkerLayer(
                                                    markers: [
                                                      Marker(
                                                        width: 16,
                                                        height: 16,
                                                        point: LatLng(latLng[0],
                                                            latLng[1]),
                                                        child: Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: card(
                              tanggal:
                                  dataBmkg?.infogempa?.gempa?[index].tanggal,
                              jam: dataBmkg?.infogempa?.gempa?[index].jam,
                              lintang: latLng[0],
                              bujur: latLng[1],
                              magnitude:
                                  dataBmkg?.infogempa?.gempa?[index].magnitude,
                              kedalaman:
                                  dataBmkg?.infogempa?.gempa?[index].kedalaman,
                              wilayah:
                                  dataBmkg?.infogempa?.gempa?[index].wilayah,
                              potensi:
                                  dataBmkg?.infogempa?.gempa?[index].potensi,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(
                                  'USGS',
                                  size: 18,
                                  weight: FontWeight.bold,
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: text(
                                    'Data USGS dapat termasuk negara tetangga',
                                    color: Colors.black45,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text('Gempabumi Terkini (M ≥ 5.0)'),
                                text(
                                  "Menampilkan ${dataUsgs?.features?.length ?? 0} data",
                                  color: Colors.black45,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 6),
                        itemCount: dataUsgs?.features?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox.expand(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                      child: Column(
                                        children: [
                                          card(
                                            tanggal: DateFormat('dd MMM yyyy')
                                                .format(
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                          (dataUsgs
                                                                      ?.features?[
                                                                          index]
                                                                      .properties
                                                                      ?.time ??
                                                                  0)
                                                              .toInt())
                                                      .toLocal(),
                                                )
                                                .toString(),
                                            jam:
                                                "${DateFormat('HH:mm:ss').format(
                                                      DateTime.fromMillisecondsSinceEpoch((dataUsgs
                                                                      ?.features?[
                                                                          index]
                                                                      .properties
                                                                      ?.time ??
                                                                  0)
                                                              .toInt())
                                                          .toLocal(),
                                                    ).toString()} WIB",
                                            lintang: dataUsgs?.features?[index]
                                                .geometry?.coordinates?[1],
                                            bujur: dataUsgs?.features?[index]
                                                .geometry?.coordinates?[0],
                                            magnitude:
                                                "${dataUsgs?.features?[index].properties?.mag}",
                                            kedalaman:
                                                "${dataUsgs?.features?[index].geometry?.coordinates?[2].round()} km",
                                            wilayah: formatWilayah(dataUsgs
                                                    ?.features?[index]
                                                    .properties
                                                    ?.place ??
                                                ''),
                                            potensi: (dataUsgs?.features?[index]
                                                        .properties?.tsunami ==
                                                    1)
                                                ? 'Berpotensi tsunami'
                                                : 'Tidak berpotensi tsunami',
                                          ),
                                          const SizedBox(height: 12),
                                          Expanded(
                                            child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: FlutterMap(
                                                options: MapOptions(
                                                  initialCenter: LatLng(
                                                      (dataUsgs
                                                                      ?.features?[
                                                                          index]
                                                                      .geometry
                                                                      ?.coordinates?[
                                                                  1] ??
                                                              0)
                                                          .toDouble(),
                                                      (dataUsgs
                                                                  ?.features?[
                                                                      index]
                                                                  .geometry
                                                                  ?.coordinates?[0] ??
                                                              0)
                                                          .toDouble()),
                                                  initialZoom: 6.875,
                                                  interactionOptions:
                                                      const InteractionOptions(
                                                    flags: InteractiveFlag.none,
                                                  ),
                                                ),
                                                children: [
                                                  TileLayer(
                                                    urlTemplate:
                                                        'https://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}',
                                                  ),
                                                  MarkerLayer(
                                                    markers: [
                                                      Marker(
                                                        width: 16,
                                                        height: 16,
                                                        point: LatLng(
                                                            (dataUsgs
                                                                            ?.features?[
                                                                                index]
                                                                            .geometry
                                                                            ?.coordinates?[
                                                                        1] ??
                                                                    0)
                                                                .toDouble(),
                                                            (dataUsgs
                                                                        ?.features?[
                                                                            index]
                                                                        .geometry
                                                                        ?.coordinates?[0] ??
                                                                    0)
                                                                .toDouble()),
                                                        child: Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: card(
                              tanggal: DateFormat('dd MMM yyyy')
                                  .format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            (dataUsgs?.features?[index]
                                                        .properties?.time ??
                                                    0)
                                                .toInt())
                                        .toLocal(),
                                  )
                                  .toString(),
                              jam: "${DateFormat('HH:mm:ss').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            (dataUsgs?.features?[index]
                                                        .properties?.time ??
                                                    0)
                                                .toInt())
                                        .toLocal(),
                                  ).toString()} WIB",
                              lintang: dataUsgs
                                  ?.features?[index].geometry?.coordinates?[1],
                              bujur: dataUsgs
                                  ?.features?[index].geometry?.coordinates?[0],
                              magnitude:
                                  "${dataUsgs?.features?[index].properties?.mag}",
                              kedalaman:
                                  "${dataUsgs?.features?[index].geometry?.coordinates?[2].round()} km",
                              wilayah: formatWilayah(dataUsgs
                                      ?.features?[index].properties?.place ??
                                  ''),
                              potensi: (dataUsgs?.features?[index].properties
                                          ?.tsunami ==
                                      1)
                                  ? 'Berpotensi tsunami'
                                  : 'Tidak berpotensi tsunami',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
