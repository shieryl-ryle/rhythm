import 'dart:convert';

/// One phone number the support message can show: a label such as "Emergency services" and the number.
class HelplineNumber {
  const HelplineNumber({required this.label, required this.number, this.note});

  final String label;
  final String number;

  /// What the owner has verified about this number, such as its hours. Shown under it, and only when present,
  /// so the app never claims more than the data does.
  final String? note;
}

/// The numbers for one region (a country or a group of countries). Each list may be empty.
class HelplineRegion {
  const HelplineRegion({
    required this.name,
    required this.countries,
    this.emergency = const [],
    this.crisis = const [],
    this.doctorNote,
  });

  final String name;

  /// ISO 3166-1 alpha-2 codes, upper case: "ZA", "AE", "SG".
  final Set<String> countries;
  final List<HelplineNumber> emergency;
  final List<HelplineNumber> crisis;

  /// One line for the "Talk to your doctor" row, such as where to find a clinic. Optional.
  final String? doctorNote;
}

/// The support numbers (S-090, BR-003), read from `assets/support/helplines.json`. They are data, not code, so
/// the owner can add and verify a region without a release of logic. The app never dials: it shows the numbers
/// as text (owner decision 2026-10-28), so no phone permission or package is needed.
class Helplines {
  const Helplines({required this.version, required this.regions});

  final String version;
  final List<HelplineRegion> regions;

  /// The region that lists [countryCode], or null: then the screen says "call your local emergency number".
  HelplineRegion? regionFor(String? countryCode) {
    if (countryCode == null) return null;
    final code = countryCode.toUpperCase();
    for (final r in regions) {
      if (r.countries.contains(code)) return r;
    }
    return null;
  }

  factory Helplines.parse(String source) {
    final json = jsonDecode(source) as Map<String, Object?>;
    List<HelplineNumber> numbers(Object? list) => [
          for (final e in (list as List? ?? const []).cast<Map<String, Object?>>())
            HelplineNumber(label: e['label']! as String, number: e['number']! as String, note: e['note'] as String?),
        ];
    return Helplines(
      version: json['version']! as String,
      regions: [
        for (final r in (json['regions']! as List).cast<Map<String, Object?>>())
          HelplineRegion(
            name: r['name']! as String,
            countries: {for (final c in (r['countries']! as List).cast<String>()) c.toUpperCase()},
            emergency: numbers(r['emergency']),
            crisis: numbers(r['crisis']),
            doctorNote: r['doctor_note'] as String?,
          ),
      ],
    );
  }
}
