import UIKit
import MapKit
import CoreLocation

class RestaurantDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var accessibilityStackView: UIStackView!
    @IBOutlet weak var openingHoursStackView: UIStackView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    
    // MARK: - Properties
    var restaurant: Restaurant!
    var accessibilityManager: AccessibilityManager!
    var restaurantService: RestaurantService!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureRestaurantDetails()
        setupMapView()
        setupAccessibilityFeatures()
        setupOpeningHours()
        setupAccessibility()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Szczegóły"
        navigationItem.largeTitleDisplayMode = .never
        
        // Ustawienia przycisków
        callButton.setTitle("Zadzwoń", for: .normal)
        websiteButton.setTitle("Strona internetowa", for: .normal)
        directionsButton.setTitle("Nawiguj", for: .normal)
        
        // Style przycisków
        [callButton, websiteButton, directionsButton].forEach { button in
            button?.layer.cornerRadius = 8
            button?.backgroundColor = .systemBlue
            button?.setTitleColor(.white, for: .normal)
        }
        
        // Ukryj przyciski jeśli brak danych
        callButton.isHidden = restaurant.phone == nil
        websiteButton.isHidden = restaurant.website == nil
    }
    
    private func configureRestaurantDetails() {
        // Podstawowe informacje
        nameLabel.text = restaurant.name
        cuisineLabel.text = restaurant.cuisine
        ratingLabel.text = String(format: "%.1f ⭐", restaurant.rating)
        priceLabel.text = restaurant.priceRange.displayName
        addressLabel.text = restaurant.address
        
        // Telefon
        if let phone = restaurant.phone {
            phoneLabel.text = phone
            phoneLabel.isHidden = false
        } else {
            phoneLabel.isHidden = true
        }
        
        // Strona internetowa
        if let website = restaurant.website {
            websiteLabel.text = website
            websiteLabel.isHidden = false
        } else {
            websiteLabel.isHidden = true
        }
        
        // Obrazek (placeholder)
        restaurantImageView.image = UIImage(systemName: "photo")
        restaurantImageView.contentMode = .scaleAspectFill
        restaurantImageView.clipsToBounds = true
        restaurantImageView.layer.cornerRadius = 8
        
        // Ustawienia dostępności dla etykiet
        applyAccessibilitySettings()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // Dodaj adnotację dla restauracji
        let annotation = MKPointAnnotation()
        annotation.coordinate = restaurant.location
        annotation.title = restaurant.name
        annotation.subtitle = restaurant.address
        mapView.addAnnotation(annotation)
        
        // Ustaw region mapy
        let region = MKCoordinateRegion(
            center: restaurant.location,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: false)
    }
    
    private func setupAccessibilityFeatures() {
        // Wyczyść istniejące widoki
        accessibilityStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let features = restaurant.accessibilityFeatures.availableFeatures
        
        if features.isEmpty {
            let noFeaturesLabel = UILabel()
            noFeaturesLabel.text = "Brak informacji o dostępności"
            noFeaturesLabel.textColor = .systemGray
            noFeaturesLabel.font = accessibilityManager.getAccessibilityFont()
            accessibilityStackView.addArrangedSubview(noFeaturesLabel)
        } else {
            for feature in features {
                let featureView = createAccessibilityFeatureView(feature: feature)
                accessibilityStackView.addArrangedSubview(featureView)
            }
        }
    }
    
    private func createAccessibilityFeatureView(feature: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 8
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
        iconImageView.tintColor = .systemGreen
        iconImageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = feature
        label.font = accessibilityManager.getAccessibilityFont()
        label.numberOfLines = 0
        label.textColor = accessibilityManager.getAccessibilityColors().foreground
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        return containerView
    }
    
    private func setupOpeningHours() {
        // Wyczyść istniejące widoki
        openingHoursStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if restaurant.openingHours.isEmpty {
            let noHoursLabel = UILabel()
            noHoursLabel.text = "Brak informacji o godzinach otwarcia"
            noHoursLabel.textColor = .systemGray
            noHoursLabel.font = accessibilityManager.getAccessibilityFont()
            openingHoursStackView.addArrangedSubview(noHoursLabel)
        } else {
            for hours in restaurant.openingHours {
                let hoursView = createOpeningHoursView(hours: hours)
                openingHoursStackView.addArrangedSubview(hoursView)
            }
        }
    }
    
    private func createOpeningHoursView(hours: OpeningHours) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 8
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        let dayLabel = UILabel()
        dayLabel.text = hours.dayOfWeek.rawValue
        dayLabel.font = accessibilityManager.getAccessibilityFont()
        dayLabel.textColor = accessibilityManager.getAccessibilityColors().foreground
        
        let timeLabel = UILabel()
        if hours.isClosed {
            timeLabel.text = "Zamknięte"
            timeLabel.textColor = .systemRed
        } else {
            timeLabel.text = "\(hours.openTime) - \(hours.closeTime)"
            timeLabel.textColor = accessibilityManager.getAccessibilityColors().foreground
        }
        timeLabel.font = accessibilityManager.getAccessibilityFont()
        timeLabel.textAlignment = .right
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(timeLabel)
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        return containerView
    }
    
    private func setupAccessibility() {
        // Etykiety dostępności
        nameLabel.accessibilityLabel = "Nazwa restauracji: \(restaurant.name)"
        cuisineLabel.accessibilityLabel = "Kuchnia: \(restaurant.cuisine)"
        ratingLabel.accessibilityLabel = "Ocena: \(restaurant.rating) gwiazdek"
        priceLabel.accessibilityLabel = "Cena: \(restaurant.priceRange.displayName)"
        addressLabel.accessibilityLabel = "Adres: \(restaurant.address)"
        
        if let phone = restaurant.phone {
            phoneLabel.accessibilityLabel = "Telefon: \(phone)"
        }
        
        if let website = restaurant.website {
            websiteLabel.accessibilityLabel = "Strona internetowa: \(website)"
        }
        
        mapView.accessibilityLabel = "Mapa z lokalizacją restauracji"
        accessibilityStackView.accessibilityLabel = "Funkcje dostępności"
        openingHoursStackView.accessibilityLabel = "Godziny otwarcia"
        
        callButton.accessibilityLabel = "Zadzwoń do restauracji"
        websiteButton.accessibilityLabel = "Otwórz stronę internetową restauracji"
        directionsButton.accessibilityLabel = "Nawiguj do restauracji"
    }
    
    private func applyAccessibilitySettings() {
        let font = accessibilityManager.getAccessibilityFont()
        let colors = accessibilityManager.getAccessibilityColors()
        
        // Ustawienia czcionek i kolorów dla wszystkich etykiet
        [nameLabel, cuisineLabel, ratingLabel, priceLabel, addressLabel, phoneLabel, websiteLabel].forEach { label in
            label?.font = font
            label?.textColor = colors.foreground
        }
        
        // Tło
        view.backgroundColor = colors.background
    }
    
    // MARK: - IBActions
    @IBAction func callButtonTapped(_ sender: UIButton) {
        guard let phone = restaurant.phone else { return }
        
        let phoneURL = URL(string: "tel:\(phone)")
        if let url = phoneURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        guard let website = restaurant.website else { return }
        
        var websiteURL = website
        if !websiteURL.hasPrefix("http://") && !websiteURL.hasPrefix("https://") {
            websiteURL = "https://\(websiteURL)"
        }
        
        if let url = URL(string: websiteURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func directionsButtonTapped(_ sender: UIButton) {
        let coordinate = restaurant.location
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = restaurant.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// MARK: - MKMapViewDelegate
extension RestaurantDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "RestaurantAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}