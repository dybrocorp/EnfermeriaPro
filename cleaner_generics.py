import json
import re

def clean_name(name):
    # 1. Convertir a mayúsculas
    name = name.upper()
    
    # 2. Lista de laboratorios y marcas comunes (expandible)
    labs = [
        "GENFAR", "MK", "TECNOQUÍMICAS", "TQ", "VITALIS", "PROCAPS", "FARMALOGICA", 
        "EUGIA", "PUNISKA", "AMERICAN GENERICS", "PENTACOOP", "BIOSANO", "SANDERSON",
        "FRESENIUS KABI", "HUMAX", "ROSSBLANK", "MEGALABS", "EUROFARMA", "ABBVIE",
        "LICOL", "RYAN", "COLMED", "COFAREN", "BIO ESTERIL", "MEDYSEH", "UNIPHARM",
        "BLAU", "VENUS", "VAXTHERA", "ROPSOHN", "PATMAR", "BLUEPHARMA", "LA SANTÉ",
        "MEMPHIS", "ECAR", "LAPROFF", "BUSSIE", "RICHMOND", "ALMIPRO", "VICKMIEL",
        "MERCK", "BAYER", "PFIZER", "NOVARTIS", "SANOFI", "ROCHE", "GLAXO", "GSK",
        "ABBOTT", "ASTRAZENECA", "JANSSEN", "LILLY", "BOEHRINGER", "TAKEDA", "GILEAD",
        "AMGEN", "BIOGEN", "MYLAN", "TEVA", "SANDOZ", "SUN PHARMA", "CIPLA",
        "LUPIN", "DR. REDDY", "AUROBINDO", "ZENTIVA", "APOTEX", "STADA", "ZYDUS",
        "CLARIPACK", "SALUS PHARMA", "AFAVEL", "COASPHARMA", "ANGLOPHARMA", "TECNOFAR",
        "QUIFARMA", "SETTA", "VIE DE COLOMBIA", "SICMAFARMA", "NOVAMED", "LABINCO",
        "N.T.I", "C.I FARMACAPSULA"
    ]
    
    # Eliminar laboratorios y sufijos de propiedad
    for lab in labs:
        name = re.sub(rf"\b{lab}(\s+S\.A\.S\.?)?\b", "", name)
    
    # 3. Eliminar dosis y presentaciones comunes (más agresivo)
    patterns = [
        r"\d+\s*(MG|G|ML|MCG|UI|U|%|GR|UI)\b", # Dosis
        r"\d+/\d+\s*(MG|G|ML|MCG|UI|U|%)\b", # Dosis combinada
        r"\b(TABLETA|TAB|CAPSULA|CAP|COMPRIMIDO|COMP|SOL|INY|SUSP|GEL|CREMA|UNG|OFTALMICA|NASAL|ORAL|TOPICA|AMPOLLA|FRASCO|VIAL|SOBRE|GRANULADO|PARCHE|AEROSOL|JARABE|ELIXIR|LOCION|CHAMPU|PULVO|LIOF|POLVO|INFUS|RETARD|LP|SR|CR|X|FORTE|PLUS|DUO|MASTICABLE|EFERVESCENTE|GOTAS|RECUBIERTA|RECUB|LIQUIDO|SPRAY|VAGINAL|RECTAL|OTICA|INYECTABLE|PEDIATRICO|ADULTO|NF|GEL|CREMA|UNGÜENTO|UNGUENTO|ACEITE|POLVO)\b",
        r"\d+\s*MG/\d+\s*MG", 
        r"\d+\s*MG/\d+\s*ML",
        r"\d+\s*G/\d+\s*ML",
        r"\d+\s*G/\d+\s*G",
    ]
    
    for p in patterns:
        name = re.sub(p, "", name)
    
    # 4. Limpiar caracteres especiales y espacios extra
    # Eliminar todo lo que siga a un slash solitario o doble slash al final
    name = re.sub(r"\s*/.*$", "", name)
    name = re.sub(r"/+$", "", name)
    
    name = re.sub(r"[^\w\s\+]", " ", name) # Mantener + para combinaciones
    name = re.sub(r"\s+", " ", name).strip()
    
    # 5. Si después de limpiar queda algo como "ACETAMINOFEN 500", quitar el número suelto
    name = re.sub(r"\s\d+$", "", name).strip()
    
    # 6. Eliminar palabras cortas de ruido al final
    noise_end = r"\b(DE|EN|LA|PARA|CON|DEL)\b$"
    name = re.sub(noise_end, "", name).strip()
    
    return name

def process_index():
    input_file = "full_vademecum_index.json"
    output_file = "unique_generics_targets.json"
    
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"Error: {input_file} no encontrado. ¿Terminó el crawler?")
        return

    unique_generics = {}
    
    for item in data:
        raw_name = item['name']
        generic = clean_name(raw_name)
        
        # Filtros adicionales
        if len(generic) < 3: continue
        if generic in ["AGUA", "SOLUCION", "ESTÉRIL"]: continue
        
        if generic not in unique_generics:
            unique_generics[generic] = {
                "name": generic,
                "example_raw": raw_name,
                "url": item['url']
            }
            
    # Convertir a lista y guardar
    results = list(unique_generics.values())
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=4, ensure_ascii=False)
        
    print(f"Proceso de limpieza terminado.")
    print(f"Total links analizados: {len(data)}")
    print(f"Total genéricos únicos detectados: {len(results)}")
    print(f"Resultados guardados en {output_file}")

if __name__ == "__main__":
    process_index()
