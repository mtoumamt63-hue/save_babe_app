class Appointment {
  const Appointment({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.place,
  });

  final String id;
  final String title;
  final String date;
  final String time;
  final String place;

  Appointment copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    String? place,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      place: place ?? this.place,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date,
    'time': time,
    'place': place,
  };

  factory Appointment.fromJson(Map<dynamic, dynamic> json) => Appointment(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    date: json['date'] as String? ?? '',
    time: json['time'] as String? ?? '',
    place: json['place'] as String? ?? '',
  );
}

class Measure {
  const Measure({
    required this.id,
    required this.kind, // 'poids' | 'tension' | 'glycemie'
    required this.value,
    required this.date,
  });

  final String id;
  final String kind;
  final String value;
  final String date;

  Measure copyWith({String? id, String? kind, String? value, String? date}) {
    return Measure(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      value: value ?? this.value,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind,
    'value': value,
    'date': date,
  };

  factory Measure.fromJson(Map<dynamic, dynamic> json) => Measure(
    id: json['id'] as String? ?? '',
    kind: json['kind'] as String? ?? 'poids',
    value: json['value'] as String? ?? '',
    date: json['date'] as String? ?? '',
  );
}

class HealthRecord {
  const HealthRecord({required this.label, required this.value});

  final String label;
  final String value;

  Map<String, dynamic> toJson() => {'label': label, 'value': value};

  factory HealthRecord.fromJson(Map<dynamic, dynamic> json) => HealthRecord(
    label: json['label'] as String? ?? '',
    value: json['value'] as String? ?? '',
  );
}

class Partner {
  const Partner({required this.name, required this.phone});

  final String name;
  final String phone;

  Partner copyWith({String? name, String? phone}) {
    return Partner(name: name ?? this.name, phone: phone ?? this.phone);
  }

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone};

  factory Partner.fromJson(Map<dynamic, dynamic> json) => Partner(
    name: json['name'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
  );
}

class Baby {
  const Baby({
    required this.name,
    required this.birth,
    required this.weight,
    required this.sex,
  });

  final String name;
  final String birth;
  final String weight;
  final String sex;

  Baby copyWith({String? name, String? birth, String? weight, String? sex}) {
    return Baby(
      name: name ?? this.name,
      birth: birth ?? this.birth,
      weight: weight ?? this.weight,
      sex: sex ?? this.sex,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'birth': birth,
    'weight': weight,
    'sex': sex,
  };

  factory Baby.fromJson(Map<dynamic, dynamic> json) => Baby(
    name: json['name'] as String? ?? '',
    birth: json['birth'] as String? ?? '',
    weight: json['weight'] as String? ?? '',
    sex: json['sex'] as String? ?? 'fille',
  );
}

class BabyLogEntry {
  const BabyLogEntry({
    required this.id,
    required this.kind, // 'tetee' | 'sommeil' | 'couche'
    required this.at,
  });

  final String id;
  final String kind;
  final String at;

  Map<String, dynamic> toJson() => {'id': id, 'kind': kind, 'at': at};

  factory BabyLogEntry.fromJson(Map<dynamic, dynamic> json) => BabyLogEntry(
    id: json['id'] as String? ?? '',
    kind: json['kind'] as String? ?? 'tetee',
    at: json['at'] as String? ?? '',
  );
}

class ConsentSettings {
  const ConsentSettings({
    this.health = true,
    this.ai = true,
    this.offline = true,
    this.share = false,
  });

  final bool health;
  final bool ai;
  final bool offline;
  final bool share;

  ConsentSettings copyWith({
    bool? health,
    bool? ai,
    bool? offline,
    bool? share,
  }) {
    return ConsentSettings(
      health: health ?? this.health,
      ai: ai ?? this.ai,
      offline: offline ?? this.offline,
      share: share ?? this.share,
    );
  }

  Map<String, dynamic> toJson() => {
    'health': health,
    'ai': ai,
    'offline': offline,
    'share': share,
  };

  factory ConsentSettings.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return const ConsentSettings();
    return ConsentSettings(
      health: json['health'] as bool? ?? true,
      ai: json['ai'] as bool? ?? true,
      offline: json['offline'] as bool? ?? true,
      share: json['share'] as bool? ?? false,
    );
  }
}

class AiPrivacySettings {
  const AiPrivacySettings({
    this.history = false,
    this.anonymize = true,
    this.medical = false,
  });

  final bool history;
  final bool anonymize;
  final bool medical;

  AiPrivacySettings copyWith({bool? history, bool? anonymize, bool? medical}) {
    return AiPrivacySettings(
      history: history ?? this.history,
      anonymize: anonymize ?? this.anonymize,
      medical: medical ?? this.medical,
    );
  }

  Map<String, dynamic> toJson() => {
    'history': history,
    'anonymize': anonymize,
    'medical': medical,
  };

  factory AiPrivacySettings.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) return const AiPrivacySettings();
    return AiPrivacySettings(
      history: json['history'] as bool? ?? false,
      anonymize: json['anonymize'] as bool? ?? true,
      medical: json['medical'] as bool? ?? false,
    );
  }
}

