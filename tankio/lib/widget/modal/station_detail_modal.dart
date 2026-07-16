import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:tankio/l10n/app_localizations.dart';

class StationDetailModal extends StatefulWidget {
  final Map<String, dynamic> station;

  const StationDetailModal({super.key, required this.station});

  @override
  State<StationDetailModal> createState() => _StationDetailModalState();
}

class _StationDetailModalState extends State<StationDetailModal> {
  bool _launchingRoute = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final station = widget.station;
    final stationName = _asString(station['station_name']);
    final groupName = _asString(station['group_name']);
    final companyName = _asString(station['company_name']);
    final typeName = _asString(station['type_station_name']);
    final address = _asString(station['address']);
    final webPage = _asString(station['web_page']);
    final uuid = _asString(station['uuid']);
    final active = _asBool(station['active']);
    final stationTypeId = _asInt(station['station_type_id']);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.45,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 74,
                          height: 74,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Image.asset(
                            _stationAssetByType(stationTypeId),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stationName.isNotEmpty ? stationName : '-',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: size.width * 0.055,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _StatusChip(
                                    label: active
                                        ? l10n.activeLabel
                                        : l10n.inactiveLabel,
                                    color: active
                                        ? const Color(0xFF20B26B)
                                        : const Color(0xFFE53935),
                                    backgroundColor: active
                                        ? const Color(0xFFE7F8F0)
                                        : const Color(0xFFFFEAEA),
                                  ),
                                  if (typeName.isNotEmpty)
                                    _StatusChip(
                                      label: typeName,
                                      color: const Color(0xFF60AF47),
                                      backgroundColor: const Color(0xFFEAF6E5),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: l10n.stationInformationTitle,
                      children: [
                        _DetailRow(label: l10n.groupLabel, value: groupName),
                        _DetailRow(
                          label: l10n.companyLabel,
                          value: companyName,
                        ),
                        _DetailRow(
                          label: l10n.stationTypeLabel,
                          value: typeName,
                        ),
                        _DetailRow(label: l10n.addressLabel, value: address),
                        _DetailRow(label: l10n.webPageLabel, value: webPage),
                        _DetailRow(
                          label: l10n.uuidLabel,
                          value: uuid,
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l10n.openRouteTitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: _RouteButton(
                            label: l10n.wazeLabel,
                            color: const Color(0xFF1C8B4A),
                            imagebutton: "assets/waze.png",
                            onPressed: _launchingRoute
                                ? null
                                : () => _openRoute(
                                    context,
                                    preferredMap: MapType.waze,
                                    stationName: stationName,
                                    latitude: _asDouble(station['latitude']),
                                    longitude: _asDouble(station['longitude']),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: _RouteButton(
                            label: l10n.googleMapsLabel,
                            color: const Color(0xFF1D6BFF),
                            imagebutton: "assets/google-maps.png",
                            onPressed: _launchingRoute
                                ? null
                                : () => _openRoute(
                                    context,
                                    preferredMap: MapType.google,
                                    stationName: stationName,
                                    latitude: _asDouble(station['latitude']),
                                    longitude: _asDouble(station['longitude']),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _RouteButton(
                      label: l10n.closeButton,
                      color: const Color(0xFF111827),
                      outlined: true,
                      imagebutton: null,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openRoute(
    BuildContext context, {
    required MapType preferredMap,
    required String stationName,
    required double latitude,
    required double longitude,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _launchingRoute = true;
    });

    try {
      final installedMaps = await MapLauncher.installedMaps;
      final coords = Coords(latitude, longitude);

      final chosenMap = _pickMap(installedMaps, preferredMap);
      if (chosenMap != null) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        await chosenMap.showDirections(
          destination: coords,
          destinationTitle: stationName,
          directionsMode: DirectionsMode.driving,
        );
        return;
      }

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.noMapAppInstalledMessage)));
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _launchingRoute = false;
        });
      }
    }
  }

  AvailableMap? _pickMap(List<AvailableMap> maps, MapType preferredMap) {
    for (final map in maps) {
      if (map.mapType == preferredMap) {
        return map;
      }
    }

    if (preferredMap == MapType.waze) {
      for (final map in maps) {
        if (map.mapType == MapType.google) {
          return map;
        }
      }
    } else if (preferredMap == MapType.google) {
      for (final map in maps) {
        if (map.mapType == MapType.waze) {
          return map;
        }
      }
    }

    return maps.isNotEmpty ? maps.first : null;
  }

  String _stationAssetByType(int stationTypeId) {
    switch (stationTypeId) {
      case 1:
        return 'assets/fuel-station-marker.png';
      case 2:
        return 'assets/ev-station-marker.png';
      default:
        return 'assets/home_marker.png';
    }
  }

  String _asString(dynamic value) => value?.toString().trim() ?? '';

  bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().trim().toLowerCase() ?? '';
    return text == 'true' || text == '1' || text == 'yes';
  }

  double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  int _asInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _RouteButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;
  final String? imagebutton;
  final VoidCallback? onPressed;

  const _RouteButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.outlined = false,
    required this.imagebutton,
  });

  @override
  Widget build(BuildContext context) {
    final button = outlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: Image.asset(imagebutton!, width: 20),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            label: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          );

    return SizedBox(width: 150, child: button);
  }
}
