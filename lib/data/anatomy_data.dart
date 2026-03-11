class AnatomySystem {
  final String key;
  final String name;
  final String emoji;
  final String funcion;
  final String anatomia;
  final List<String> patologias;
  final List<String> medicamentos;
  final List<String> cuidados;
  final List<String> procedimientos;

  const AnatomySystem({
    required this.key,
    required this.name,
    required this.emoji,
    required this.funcion,
    required this.anatomia,
    required this.patologias,
    required this.medicamentos,
    required this.cuidados,
    required this.procedimientos,
  });
}

const Map<String, AnatomySystem> anatomySystems = {
  'cardiovascular': AnatomySystem(
    key: 'cardiovascular',
    name: 'Sistema Cardiovascular',
    emoji: '❤️',
    funcion:
        'Transportar oxígeno, nutrientes y hormonas a todos los tejidos mediante el bombeo continuo del corazón. Eliminar CO₂ y productos metabólicos de desecho.',
    anatomia:
        '4 cámaras: 2 aurículas + 2 ventrículos. Circulación mayor (sistémica) y menor (pulmonar). FC normal: 60–100 lpm. Gasto cardíaco en reposo: ~5 L/min.',
    patologias: [
      'Infarto agudo de miocardio (IAM)',
      'Hipertensión arterial',
      'Insuficiencia cardíaca congestiva (ICC)',
      'Fibrilación auricular',
      'Trombosis venosa profunda (TVP)',
      'Accidente cerebrovascular (ACV)',
    ],
    medicamentos: [
      'Enalapril / Losartán — IECA / ARA II (HTA)',
      'Furosemida — Diurético de asa (ICC)',
      'Heparina / Warfarina — Anticoagulantes',
      'Amiodarona — Antiarrítmico',
      'Aspirina — Antiagregante plaquetario',
      'Atorvastatina — Hipolipemiante',
    ],
    cuidados: [
      'Control de signos vitales cada 4 horas',
      'Monitoreo continuo de ECG en cuidado crítico',
      'Balance hídrico estricto (ingresos / egresos)',
      'Posición Fowler 45° en paciente con ICC',
      'Restricción de sodio y líquidos según indicación',
      'Valoración de pulsos periféricos y llenado capilar',
      'Educación sobre adherencia al tratamiento',
    ],
    procedimientos: [
      'Electrocardiograma (ECG) de 12 derivaciones',
      'Inserción de vía venosa periférica',
      'Reanimación cardiopulmonar (RCP)',
      'Desfibrilación / Cardioversión sincronizada',
      'Monitoreo de presión arterial invasiva (PAI)',
      'Administración de medicamentos intravenosos',
    ],
  ),

  'respiratorio': AnatomySystem(
    key: 'respiratorio',
    name: 'Sistema Respiratorio',
    emoji: '🫁',
    funcion:
        'Intercambio gaseoso (hematosis): aportar O₂ a la sangre y eliminar CO₂. Participar en la regulación del equilibrio ácido-base y pH sanguíneo.',
    anatomia:
        'Vías altas: fosas nasales, faringe, laringe. Vías bajas: tráquea, bronquios, bronquíolos, alvéolos (~300 millones). FR normal adulto: 12–20 rpm. SpO₂ normal: 95–100%.',
    patologias: [
      'EPOC (bronquitis crónica + enfisema)',
      'Asma bronquial',
      'Neumonía (bacteriana, viral)',
      'Tuberculosis pulmonar',
      'Neumotórax',
      'Síndrome de distrés respiratorio agudo (SDRA)',
    ],
    medicamentos: [
      'Salbutamol — Broncodilatador β₂ (acción corta)',
      'Ipratropio — Anticolinérgico broncodilatador',
      'Budesonida — Corticosteroide inhalado',
      'Amoxicilina / Azitromicina — Antibióticos',
      'Acetilcisteína — Mucolítico',
      'Teofilina — Broncodilatador xantínico',
    ],
    cuidados: [
      'Posición Fowler 90° para facilitar la ventilación',
      'Oxigenoterapia: SpO₂ objetivo 94–98%',
      'Fisioterapia respiratoria y percusión torácica',
      'Técnica de tos efectiva y controlada',
      'Vigilar patrón respiratorio y uso de músculos accesorios',
      'Humidificación de vía aérea',
      'Control de secreciones: color, consistencia, cantidad',
    ],
    procedimientos: [
      'Oxigenoterapia (gafas nasales, mascarilla, Venturi)',
      'Nebulización de broncodilatadores',
      'Aspiración de secreciones (técnica estéril)',
      'Espirometría',
      'Inserción de tubo de tórax (drenaje pleural)',
      'Asistencia en intubación orotraqueal',
    ],
  ),

  'nervioso': AnatomySystem(
    key: 'nervioso',
    name: 'Sistema Nervioso',
    emoji: '🧠',
    funcion:
        'Integración y coordinación de todas las funciones corporales. Recepción sensorial, procesamiento central y respuesta motora. Control de funciones vitales como respiración y temperatura.',
    anatomia:
        'SNC: Encéfalo (cerebro, cerebelo, tronco encefálico) y Médula espinal. SNP: 31 pares de nervios espinales + 12 pares craneales. SNAutonómico: Simpático (adrenérgico) y Parasimpático (colinérgico).',
    patologias: [
      'Accidente cerebrovascular (ACV / Ictus)',
      'Traumatismo craneoencefálico (TCE)',
      'Epilepsia',
      'Enfermedad de Alzheimer',
      'Enfermedad de Parkinson',
      'Meningitis / Encefalitis',
    ],
    medicamentos: [
      'Fenitoína / Valproato — Antiepilépticos',
      'Alteplasa (rtPA) — Trombolítico (ACV isquémico)',
      'Levodopa + Carbidopa — Antiparkinsonianos',
      'Donepezilo — Inhibidor colinesterasa (Alzheimer)',
      'Manitol — Diurético osmótico (HTE)',
      'Morfina — Analgésico (dolor neuropático severo)',
    ],
    cuidados: [
      'Escala de Glasgow cada 1–4 horas',
      'Prevención de caídas: barandas, alarmas de cama',
      'Posición cabecera 30–45° en hipertensión intracraneal',
      'Control neurológico: pupilas, reflejos, fuerza',
      'Manejo de agitación psicomotriz con seguridad',
      'Rehabilitación neurológica temprana',
      'Comunicación alternativa si hay afasia',
    ],
    procedimientos: [
      'Valoración neurológica (Glasgow, NIHSS, pupilas)',
      'Punción lumbar (técnica estéril)',
      'Electroencefalograma (EEG)',
      'Preparación para TC o RMN cerebral',
      'Manejo de vía aérea (Glasgow < 8)',
      'Monitoreo de presión intracraneal (PIC)',
    ],
  ),

  'oseo': AnatomySystem(
    key: 'oseo',
    name: 'Sistema Óseo',
    emoji: '🦴',
    funcion:
        'Soporte estructural del cuerpo. Protección de órganos vitales. Producción de células sanguíneas (hematopoyesis en médula roja). Almacenamiento de calcio y fósforo.',
    anatomia:
        '206 huesos en el adulto. Tejido óseo compacto (cortical) y esponjoso (trabecular). La médula ósea roja produce eritrocitos, leucocitos y plaquetas. Remodelación ósea continua.',
    patologias: [
      'Fracturas (simple, conminuta, expuesta)',
      'Osteoporosis',
      'Artritis reumatoide',
      'Osteomielitis',
      'Osteosarcoma',
      'Escoliosis / Cifosis / Lordosis patológica',
    ],
    medicamentos: [
      'Alendronato / Risedronato — Bifosfonatos (osteoporosis)',
      'Calcio + Vitamina D — Suplementación minerales',
      'Ibuprofeno / Diclofenaco — AINEs (dolor/inflamación)',
      'Tramadol / Morfina — Analgésicos opioides',
      'Metotrexato — DMARD (artritis reumatoide)',
      'Clindamicina / Vancomicina — Antibióticos (osteomielitis)',
    ],
    cuidados: [
      'Control del dolor con escala EVA',
      'Inmovilización y alineación correcta del miembro',
      'Inspección de piel bajo yeso o tracción',
      'Prevención de úlceras por presión',
      'Movilización precoz supervisada',
      'Valoración neurovascular: pulso, color, temperatura, sensibilidad',
      'Educación sobre prevención de caídas',
    ],
    procedimientos: [
      'Inmovilización con yeso o férula de yeso',
      'Tracción esquelética o cutánea',
      'Cuidado de fijador externo (limpieza de clavos)',
      'Control radiológico evolutivo de fractura',
      'Fisioterapia y rehabilitación funcional',
      'Preparación para cirugía ortopédica',
    ],
  ),

  'muscular': AnatomySystem(
    key: 'muscular',
    name: 'Sistema Muscular',
    emoji: '💪',
    funcion:
        'Producir movimiento y locomoción. Mantener postura y estabilidad articular. Producir calor corporal (termogénesis). El diafragma e intercostales permiten la respiración.',
    anatomia:
        'Más de 600 músculos (~40% del peso corporal). Tipos: Esquelético (voluntario, estriado), Liso (involuntario, vísceras) y Cardíaco (involuntario, estriado). Propiedades: excitabilidad, contractilidad, extensibilidad, elasticidad.',
    patologias: [
      'Distrofia muscular de Duchenne',
      'Miastenia gravis',
      'Fibromialgia',
      'Rabdomiólisis',
      'Síndrome compartimental',
      'Contracturas y desgarros musculares',
    ],
    medicamentos: [
      'Metocarbamol / Tizanidina — Relajantes musculares',
      'Ibuprofeno / Naproxeno — AINEs antiinflamatorios',
      'Piridostigmina — Inhibidor colinesterasa (miastenia)',
      'Prednisona — Corticosteroide (miopatías inflamatorias)',
      'Gabapentina — Dolor neuropático (fibromialgia)',
      'Toxina botulínica — Espasticidad muscular',
    ],
    cuidados: [
      'Movilización pasiva y activo-asistida',
      'Cambios posturales cada 2 horas en inmovilizados',
      'Crioterapia (fase aguda) / Termoterapia (fase crónica)',
      'Valorar fuerza muscular (escala 0–5 MRC)',
      'Prevenir atrofia por desuso',
      'Vendaje compresivo en desgarros musculares',
      'Ejercicios de amplitud de movimiento (ROM)',
    ],
    procedimientos: [
      'Fisioterapia activa y pasiva',
      'Electroterapia (TENS) para alivio del dolor',
      'Electromiografía (EMG)',
      'Ecografía musculoesquelética',
      'Kinesiotape / Vendaje funcional',
      'Fasciotomía urgente (síndrome compartimental)',
    ],
  ),

  'digestivo': AnatomySystem(
    key: 'digestivo',
    name: 'Sistema Digestivo',
    emoji: '🫃',
    funcion:
        'Ingestión, digestión mecánica y química, absorción de nutrientes y eliminación de residuos. Las glándulas anexas (hígado, páncreas) producen enzimas y hormonas esenciales.',
    anatomia:
        'Tubo: Boca → Esófago → Estómago → Intestino delgado (6–7 m) → Intestino grueso (1.5 m) → Recto → Ano. Glándulas: Hígado (bilis), Páncreas (insulina + enzimas digestivas). pH gástrico: 1.5–3.5.',
    patologias: [
      'Gastroenteritis aguda',
      'Úlcera péptica gastroduodenal',
      'Cirrosis hepática',
      'Pancreatitis aguda',
      'Enfermedad de Crohn / Colitis ulcerosa',
      'Cáncer colorrectal',
    ],
    medicamentos: [
      'Omeprazol / Pantoprazol — Inhibidores de bomba de protones',
      'Metoclopramida / Ondansetrón — Antieméticos',
      'Bisacodilo / Lactulosa — Laxantes',
      'Loperamida — Antidiarreico',
      'Metronidazol — Antibiótico (H. pylori / anaerobios)',
      'Ácido ursodeoxicólico — Hepatoprotector',
    ],
    cuidados: [
      'Dieta adaptada a patología (ayuno, blanda, hipocalórica)',
      'Control de náuseas, vómitos y distensión abdominal',
      'Cuidado y permeabilidad de sonda nasogástrica (SNG)',
      'Higiene y cuidado de ostomía (colostomía / ileostomía)',
      'Monitorear ruidos intestinales (auscultación)',
      'Hidratación parenteral durante ayuno',
      'Valorar características de heces (consistencia, color, sangre)',
    ],
    procedimientos: [
      'Inserción y cuidado de sonda nasogástrica (SNG)',
      'Enema evacuante o de limpieza',
      'Cuidado de colostomía / ileostomía',
      'Preparación para endoscopia digestiva',
      'Lavado gástrico en intoxicación oral',
      'Administración de nutrición enteral (NE)',
    ],
  ),

  'urinario': AnatomySystem(
    key: 'urinario',
    name: 'Sistema Urinario',
    emoji: '🫘',
    funcion:
        'Filtración de la sangre (~180 L/día). Formación y excreción de orina. Regulación del equilibrio hídrico, electrolítico y ácido-base. Producción de eritropoyetina y activación de vitamina D.',
    anatomia:
        'Dos riñones (filtran 125 mL/min c/u), dos uréteres (25–30 cm), vejiga urinaria (capacidad 400–600 mL), uretra. Unidad funcional: la nefrona. Diuresis normal adulto: 800–2000 mL/día.',
    patologias: [
      'Infección de vías urinarias (IVU / cistitis)',
      'Pielonefritis aguda',
      'Insuficiencia renal aguda (IRA)',
      'Enfermedad renal crónica (ERC)',
      'Litiasis renal (cálculos)',
      'Síndrome nefrótico / Glomerulonefritis',
    ],
    medicamentos: [
      'Ciprofloxacino / Trimetoprima — Antibióticos (IVU)',
      'Furosemida — Diurético de asa (edema / ERC)',
      'Eritropoyetina alfa — Anemia renal crónica',
      'Carbonato cálcico — Quelante de fósforo',
      'Bicarbonato sódico — Corrección de acidosis metabólica',
      'Tamsulosina — Alfa-bloqueante (litiasis / HBP)',
    ],
    cuidados: [
      'Balance hídrico cada 8–24 horas',
      'Control de diuresis horaria en paciente crítico',
      'Higiene perineal adecuada para prevenir IVU',
      'Cuidado de catéter vesical (circuito cerrado estéril)',
      'Valorar características de orina: color, olor, turbidez',
      'Control de laboratorio: urea, creatinina, electrolitos',
      'Restricción de potasio y fósforo en ERC avanzada',
    ],
    procedimientos: [
      'Sondaje vesical (Foley) con técnica estéril',
      'Control de diuresis horaria',
      'Toma de urocultivo por sonda o micción media',
      'Preparación para hemodiálisis o diálisis peritoneal',
      'Irrigación vesical continua',
      'Preparación para cistoscopia o litotricia extracorpórea',
    ],
  ),

  'endocrino': AnatomySystem(
    key: 'endocrino',
    name: 'Sistema Endocrino',
    emoji: '⚗️',
    funcion:
        'Regulación hormonal del metabolismo, crecimiento y desarrollo, función reproductora, equilibrio hídrico y homeostasis. Comunica órganos a través de hormonas transportadas en la sangre.',
    anatomia:
        'Glándulas principales: Hipófisis (maestra), Tiroides, Paratiroides, Suprarrenales, Páncreas endocrino (islotes de Langerhans), Gónadas. Las hormonas actúan sobre órganos diana mediante receptores específicos.',
    patologias: [
      'Diabetes mellitus tipo 1 y tipo 2',
      'Hipotiroidismo / Hipertiroidismo',
      'Síndrome de Cushing',
      'Insuficiencia suprarrenal (Addison)',
      'Hiperparatiroidismo',
      'Acromegalia / Gigantismo hipofisario',
    ],
    medicamentos: [
      'Insulina (rápida, NPH, Glargina) — Diabetes mellitus',
      'Metformina — Antidiabético oral (biguanida)',
      'Levotiroxina — Hipotiroidismo',
      'Metimazol / Propiltiouracilo — Hipertiroidismo',
      'Hidrocortisona — Insuficiencia suprarrenal (Addison)',
      'Octreótido — Análogo somatostatina (acromegalia)',
    ],
    cuidados: [
      'Glucometría capilar antes de comidas y de aplicar insulina',
      'Verificar técnica correcta de inyección subcutánea de insulina',
      'Reconocer y tratar hipoglucemia (regla 15–15)',
      'Control de peso, circunferencia abdominal e IMC',
      'Cuidado de pies en diabético (neuropatía periférica)',
      'Educación diabetológica para autocuidado',
      'Vigilar síntomas de crisis tiroidea (tormenta tiroidea)',
    ],
    procedimientos: [
      'Glucometría capilar (pinchazo en dedo)',
      'Curva de glucemia (SOG 75 g)',
      'Administración de insulina subcutánea',
      'Control de HbA1c (hemoglobina glicosilada)',
      'Pruebas de función tiroidea (TSH, T3, T4 libre)',
      'Test de estimulación suprarrenal (test de Synacthen)',
    ],
  ),
};
