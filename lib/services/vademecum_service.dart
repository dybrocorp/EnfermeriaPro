import 'dart:convert';
import 'package:flutter/services.dart';

class Medicamento {
  final String nombre;
  final String marcaComun;
  final String grupoFarmacologico;
  final String subgrupo;
  final String presentacion;
  final String dosisAdulto;
  final String dosisPediatrica;
  final String viaAdministracion;
  final String sirvePara;
  final String contraindicaciones;
  final String efectosAdversos;
  final String interacciones;
  final String laboratorios;
  final String categoriaEmbarazo;
  final String atc;
  final bool isPremium;

  Medicamento({
    required this.nombre,
    required this.marcaComun,
    required this.grupoFarmacologico,
    required this.subgrupo,
    required this.presentacion,
    required this.dosisAdulto,
    required this.dosisPediatrica,
    required this.viaAdministracion,
    required this.sirvePara,
    required this.contraindicaciones,
    required this.efectosAdversos,
    required this.interacciones,
    required this.laboratorios,
    required this.categoriaEmbarazo,
    required this.atc,
    required this.isPremium,
  });

  factory Medicamento.fromMap(Map<String, dynamic> data, {bool premium = false}) {
    return Medicamento(
      nombre: data['Nombre generico'] ?? 'Sin nombre',
      marcaComun: data['Marca comun'] ?? 'N/A',
      grupoFarmacologico: data['Grupo farmacologico'] ?? 'Sin Categoría',
      subgrupo: data['Subgrupo'] ?? 'N/A',
      presentacion: data['Presentacion'] ?? 'N/A',
      dosisAdulto: data['Dosis adulto referencial'] ?? 'N/A',
      dosisPediatrica: data['Dosis pediatrica referencial'] ?? 'N/A',
      viaAdministracion: data['Via administracion'] ?? 'N/A',
      sirvePara: data['Sirve para'] ?? data['Indicaciones principales'] ?? 'No especificado',
      contraindicaciones: data['Contraindicaciones'] ?? 'No especificado',
      efectosAdversos: data['Efectos adversos comunes'] ?? 'N/A',
      interacciones: data['Interacciones importantes'] ?? 'N/A',
      laboratorios: data['Laboratorios comunes Colombia'] ?? 'N/A',
      categoriaEmbarazo: data['Categoria embarazo'] ?? 'N/A',
      atc: data['ATC aproximado'] ?? 'N/A',
      isPremium: data['isPremium'] ?? premium,
    );
  }
}

class VademecumService {
  static List<Medicamento>? _cachedList;
  static const int _freeLimit = 30;

  static Future<List<Medicamento>> getMedicamentos() async {
    if (_cachedList != null) return _cachedList!;

    try {
      final ByteData data = await rootBundle.load('assets/data/medicamentos_colombia.json');
      final Uint8List bytes = data.buffer.asUint8List();
      final String jsonString = const Utf8Decoder().convert(bytes);
      final List<dynamic> jsonList = jsonDecode(jsonString);

      int count = 0;
      _cachedList = jsonList.map((item) {
        count++;
        return Medicamento.fromMap(item as Map<String, dynamic>, premium: count > _freeLimit);
      }).toList();

      return _cachedList!;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Medicamento>> search(String query) async {
    final list = await getMedicamentos();
    if (query.isEmpty) return list;

    final lowerQuery = query.toLowerCase();
    return list.where((m) {
      return m.nombre.toLowerCase().contains(lowerQuery) ||
          m.grupoFarmacologico.toLowerCase().contains(lowerQuery) ||
          m.marcaComun.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static void clearCache() {
    _cachedList = null;
  }
}