class AppUserState {
  const AppUserState({
    this.name = '',
    this.contact = '',
    this.lmp = '',
    this.firstPregnancy = 'oui',
    this.center = '',
    this.consent = const ConsentSettings(),
    this.aiPrivacy = const AiPrivacySettings(),
    this.appointments = const [
      Appointment(
        id: '1',
        title: 'Consultation prénatale',
        date: '2026-10-12',
        time: '09:30',
        place: 'Centre de santé',
      ),
      Appointment(
        id: '2',
        title: 'Échographie',
        date: '2026-10-28',
        time: '14:00',
        place: 'Hôpital régional',
      ),
    ],
    this.measures = const [],
    this.record = const [],
    this.partner,
    this.baby,
    this.babyLog = const [],
    this.country = 'Côte d\'Ivoire',
    this.language = 'Français',
    this.theme = 'light',
    this.prePregnancyWeightKg,
    this.heightM,
    this.onboarded = false,
  });

  final String name;
  final String contact;
  final String lmp;
  final String firstPregnancy;
  final String center;
  final ConsentSettings consent;
  final AiPrivacySettings aiPrivacy;
  final List<Appointment> appointments;
  final List<Measure> measures;
  final List<HealthRecord> record;
  final Partner? partner;
  final Baby? baby;
  final List<BabyLogEntry> babyLog;
  final String country;
  final String language;
  final String theme; // 'light' | 'dark' | 'system'
  final double? prePregnancyWeightKg;
  final double? heightM;
  final bool onboarded;

  AppUserState copyWith({
    String? name,
    String? contact,
    String? lmp,
    String? firstPregnancy,
    String? center,
    ConsentSettings? consent,
    AiPrivacySettings? aiPrivacy,
    List<Appointment>? appointments,
    List<Measure>? measures,
    List<HealthRecord>? record,
    Partner? partner,
    bool clearPartner = false,
    Baby? baby,
    bool clearBaby = false,
    List<BabyLogEntry>? babyLog,
    String? country,
    String? language,
    String? theme,
    double? prePregnancyWeightKg,
    double? heightM,
    bool? onboarded,
  }) {
    return AppUserState(
      name: name ?? this.name,
      contact: contact ?? this.contact,
      lmp: lmp ?? this.lmp,
      firstPregnancy: firstPregnancy ?? this.firstPregnancy,
      center: center ?? this.center,
      consent: consent ?? this.consent,
      aiPrivacy: aiPrivacy ?? this.aiPrivacy,
      appointments: appointments ?? this.appointments,
      measures: measures ?? this.measures,
      record: record ?? this.record,
      partner: clearPartner ? null : (partner ?? this.partner),
      baby: clearBaby ? null : (baby ?? this.baby),
      babyLog: babyLog ?? this.babyLog,
      country: country ?? this.country,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      prePregnancyWeightKg: prePregnancyWeightKg ?? this.prePregnancyWeightKg,
      heightM: heightM ?? this.heightM,
      onboarded: onboarded ?? this.onboarded,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'contact': contact,
    'lmp': lmp,
    'firstPregnancy': firstPregnancy,
    'center': center,
    'consent': consent.toJson(),
    'aiPrivacy': aiPrivacy.toJson(),
    'appointments': appointments.map((a) => a.toJson()).toList(),
    'measures': measures.map((m) => m.toJson()).toList(),
    'record': record.map((r) => r.toJson()).toList(),
    'partner': partner?.toJson(),
    'baby': baby?.toJson(),
    'babyLog': babyLog.map((b) => b.toJson()).toList(),
    'country': country,
    'language': language,
    'theme': theme,
    'prePregnancyWeightKg': prePregnancyWeightKg,
    'heightM': heightM,
    'onboarded': onboarded,
  };

  factory AppUserState.fromJson(Map<dynamic, dynamic> json) => AppUserState(
    name: json['name'] as String? ?? '',
    contact: json['contact'] as String? ?? '',
    lmp: json['lmp'] as String? ?? '',
    firstPregnancy: json['firstPregnancy'] as String? ?? 'oui',
    center: json['center'] as String? ?? '',
    consent: ConsentSettings.fromJson(json['consent'] as Map?),
    aiPrivacy: AiPrivacySettings.fromJson(json['aiPrivacy'] as Map?),
    appointments:
        (json['appointments'] as List?)
            ?.map((e) => Appointment.fromJson(e as Map))
            .toList() ??
        const [],
    measures:
        (json['measures'] as List?)
            ?.map((e) => Measure.fromJson(e as Map))
            .toList() ??
        const [],
    record:
        (json['record'] as List?)
            ?.map((e) => HealthRecord.fromJson(e as Map))
            .toList() ??
        const [],
    partner: json['partner'] != null
        ? Partner.fromJson(json['partner'] as Map)
        : null,
    baby: json['baby'] != null ? Baby.fromJson(json['baby'] as Map) : null,
    babyLog:
        (json['babyLog'] as List?)
            ?.map((e) => BabyLogEntry.fromJson(e as Map))
            .toList() ??
        const [],
    country: json['country'] as String? ?? 'Côte d\'Ivoire',
    language: json['language'] as String? ?? 'Français',
    theme: json['theme'] as String? ?? 'light',
    prePregnancyWeightKg: (json['prePregnancyWeightKg'] as num?)?.toDouble(),
    heightM: (json['heightM'] as num?)?.toDouble(),
    onboarded: json['onboarded'] as bool? ?? false,
  );
}
