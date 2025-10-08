import Foundation
import CoreLocation

struct Restaurant: Identifiable, Codable {
    let id = UUID()
    let name: String
    let address: String
    let phone: String?
    let website: String?
    let rating: Double
    let priceRange: PriceRange
    let cuisine: String
    let location: CLLocationCoordinate2D
    let accessibilityFeatures: AccessibilityFeatures
    let openingHours: [OpeningHours]
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name, address, phone, website, rating, priceRange, cuisine, accessibilityFeatures, openingHours, imageURL
    }
    
    init(name: String, address: String, phone: String? = nil, website: String? = nil, rating: Double, priceRange: PriceRange, cuisine: String, latitude: Double, longitude: Double, accessibilityFeatures: AccessibilityFeatures, openingHours: [OpeningHours] = [], imageURL: String? = nil) {
        self.name = name
        self.address = address
        self.phone = phone
        self.website = website
        self.rating = rating
        self.priceRange = priceRange
        self.cuisine = cuisine
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.accessibilityFeatures = accessibilityFeatures
        self.openingHours = openingHours
        self.imageURL = imageURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        rating = try container.decode(Double.self, forKey: .rating)
        priceRange = try container.decode(PriceRange.self, forKey: .priceRange)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        accessibilityFeatures = try container.decode(AccessibilityFeatures.self, forKey: .accessibilityFeatures)
        openingHours = try container.decodeIfPresent([OpeningHours].self, forKey: .openingHours) ?? []
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(website, forKey: .website)
        try container.encode(rating, forKey: .rating)
        try container.encode(priceRange, forKey: .priceRange)
        try container.encode(cuisine, forKey: .cuisine)
        try container.encode(accessibilityFeatures, forKey: .accessibilityFeatures)
        try container.encode(openingHours, forKey: .openingHours)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encode(location.latitude, forKey: .latitude)
        try container.encode(location.longitude, forKey: .longitude)
    }
}

enum PriceRange: String, CaseIterable, Codable {
    case budget = "$"
    case moderate = "$$"
    case expensive = "$$$"
    case veryExpensive = "$$$$"
    
    var displayName: String {
        switch self {
        case .budget: return "Tani"
        case .moderate: return "Umiarkowany"
        case .expensive: return "Drogi"
        case .veryExpensive: return "Bardzo drogi"
        }
    }
}

struct AccessibilityFeatures: Codable {
    let wheelchairAccessible: Bool
    let hasElevator: Bool
    let hasRamp: Bool
    let accessibleParking: Bool
    let accessibleRestroom: Bool
    let brailleMenu: Bool
    let largePrintMenu: Bool
    let audioMenu: Bool
    let signLanguageStaff: Bool
    let quietEnvironment: Bool
    let dimLighting: Bool
    let highContrast: Bool
    let glutenFreeOptions: Bool
    let veganOptions: Bool
    let allergenInformation: Bool
    
    var availableFeatures: [String] {
        var features: [String] = []
        if wheelchairAccessible { features.append("Dostęp dla wózków inwalidzkich") }
        if hasElevator { features.append("Winda") }
        if hasRamp { features.append("Rampa") }
        if accessibleParking { features.append("Miejsca parkingowe dla niepełnosprawnych") }
        if accessibleRestroom { features.append("Toaleta dla niepełnosprawnych") }
        if brailleMenu { features.append("Menu w alfabecie Braille'a") }
        if largePrintMenu { features.append("Menu z dużym drukiem") }
        if audioMenu { features.append("Menu audio") }
        if signLanguageStaff { features.append("Personel znający język migowy") }
        if quietEnvironment { features.append("Ciche otoczenie") }
        if dimLighting { features.append("Przyciemnione oświetlenie") }
        if highContrast { features.append("Wysoki kontrast") }
        if glutenFreeOptions { features.append("Opcje bezglutenowe") }
        if veganOptions { features.append("Opcje wegańskie") }
        if allergenInformation { features.append("Informacje o alergenach") }
        return features
    }
}

