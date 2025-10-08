import UIKit
import SwiftUI

class AccessibilityManager: ObservableObject {
    @Published var isLargeTextEnabled: Bool = false
    @Published var isHighContrastEnabled: Bool = false
    @Published var isBoldTextEnabled: Bool = false
    @Published var isVoiceOverEnabled: Bool = false
    @Published var fontSize: CGFloat = 17.0
    @Published var selectedAccessibilityFilters: Set<String> = []
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadSettings()
        setupAccessibilityObservers()
    }
    
    private func loadSettings() {
        isLargeTextEnabled = userDefaults.bool(forKey: "isLargeTextEnabled")
        isHighContrastEnabled = userDefaults.bool(forKey: "isHighContrastEnabled")
        isBoldTextEnabled = userDefaults.bool(forKey: "isBoldTextEnabled")
        fontSize = CGFloat(userDefaults.double(forKey: "fontSize"))
        if fontSize == 0 { fontSize = 17.0 }
        
        if let savedFilters = userDefaults.array(forKey: "accessibilityFilters") as? [String] {
            selectedAccessibilityFilters = Set(savedFilters)
        }
    }
    
    private func saveSettings() {
        userDefaults.set(isLargeTextEnabled, forKey: "isLargeTextEnabled")
        userDefaults.set(isHighContrastEnabled, forKey: "isHighContrastEnabled")
        userDefaults.set(isBoldTextEnabled, forKey: "isBoldTextEnabled")
        userDefaults.set(Double(fontSize), forKey: "fontSize")
        userDefaults.set(Array(selectedAccessibilityFilters), forKey: "accessibilityFilters")
    }
    
    private func setupAccessibilityObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessibilitySettingsChanged),
            name: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessibilitySettingsChanged),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func accessibilitySettingsChanged() {
        DispatchQueue.main.async {
            self.isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
            self.updateFontSize()
        }
    }
    
    private func updateFontSize() {
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        switch contentSizeCategory {
        case .extraSmall:
            fontSize = 12.0
        case .small:
            fontSize = 14.0
        case .medium:
            fontSize = 17.0
        case .large:
            fontSize = 20.0
        case .extraLarge:
            fontSize = 24.0
        case .extraExtraLarge:
            fontSize = 28.0
        case .extraExtraExtraLarge:
            fontSize = 32.0
        case .accessibilityMedium:
            fontSize = 36.0
        case .accessibilityLarge:
            fontSize = 40.0
        case .accessibilityExtraLarge:
            fontSize = 44.0
        case .accessibilityExtraExtraLarge:
            fontSize = 48.0
        case .accessibilityExtraExtraExtraLarge:
            fontSize = 52.0
        default:
            fontSize = 17.0
        }
        
        if isLargeTextEnabled {
            fontSize *= 1.2
        }
    }
    
    func toggleLargeText() {
        isLargeTextEnabled.toggle()
        updateFontSize()
        saveSettings()
    }
    
    func toggleHighContrast() {
        isHighContrastEnabled.toggle()
        saveSettings()
    }
    
    func toggleBoldText() {
        isBoldTextEnabled.toggle()
        saveSettings()
    }
    
    func setFontSize(_ size: CGFloat) {
        fontSize = size
        saveSettings()
    }
    
    func toggleAccessibilityFilter(_ filter: String) {
        if selectedAccessibilityFilters.contains(filter) {
            selectedAccessibilityFilters.remove(filter)
        } else {
            selectedAccessibilityFilters.insert(filter)
        }
        saveSettings()
    }
    
    func getAccessibilityFont() -> UIFont {
        let baseFont = UIFont.systemFont(ofSize: fontSize)
        if isBoldTextEnabled {
            return UIFont.boldSystemFont(ofSize: fontSize)
        }
        return baseFont
    }
    
    func getAccessibilityColors() -> (foreground: UIColor, background: UIColor) {
        if isHighContrastEnabled {
            return (UIColor.black, UIColor.white)
        } else {
            return (UIColor.label, UIColor.systemBackground)
        }
    }
    
    func getAccessibilityTrait() -> UIAccessibilityTraits {
        var traits: UIAccessibilityTraits = []
        if isVoiceOverEnabled {
            traits.insert(.button)
        }
        return traits
    }
    
    // Dostępne filtry dostępności
    static let availableFilters = [
        "Dostęp dla wózków inwalidzkich",
        "Winda",
        "Rampa",
        "Miejsca parkingowe dla niepełnosprawnych",
        "Toaleta dla niepełnosprawnych",
        "Menu w alfabecie Braille'a",
        "Menu z dużym drukiem",
        "Menu audio",
        "Personel znający język migowy",
        "Ciche otoczenie",
        "Przyciemnione oświetlenie",
        "Wysoki kontrast",
        "Opcje bezglutenowe",
        "Opcje wegańskie",
        "Informacje o alergenach"
    ]
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}