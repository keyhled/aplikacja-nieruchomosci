import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Konfiguracja dostępności
        setupAccessibility()
        
        // Konfiguracja wyglądu
        setupAppearance()
        
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
    }
    
    // MARK: - Private Methods
    private func setupAccessibility() {
        // Włącz obsługę VoiceOver
        UIAccessibility.post(notification: .screenChanged, argument: nil)
        
        // Konfiguracja dla użytkowników z problemami wzroku
        if UIAccessibility.isVoiceOverRunning {
            // Dodatkowe ustawienia dla VoiceOver
        }
        
        // Konfiguracja dla użytkowników z problemami słuchu
        if UIAccessibility.isAssistiveTouchRunning {
            // Dodatkowe ustawienia dla AssistiveTouch
        }
    }
    
    private func setupAppearance() {
        // Konfiguracja wyglądu aplikacji
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }
        
        // Konfiguracja dla wysokiego kontrastu
        if UIAccessibility.isDarkerSystemColorsEnabled {
            // Ustawienia dla wysokiego kontrastu
        }
    }
}