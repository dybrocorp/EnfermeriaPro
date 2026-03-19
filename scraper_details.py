import requests
from bs4 import BeautifulSoup
import json
import time
import random
import re

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

ATC_MAP = {
    'A': 'Digestivo y Metabólico',
    'B': 'Sangre y Hematopoyéticos',
    'C': 'Cardiovascular',
    'D': 'Dermatológicos',
    'G': 'Genitourinario y Hormonas',
    'H': 'Hormonales Sistémicos',
    'J': 'Antiinfecciosos',
    'L': 'Antineoplásicos',
    'M': 'Musculoesquelético',
    'N': 'Sistema Nervioso (Psiquiátricos)',
    'P': 'Antiparasitarios',
    'R': 'Sistema Respiratorio',
    'S': 'Órganos de los Sentidos',
    'V': 'Varios'
}

def get_category_from_atc(atc_str):
    if not atc_str: return "Otros"
    # El ATC suele ser una letra seguida de números, ej: N02BE01
    first_char = atc_str.strip().upper()[:1]
    return ATC_MAP.get(first_char, "Otros")

def extract_presentation(raw_name, generic_clean):
    # Intentar sacar la parte de la dosis y forma
    # ABACAR 300 mg Tab. recubierta -> 300 mg Tab. recubierta
    # Eliminamos el nombre genérico y laboratorios comunes
    p = raw_name.upper()
    p = p.replace(generic_clean.upper(), "").strip()
    
    # Quitar marcas/labs comunes si quedaron
    labs = ["GENFAR", "MK", "TECNOQUÍMICAS", "TQ", "VITALIS", "PROCAPS", "LA SANTÉ", "HUMAX", "COLMED", "ABBOTT"]
    for lab in labs:
        p = re.sub(rf"\b{lab}\b", "", p)
    
    return re.sub(r"\s+", " ", p).strip()

def get_text_after_header(soup, header_text):
    # Busca un encabezado (h1, h2, h3) que contenga el texto buscado
    for header in soup.find_all(['h1', 'h2', 'h3']):
        if header_text.lower() in header.get_text().lower():
            # El contenido suele estar en el siguiente elemento (p, div, etc)
            content = []
            curr = header.find_next_sibling()
            while curr and curr.name not in ['h1', 'h2', 'h3']:
                content.append(curr.get_text(strip=True))
                curr = curr.find_next_sibling()
            return " ".join(content)
    return ""

def scrape_medication(url):
    try:
        response = requests.get(url, headers=headers, timeout=20)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'lxml')
        
        data = {
            "atc": get_text_after_header(soup, "ATC"),
            "mecanismo": get_text_after_header(soup, "Mecanismo de acción"),
            "indicaciones": get_text_after_header(soup, "Indicaciones terapéuticas"),
            "posologia": get_text_after_header(soup, "Posología"),
            "contraindicaciones": get_text_after_header(soup, "Contraindicaciones")
        }
        return data
    except Exception as e:
        print(f"Error raspando {url}: {e}")
        return None

def main():
    input_file = "unique_generics_targets.json"
    output_file = "full_vademecum_data.json"
    
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            targets = json.load(f)
    except FileNotFoundError:
        print(f"Error: {input_file} no encontrado.")
        return

    # Cargar progreso previo si existe
    try:
        with open(output_file, 'r', encoding='utf-8') as f:
            data_list = json.load(f)
            # Reconstruir el diccionario para búsqueda rápida
            final_data = {item['Nombre generico']: item for item in data_list}
    except:
        final_data = {}

    print(f"Iniciando raspado de {len(targets)} genéricos...")
    
    count = 0
    for target in targets:
        name = target['name']
        if name in final_data:
            continue
            
        print(f"Procesando ({count}/{len(targets)}): {name}")
        details = scrape_medication(target['url'])
        
        if details:
            atc = details.get("atc", "")
            cat = get_category_from_atc(atc)
            pres = extract_presentation(target['example_raw'], name)
            
            final_data[name] = {
                "Nombre generico": name,
                "Categoria": cat,
                "Presentacion": pres if pres else target['example_raw'],
                "Indicaciones": details.get("indicaciones", ""),
                "Dosificacion": details.get("posologia", ""),
                "Contraindicaciones": details.get("contraindicaciones", ""),
                "ATC": atc,
                "Mecanismo": details.get("mecanismo", "")
            }
            
            # Guardar cada 10 para no perder progreso
            if count % 10 == 0:
                with open(output_file, 'w', encoding='utf-8') as f:
                    json.dump(list(final_data.values()), f, indent=4, ensure_ascii=False)
        
        count += 1
        time.sleep(random.uniform(2.0, 5.0))
        
        # Límite para el ciclo actual
        if count >= 3000: 
            print("Alcanzado límite de 3000 para este ciclo.")
            break

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(list(final_data.values()), f, indent=4, ensure_ascii=False)
    
    print(f"Raspado finalizado. Total guardado: {len(final_data)}")

if __name__ == "__main__":
    main()
