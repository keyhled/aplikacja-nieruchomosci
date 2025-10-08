# FoodForAll - Aplikacja do wyszukiwania restauracji z funkcjami dostępności

## Opis aplikacji

FoodForAll to aplikacja iOS napisana w Swift, która pomaga użytkownikom znajdować restauracje w pobliżu z naciskiem na dostępność dla osób z różnymi niepełnosprawnościami. Aplikacja została stworzona zgodnie z ideą przedstawioną w załączniku - skupia się na funkcjach przydatnych dla osób z różnymi dysfunkcjami i normalizuje różne tryby wyświetlania oraz filtracji.

## Główne funkcje

### 🔍 Wyszukiwanie restauracji
- Wyszukiwanie po nazwie, kuchni lub adresie
- Sortowanie według odległości lub oceny
- Filtrowanie według zakresu cenowego

### ♿ Funkcje dostępności
- **Duży tekst** - możliwość powiększenia czcionki
- **Wysoki kontrast** - tryb wysokiego kontrastu dla lepszej czytelności
- **Pogrubiony tekst** - opcja pogrubienia tekstu
- **Obsługa VoiceOver** - pełna kompatybilność z czytnikiem ekranu
- **Filtry dostępności** - wyszukiwanie restauracji według funkcji dostępności

### 🏪 Informacje o restauracjach
- Podstawowe informacje (nazwa, adres, telefon, strona internetowa)
- Ocena i zakres cenowy
- Godziny otwarcia
- Mapa z lokalizacją
- Szczegółowe informacje o dostępności

### 🎯 Filtry dostępności
Aplikacja umożliwia filtrowanie restauracji według następujących funkcji dostępności:
- Dostęp dla wózków inwalidzkich
- Winda
- Rampa
- Miejsca parkingowe dla niepełnosprawnych
- Toaleta dla niepełnosprawnych
- Menu w alfabecie Braille'a
- Menu z dużym drukiem
- Menu audio
- Personel znający język migowy
- Ciche otoczenie
- Przyciemnione oświetlenie
- Wysoki kontrast
- Opcje bezglutenowe
- Opcje wegańskie
- Informacje o alergenach

## Struktura projektu

```
FoodForAll/
├── Models/
│   └── Restaurant.swift              # Model danych restauracji
├── ViewControllers/
│   ├── RestaurantListViewController.swift    # Lista restauracji
│   └── RestaurantDetailViewController.swift # Szczegóły restauracji
├── Services/
│   ├── AccessibilityManager.swift   # Zarządzanie funkcjami dostępności
│   └── RestaurantService.swift      # Serwis restauracji
├── AppDelegate.swift
├── SceneDelegate.swift
├── Main.storyboard
├── LaunchScreen.storyboard
├── Assets.xcassets/
└── Info.plist
```

## Wymagania systemowe

- iOS 17.0+
- Xcode 15.0+
- Swift 5.0+

## Instrukcja uruchomienia

1. **Otwórz projekt w Xcode**
   ```bash
   open FoodForAll.xcodeproj
   ```

2. **Wybierz docelowe urządzenie**
   - iPhone (symulator lub fizyczne urządzenie)
   - iPad (symulator lub fizyczne urządzenie)

3. **Uruchom aplikację**
   - Naciśnij `Cmd + R` lub kliknij przycisk "Run"

## Konfiguracja uprawnień

Aplikacja wymaga następujących uprawnień (już skonfigurowanych w Info.plist):

- **Lokalizacja** - do znajdowania restauracji w pobliżu
- **Dostępność** - do obsługi funkcji dostępności

## Funkcje dostępności

### Dla użytkowników z problemami wzroku
- Obsługa VoiceOver
- Wysoki kontrast
- Duży tekst
- Pogrubiony tekst

### Dla użytkowników z problemami słuchu
- Wizualne wskaźniki
- Tekstowe komunikaty

### Dla użytkowników z problemami ruchowymi
- Duże przyciski
- Łatwa nawigacja
- Obsługa Switch Control

## Przykładowe dane

Aplikacja zawiera przykładowe dane restauracji z różnymi funkcjami dostępności:
- Restauracja U Jana (polska kuchnia, umiarkowane ceny)
- Bistro Francuskie (francuska kuchnia, drogie, pełne funkcje dostępności)
- Pizza Corner (włoska kuchnia, tanie, ograniczone funkcje dostępności)

## Rozwój aplikacji

### Dodawanie nowych restauracji
Edytuj plik `Restaurant.swift` i dodaj nowe restauracje do tablicy `sampleRestaurants`.

### Dodawanie nowych funkcji dostępności
1. Dodaj nowe właściwości do struktury `AccessibilityFeatures`
2. Zaktualizuj listę `availableFilters` w `AccessibilityManager`
3. Dodaj nowe opcje do interfejsu użytkownika

### Integracja z API
Aby połączyć aplikację z prawdziwym API restauracji:
1. Zastąp `RestaurantService` implementacją korzystającą z API
2. Dodaj obsługę błędów sieciowych
3. Zaimplementuj cache'owanie danych

## Licencja

Ten projekt jest dostępny na licencji MIT. Zobacz plik LICENSE dla szczegółów.

## Autor

Aplikacja została stworzona zgodnie z ideą przedstawioną w załączniku, skupiając się na dostępności i normalizacji różnych trybów wyświetlania dla wszystkich użytkowników.