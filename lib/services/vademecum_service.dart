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
  final String indicaciones;
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
    required this.indicaciones,
    required this.contraindicaciones,
    required this.efectosAdversos,
    required this.interacciones,
    required this.laboratorios,
    required this.categoriaEmbarazo,
    required this.atc,
    required this.isPremium,
  });
}

class VademecumService {
  static List<Medicamento>? _cachedList;

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
        // Hacer los primeros 30 medicamentos gratuitos, el resto premium
        bool premiumStatus = count > 30;
        
        return Medicamento(
          nombre: item['Nombre generico'] ?? 'Sin nombre',
          marcaComun: item['Marca comun'] ?? 'N/A',
          grupoFarmacologico: item['Grupo farmacologico'] ?? 'N/A',
          subgrupo: item['Subgrupo'] ?? 'N/A',
          presentacion: item['Presentacion'] ?? 'N/A',
          dosisAdulto: item['Dosis adulto referencial'] ?? 'N/A',
          dosisPediatrica: item['Dosis pediatrica referencial'] ?? 'N/A',
          viaAdministracion: item['Via administracion'] ?? 'N/A',
          indicaciones: item['Indicaciones principales'] ?? 'N/A',
          contraindicaciones: item['Contraindicaciones'] ?? 'N/A',
          efectosAdversos: item['Efectos adversos comunes'] ?? 'N/A',
          interacciones: item['Interacciones importantes'] ?? 'N/A',
          laboratorios: item['Laboratorios comunes Colombia'] ?? 'N/A',
          categoriaEmbarazo: item['Categoria embarazo'] ?? 'N/A',
          atc: item['ATC aproximado'] ?? 'N/A',
          isPremium: premiumStatus,
        );
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
}
