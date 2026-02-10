# GDA MFT Overview Dashboard

Dashboard do monitorowania nieprawidłości operacyjnych w systemie Material Flow Technology w centrum logistycznym.

## Opis projektu

Dashboard GDA_MFT_Overview służy do monitorowania parametrów pracy systemów sortujących oraz identyfikacji nieprawidłowości operacyjnych. Umożliwia analizę danych zarówno w czasie rzeczywistym, jak i historycznym, z uwzględnieniem opóźnienia przetwarzania danych.

### Podstawowe funkcjonalności

- Monitorowanie zdarzeń operacyjnych 
- Analiza wydajności linii 
- Tracking parametrów 
- Szczegółowa analiza nieprawidłowości operacyjnych

## Architektura

### Stack technologiczny

- **Grafana** - wizualizacja danych i dashboardowanie
- **PostgreSQL** - baza danych operacyjnych
- **DataGrip** - środowisko do tworzenia i testowania zapytań SQL
- **Google Sheets** - prototyp pierwotnej wersji dashboardu

### Struktura dashboardu

Dashboard podzielony jest na cztery główne sekcje:

1. **Zdarzenia** - główna część zliczania zdarzeń operacyjnych
2. **Multi, Single, BI, HV** - wizualizacja wyników z poszczególnych linii
3. **Shipping** - dane dotyczące zrzutni, posortowanych paczek, chute full, read ratio oraz NOK
4. **Optimus - NIO** - szczegółowa analiza nieprawidłowości operacyjnych

## Źródła danych

Dashboard wykorzystuje trzy główne tabele PostgreSQL:

### oee_counters
Zawiera dane o ilości paczek z linii oraz systemu sortującego:
- Linie 
- Zrzutnie 
- Skanery

### oee_events
Przechowuje zdarzenia operacyjne:
- Product jam
- Emergency stop (button, pull cord, area)
- Chute full
- Product out of dimensions (too long, too wide, too high)

### oee_gda_sort
Dane z systemu Inconso dla sorterów Optimus:
- NIO (nieprawidłowość operacyjna)
- Ilości posortowanych elementów
- Read ratio

## Zapytania SQL

### oee_counters.sql
Oblicza sumy posortowanych elementów oraz wskaźnik skuteczności odczytów (read ratio).

**Główne funkcje:**
- Przypisanie zmian (shift_id) na podstawie lokalnego czasu
- Agregacja danych z linii i zrzutni
- Obliczanie read_ratio dla skanera outbound
- Obsługa wartości NULL przez COALESCE

### oee_events.sql
Zlicza zdarzenia operacyjne i wylicza czas ich trwania.

**Główne funkcje:**
- Przypisanie shift_id, line_id oraz event_id
- Zliczanie liczby wystąpień zdarzeń (count)
- Obliczanie czasu trwania zdarzeń (duration)
- Utworzenie klucza identyfikacyjnego w formacie shift_line_event

### oee_gda_sort.sql
Agreguje błędy NIO i oblicza read_ratio dla sorterów.

**Główne funkcje:**
- Wyodrębnienie numeru sortera (sorter_id)
- Obliczanie średniego read_ratio
- Sumowanie wszystkich typów błędów NIO
- Zabezpieczenie pustych wartości

## Podział na zmiany

Wszystkie zapytania uwzględniają podział na dwie zmiany robocze:

- **Zmiana 1:** 
- **Zmiana 2:** 

Takie podejście umożliwia:
- Analizę danych wyłącznie z godzin procesu
- Porównania międzyzmianowe
- Identyfikację różnic w zachowaniach operacyjnych

## Konwencje nazewnicze

### Identyfikatory linii (line_id)
- 1-5: Multi Line 1-5
- 6: Big Item
- 7: High Value
- 8: Single Line (stara część)
- 9: Single Line (nowa część - Sital Right)
- 18-43: Zrzutnie (218-243)
- 44: NOK (oddzielna zrzutnia)
- 10: Waste Line

### Identyfikatory zdarzeń (event_id)
- 100: Product jam
- 110: Product out of dimensions (too long/wide/high)
- 120: Chute full
- 130: Emergency stop (button/pull cord/area)

### Identyfikatory sorterów (sorter_id)
- 20, 25, 30, 35: Main Sorters
- 40, 45: Presorters

## Przetwarzanie danych w Grafanie

Dane wymagają dodatkowego przetworzenia w Grafanie:

1. **Agregacja różnic** - interwał 1 godzina (diff)
2. **Filtrowanie** - transformacja > 0 dla usunięcia wartości zerowych
3. **Reduce transformation** - uproszczenie zestawień

Te transformacje umożliwiają poprawną analizę wielodniową.

## Wspólne cechy implementacji SQL

Wszystkie zapytania wykorzystują:

1. **CTE (Common Table Expressions)** - wydzielenie warstwy klasyfikującej i agregującej
2. **Klasyfikacja zmian** - przypisanie shift_id na podstawie lokalnego czasu
3. **COALESCE** - obsługa wartości NULL w agregacjach
4. **Klucze logiczne** - unikalne identyfikatory dla wizualizacji w Grafanie

## Struktura katalogów

```
gda-mft-overview-dashboard/
├── README.md
├── docs/
│   └── Dashboard_GDA_MFT_Overview.pdf
├── sql/
│   ├── oee_counters.sql
│   ├── oee_events.sql
│   └── oee_gda_sort.sql
└── images/
    ├── 1.jpg (Dashboard - Shift 1 & 2 Overview)
    ├── 2.jpg (Events Detail View)
    ├── 3.jpg (Chutes Sorted Analysis)
    └── 4.jpg (Optimus NIO Breakdown)
```

## Możliwe rozszerzenia

1. **Progi w Grafanie** - automatyczna zmiana wizualna po osiągnięciu wartości krytycznych
2. **Porównania międzyzmianowe** - wykresy kołowe z proporcją rozkładu zdarzeń
3. **Wartości średnie** - wskaźniki typu średni czas trwania product jam
4. **Integracja z PLC Optimus** - automatyczne pozyskiwanie danych (Whisker, Reject chute, Gap, Vision)

## Wymagania systemowe

- PostgreSQL 12+
- Grafana 8.0+
- Dostęp do tabel: oee_counters, oee_events, oee_gda_sort

## Licencja

Dokumentacja i kod SQL stanowią własność zespołu technicznego.

## Kontakt

Dla pytań technicznych lub sugestii dotyczących dashboardu, skontaktuj się z autorem.
