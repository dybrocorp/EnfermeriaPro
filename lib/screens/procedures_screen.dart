import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'procedure_detail_screen.dart';

class ProceduresScreen extends StatelessWidget {
  const ProceduresScreen({super.key});

  final List<Map<String, dynamic>> _procedures = const [
    {
      'title': 'Venopunción y Canalización Periférica',
      'description': 'Procedimiento para insertar un catéter en una vena periférica para administración de fluidos o medicamentos.',
      'icon': Icons.bloodtype,
      'materials': [
        'Guantes no estériles',
        'Torniquete',
        'Torundas algodonadas con alcohol al 70%',
        'Catéter venoso periférico (Yelco) del calibre adecuado',
        'Esparadrapo o apósito transparente (Tegaderm)',
        'Solución salina o equipo de venoclisis',
        'Contenedor de objetos punzocortantes'
      ],
      'steps': [
        'Lavarse las manos y explicar el procedimiento al paciente.',
        'Colocar al paciente en una posición cómoda y seleccionar la vena adecuada.',
        'Colocar el torniquete 10-15 cm por encima del sitio de punción.',
        'Ponerse los guantes.',
        'Realizar asepsia del sitio de punción del centro a la periferia y dejar secar.',
        'Fijar la vena traccionando la piel hacia abajo y puncionar con el bisel hacia arriba en un ángulo de 15 a 30 grados.',
        'Al observar retorno venoso, disminuir el ángulo y avanzar el catéter de plástico mientras se retira parcialmente la aguja guía (fiador).',
        'Soltar el torniquete.',
        'Retirar completamente la aguja guía y desechar en el contenedor de punzocortantes.',
        'Conectar el equipo de infusión o tapón heparinizado.',
        'Fijar el catéter con el apósito transparente y rotular con fecha, calibre y nombre de quien instaló.'
      ]
    },
    {
      'title': 'Sondaje Vesical Femenino/Masculino',
      'description': 'Técnica aséptica para introducir una sonda a través de la uretra hasta la vejiga urinaria.',
      'icon': Icons.opacity,
      'materials': [
        'Guantes estériles y no estériles',
        'Solución antiséptica o jabón quirúrgico',
        'Gasas estériles y campo hendido estéril',
        'Sonda Foley de calibre adecuado (ej. 14-16 Fr)',
        'Lubricante urológico estéril (lidocaína al 2% en gel)',
        'Jeringa de 10 cc con agua bidestilada',
        'Bolsa recolectora de orina (Cistofló)'
      ],
      'steps': [
        'Higiene de manos y explicar el procedimiento al paciente.',
        'Colocar al paciente en decúbito supino (posición ginecológica en mujeres).',
        'Lavado de genitales con técnica aséptica, con guantes no estériles.',
        'Cambio a guantes estériles y colocación de campo estéril.',
        'Comprobar la integridad del globo de la sonda insuflando con agua bidestilada y desinuflando.',
        'Lubricar generosamente la punta de la sonda.',
        'En hombres: retraer el prepucio, mantener el pene a 90°. En mujeres: separar los labios mayores y menores para identificar el meato urinario.',
        'Introducir la sonda de forma suave hasta que haya retorno de orina.',
        'Insoualar el globo con el volumen de agua indicado en la válvula de la sonda (generalmente 10 cc).',
        'Traccionar suavemente para asegurar que el globo hace tope en el cuello vesical.',
        'Conectar la sonda a la bolsa recolectora y fijar a la pierna del paciente para evitar tirones.'
      ]
    },
    {
      'title': 'RCP Básico (Soporte Vital Básico)',
      'description': 'Técnica de reanimación cardiopulmonar para mantener la circulación y ventilación en caso de paro.',
      'icon': Icons.health_and_safety,
      'materials': [
        'Equipo de protección personal (guantes, mascarilla)',
        'DEA (Desfibrilador Externo Automático) si está disponible',
        'Mascarilla de bolsillo o bolsa-válvula-mascarilla (Ambu)'
      ],
      'steps': [
        'Asegurar el área y comprobar el estado de consciencia del paciente ("¿Señor/a, está usted bien?").',
        'Si no responde, pedir ayuda inmediatamente (Activar sistema de emergencia) y solicitar un DEA.',
        'Comprobar respiración y pulso carotídeo simultáneamente por no más de 10 segundos.',
        'Si no hay pulso, iniciar compresiones torácicas inmediatamente: 30 compresiones.',
        'Profundidad de al menos 5 cm (2 pulgadas) a un ritmo de 100-120 por minuto, permitiendo la re-expansión torácica.',
        'Dar 2 ventilaciones (si se cuenta con dispositivo de barrera) observando la elevación del tórax (Duración 1 segundo por ventilación).',
        'Relación 30 compresiones : 2 ventilaciones.',
        'En cuanto llegue el DEA, encenderlo y seguir las instrucciones auditivas.',
        'Minimizar las interrupciones en las compresiones a menos de 10 segundos.',
        'Continuar RCP hasta que llegue el equipo avanzado o el paciente recupere consciencia/pulso.'
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Procedimientos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _procedures.length,
        itemBuilder: (context, index) {
          final proc = _procedures[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                child: Icon(proc['icon'], color: AppColors.primaryDark),
              ),
              title: Text(
                proc['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  proc['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProcedureDetailScreen(procedure: proc),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
