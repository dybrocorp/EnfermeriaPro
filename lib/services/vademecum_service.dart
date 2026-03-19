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
      marcaComun: data['Laboratorio'] ?? 'N/A', // Usamos Laboratorio como marca común para mostrarlo en el subtítulo
      grupoFarmacologico: data['Categoria'] ?? 'Sin Categoría',
      subgrupo: data['ATC'] ?? 'N/A',
      presentacion: data['Presentacion'] ?? 'Consultar',
      dosisAdulto: data['Dosificacion'] ?? 'Ver detalles',
      dosisPediatrica: 'Según peso (ver detalles)',
      viaAdministracion: data['Via'] ?? 'Oral/Inyectable',
      sirvePara: data['Indicaciones'] ?? 'No especificado',
      contraindicaciones: data['Contraindicaciones'] ?? 'No especificado',
      efectosAdversos: data['Mecanismo'] ?? 'N/A',
      interacciones: 'Ver precauciones',
      laboratorios: data['Laboratorio'] ?? 'N/A',
      categoriaEmbarazo: 'Consultar riesgo',
      atc: data['ATC'] ?? 'N/A',
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
