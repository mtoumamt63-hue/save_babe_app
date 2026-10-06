import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_keys.dart';
import '../errors/exceptions.dart';

/// Interface pour le service de stockage local NoSQL (Hive)
abstract class LocalStorageService {
  Future<void> init();
  Future<void> save(String boxName, String key, dynamic value);
  T? get<T>(String boxName, String key, {T? defaultValue});
  Future<void> delete(String boxName, String key);
  List<T> getAll<T>(String boxName);
  Map<dynamic, dynamic> getMap(String boxName);
  Future<void> clear(String boxName);
  Future<void> clearAll();
}

/// Implémentation Hive du LocalStorageService
class LocalStorageServiceImpl implements LocalStorageService {
  static const List<String> _allBoxes = [
    AppKeys.userStateBox,
    AppKeys.appointmentsBox,
    AppKeys.measuresBox,
    AppKeys.healthRecordsBox,
    AppKeys.babyBox,
    AppKeys.babyLogBox,
    AppKeys.chatHistoryBox,
  ];

  @override
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      for (final boxName in _allBoxes) {
        if (!Hive.isBoxOpen(boxName)) {
          await Hive.openBox(boxName);
        }
      }
    } catch (e) {
      throw StorageException('Échec de l\'initialisation de Hive', cause: e);
    }
  }

  Box _getBox(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw StorageException('La boîte Hive "$boxName" n\'est pas ouverte');
    }
    return Hive.box(boxName);
  }

  @override
  Future<void> save(String boxName, String key, dynamic value) async {
    try {
      final box = _getBox(boxName);
      await box.put(key, value);
    } catch (e) {
      throw StorageException('Erreur d\'écriture ($boxName:$key)', cause: e);
    }
  }

  @override
  T? get<T>(String boxName, String key, {T? defaultValue}) {
    try {
      final box = _getBox(boxName);
      return box.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      throw StorageException('Erreur de lecture ($boxName:$key)', cause: e);
    }
  }

  @override
  Future<void> delete(String boxName, String key) async {
    try {
      final box = _getBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw StorageException('Erreur de suppression ($boxName:$key)', cause: e);
    }
  }

  @override
  List<T> getAll<T>(String boxName) {
    try {
      final box = _getBox(boxName);
      return box.values.cast<T>().toList();
    } catch (e) {
      throw StorageException(
        'Erreur de récupération de tous les éléments ($boxName)',
        cause: e,
      );
    }
  }

  @override
  Map<dynamic, dynamic> getMap(String boxName) {
    try {
      final box = _getBox(boxName);
      return box.toMap();
    } catch (e) {
      throw StorageException(
        'Erreur de conversion de boîte en Map ($boxName)',
        cause: e,
      );
    }
  }

  @override
  Future<void> clear(String boxName) async {
    try {
      final box = _getBox(boxName);
      await box.clear();
    } catch (e) {
      throw StorageException(
        'Erreur lors du vidage de la boîte ($boxName)',
        cause: e,
      );
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      for (final boxName in _allBoxes) {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).clear();
        }
      }
    } catch (e) {
      throw StorageException(
        'Erreur lors de la réinitialisation de toutes les boîtes',
        cause: e,
      );
    }
  }
}
