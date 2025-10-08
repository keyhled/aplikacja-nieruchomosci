import Foundation
import CoreLocation

class RestaurantService: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    init() {
        setupLocationManager()
        loadSampleData()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadSampleData() {
        restaurants = Restaurant.sampleRestaurants
        filteredRestaurants = restaurants
    }
    
    func searchRestaurants(query: String) {
        guard !query.isEmpty else {
            filteredRestaurants = restaurants
            return
        }
        
        filteredRestaurants = restaurants.filter { restaurant in
            restaurant.name.localizedCaseInsensitiveContains(query) ||
            restaurant.cuisine.localizedCaseInsensitiveContains(query) ||
            restaurant.address.localizedCaseInsensitiveContains(query)
        }
    }
    
    func filterByAccessibility(filters: Set<String>) {
        guard !filters.isEmpty else {
            filteredRestaurants = restaurants
            return
        }
        
        filteredRestaurants = restaurants.filter { restaurant in
            let availableFeatures = restaurant.accessibilityFeatures.availableFeatures
            return filters.allSatisfy { filter in
                availableFeatures.contains(filter)
            }
        }
    }
    
    func filterByPriceRange(_ priceRange: PriceRange?) {
        guard let priceRange = priceRange else {
            return
        }
        
        filteredRestaurants = filteredRestaurants.filter { restaurant in
            restaurant.priceRange == priceRange
        }
    }
    
    func filterByCuisine(_ cuisine: String?) {
        guard let cuisine = cuisine, !cuisine.isEmpty else {
            return
        }
        
        filteredRestaurants = filteredRestaurants.filter { restaurant in
            restaurant.cuisine.localizedCaseInsensitiveContains(cuisine)
        }
    }
    
    func sortByDistance() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        filteredRestaurants.sort { restaurant1, restaurant2 in
            let location1 = CLLocation(latitude: restaurant1.location.latitude, longitude: restaurant1.location.longitude)
            let location2 = CLLocation(latitude: restaurant2.location.latitude, longitude: restaurant2.location.longitude)
            
            let distance1 = currentLocation.distance(from: location1)
            let distance2 = currentLocation.distance(from: location2)
            
            return distance1 < distance2
        }
    }
    
    func sortByRating() {
        filteredRestaurants.sort { $0.rating > $1.rating }
    }
    
    func getDistance(to restaurant: Restaurant) -> String {
        guard let currentLocation = currentLocation else {
            return "Odległość nieznana"
        }
        
        let restaurantLocation = CLLocation(
            latitude: restaurant.location.latitude,
            longitude: restaurant.location.longitude
        )
        
        let distance = currentLocation.distance(from: restaurantLocation)
        
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }
    
    func getRestaurantsNearby(radius: Double = 5000) -> [Restaurant] {
        guard let currentLocation = currentLocation else {
            return []
        }
        
        return restaurants.filter { restaurant in
            let restaurantLocation = CLLocation(
                latitude: restaurant.location.latitude,
                longitude: restaurant.location.longitude
            )
            let distance = currentLocation.distance(from: restaurantLocation)
            return distance <= radius
        }
    }
    
    func refreshLocation() {
        locationManager.requestLocation()
    }
}

extension RestaurantService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        sortByDistance()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        errorMessage = "Nie można pobrać lokalizacji: \(error.localizedDescription)"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            errorMessage = "Aplikacja nie ma dostępu do lokalizacji. Włącz lokalizację w ustawieniach."
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}