# Aplikacja Ogłoszenia Nieruchomości

## Autor
[Twoje imię i nazwisko]
[Numer indeksu]

## Opis projektu
Aplikacja internetowa do zarządzania ogłoszeniami sprzedaży nieruchomości, zbudowana w języku Java z wykorzystaniem Spring Boot.

## Spełnione wymagania (na ocenę 3,5):
✅ Formularz z wprowadzaniem danych (dodawanie ogłoszenia)
✅ Połączenie z bazą danych (H2 Database)
✅ Architektura MVC (Model-View-Controller)

## Technologie
- Java 11
- Spring Boot 2.7.0
- Spring MVC
- Spring Data JPA
- Thymeleaf
- H2 Database
- Maven

## Struktura projektu
- Model: Property.java
- View: pliki HTML z Thymeleaf
- Controller: PropertyController.java
- Repository: PropertyRepository.java
- Service: PropertyService.java

## Uruchomienie
1. Wymagania: Java 11+, Maven
2. Polecenie: `mvn spring-boot:run`
3. Aplikacja dostępna pod: http://localhost:8080

## Funkcjonalności
- Wyświetlanie listy ogłoszeń
- Dodawanie nowych ogłoszeń przez formularz
- Wyświetlanie szczegółów ogłoszenia
- Przechowywanie danych w bazie H2
