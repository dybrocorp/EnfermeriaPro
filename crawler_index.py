import requests
from bs4 import BeautifulSoup
import json
import time
import random
import re

BASE_URL = "https://www.vademecum.es"
START_URL = "https://www.vademecum.es/colombia/co/alfa"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

def get_soup(url):
    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        return BeautifulSoup(response.text, 'lxml')
    except Exception as e:
        print(f"Error al cargar {url}: {e}")
        return None

def crawl_index():
    all_medication_links = []
    
    # Letras principales A-Z
    letters = [chr(i) for i in range(ord('a'), ord('z') + 1)]
    # Añadir 0-9 si existe
    letters.append("0-9")

    for letter in letters:
        print(f"--- Procesando letra: {letter.upper()} ---")
        letter_url = f"{START_URL}/{letter}"
        soup = get_soup(letter_url)
        if not soup: continue

        # Encontrar subniveles (Aa, Ab, Ac...)
        # Los subniveles suelen estar en una lista de enlaces dentro de la página de la letra
        sub_links = []
        # Buscamos enlaces que tengan el patrón /alfa/[letter]/[sub]
        for a in soup.find_all('a', href=True):
            href = a['href']
            # Regex para detectar subniveles: /colombia/co/alfa/a/b
            if re.search(rf"/colombia/co/alfa/{letter}/[a-z]", href):
                full_href = BASE_URL + href if href.startswith('/') else href
                if full_href not in sub_links:
                    sub_links.append(full_href)

        if not sub_links:
            # Si no hay subniveles, la página de la letra tiene los resultados directamente
            sub_links = [letter_url]
        else:
            print(f"Encontrados {len(sub_links)} subniveles para {letter.upper()}")

        for sub_url in sub_links:
            print(f"  Extrayendo de: {sub_url}")
            sub_soup = get_soup(sub_url)
            if not sub_soup: continue

            # Extraer medicamentos
            # Los medicamentos suelen estar en una lista div#list-results o similar
            # Buscamos enlaces a /colombia/medicamento/
            found_count = 0
            for a in sub_soup.find_all('a', href=True):
                href = a['href']
                if "/colombia/medicamento/" in href:
                    name = a.get_text(strip=True)
                    full_href = BASE_URL + href if href.startswith('/') else href
                    all_medication_links.append({
                        "name": name,
                        "url": full_href
                    })
                    found_count += 1
            
            print(f"    -> Encontrados {found_count} medicamentos.")
            time.sleep(random.uniform(0.5, 1.5)) # Respetuoso

    # Guardar resultados
    output_file = "full_vademecum_index.json"
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_medication_links, f, indent=4, ensure_ascii=False)
    
    print(f"\n¡Indexación terminada! Total de medicamentos encontrados: {len(all_medication_links)}")
    print(f"Resultados guardados en {output_file}")

if __name__ == "__main__":
    crawl_index()