struct OpeningHours: Codable {
    let dayOfWeek: DayOfWeek
    let openTime: String
    let closeTime: String
    let isClosed: Bool
    
    enum DayOfWeek: String, CaseIterable, Codable {
        case monday = "Poniedziałek"
        case tuesday = "Wtorek"
        case wednesday = "Środa"
        case thursday = "Czwartek"
        case friday = "Piątek"
        case saturday = "Sobota"
        case sunday = "Niedziela"
    }
}

// Przykładowe dane restauracji
extension Restaurant {
    static let sampleRestaurants: [Restaurant] = [
        Restaurant(
            name: "Restauracja U Jana",
            address: "ul. Główna 15, Warszawa",
            phone: "+48 22 123 45 67",
            website: "https://ujana.pl",
            rating: 4.5,
            priceRange: .moderate,
            cuisine: "Polska",
            latitude: 52.2297,
            longitude: 21.0122,
            accessibilityFeatures: AccessibilityFeatures(
                wheelchairAccessible: true,
                hasElevator: false,
                hasRamp: true,
                accessibleParking: true,
                accessibleRestroom: true,
                brailleMenu: false,
                largePrintMenu: true,
                audioMenu: false,
                signLanguageStaff: false,
                quietEnvironment: false,
                dimLighting: false,
                highContrast: false,
                glutenFreeOptions: true,
                veganOptions: true,
                allergenInformation: true
            ),
            openingHours: [
                OpeningHours(dayOfWeek: .monday, openTime: "10:00", closeTime: "22:00", isClosed: false),
                OpeningHours(dayOfWeek: .tuesday, openTime: "10:00", closeTime: "22:00", isClosed: false),
                OpeningHours(dayOfWeek: .wednesday, openTime: "10:00", closeTime: "22:00", isClosed: false),
                OpeningHours(dayOfWeek: .thursday, openTime: "10:00", closeTime: "22:00", isClosed: false),
                OpeningHours(dayOfWeek: .friday, openTime: "10:00", closeTime: "23:00", isClosed: false),
                OpeningHours(dayOfWeek: .saturday, openTime: "10:00", closeTime: "23:00", isClosed: false),
                OpeningHours(dayOfWeek: .sunday, openTime: "12:00", closeTime: "21:00", isClosed: false)
            ]
        ),
        Restaurant(
            name: "Bistro Francuskie",
            address: "ul. Francuska 8, Warszawa",
            phone: "+48 22 987 65 43",
            website: "https://bistrofrancuskie.pl",
            rating: 4.2,
            priceRange: .expensive,
            cuisine: "Francuska",
            latitude: 52.2200,
            longitude: 21.0150,
            accessibilityFeatures: AccessibilityFeatures(
                wheelchairAccessible: true,
                hasElevator: true,
                hasRamp: false,
                accessibleParking: true,
                accessibleRestroom: true,
                brailleMenu: true,
                largePrintMenu: true,
                audioMenu: true,
                signLanguageStaff: true,
                quietEnvironment: true,
                dimLighting: true,
                highContrast: false,
                glutenFreeOptions: true,
                veganOptions: false,
                allergenInformation: true
            )
        ),
        Restaurant(
            name: "Pizza Corner",
            address: "ul. Włoska 22, Warszawa",
            phone: "+48 22 555 12 34",
            website: "https://pizzacorner.pl",
            rating: 4.0,
            priceRange: .budget,
            cuisine: "Włoska",
            latitude: 52.2350,
            longitude: 21.0080,
            accessibilityFeatures: AccessibilityFeatures(
                wheelchairAccessible: false,
                hasElevator: false,
                hasRamp: false,
                accessibleParking: false,
                accessibleRestroom: false,
                brailleMenu: false,
                largePrintMenu: false,
                audioMenu: false,
                signLanguageStaff: false,
                quietEnvironment: false,
                dimLighting: false,
                highContrast: false,
                glutenFreeOptions: true,
                veganOptions: true,
                allergenInformation: true
            )
        )
    ]
}