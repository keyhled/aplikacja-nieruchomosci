import UIKit
import CoreLocation

class RestaurantListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accessibilityButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    // MARK: - Properties
    private let restaurantService = RestaurantService()
    private let accessibilityManager = AccessibilityManager()
    private var isFilterViewVisible = false
    private var filterView: UIView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchBar()
        setupAccessibility()
        observeRestaurantService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantService.refreshLocation()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "FoodForAll"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Ustawienia przycisków
        accessibilityButton.title = "Dostępność"
        filterButton.title = "Filtry"
        sortButton.title = "Sortuj"
        
        // Kolory dla wysokiego kontrastu
        if accessibilityManager.isHighContrastEnabled {
            view.backgroundColor = .white
            navigationController?.navigationBar.backgroundColor = .white
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "RestaurantCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Szukaj restauracji..."
        searchBar.searchBarStyle = .minimal
    }
    
    private func setupAccessibility() {
        // Ustawienia dostępności dla VoiceOver
        tableView.accessibilityLabel = "Lista restauracji"
        searchBar.accessibilityLabel = "Pole wyszukiwania restauracji"
        accessibilityButton.accessibilityLabel = "Ustawienia dostępności"
        filterButton.accessibilityLabel = "Filtry restauracji"
        sortButton.accessibilityLabel = "Sortowanie restauracji"
    }
    
    private func observeRestaurantService() {
        // Obserwowanie zmian w serwisie restauracji
        restaurantService.$filteredRestaurants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - IBActions
    @IBAction func accessibilityButtonTapped(_ sender: UIBarButtonItem) {
        showAccessibilitySettings()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        showFilterOptions()
    }
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        showSortOptions()
    }
    
    // MARK: - Helper Methods
    private func showAccessibilitySettings() {
        let alert = UIAlertController(title: "Ustawienia dostępności", message: nil, preferredStyle: .actionSheet)
        
        // Duży tekst
        let largeTextAction = UIAlertAction(
            title: accessibilityManager.isLargeTextEnabled ? "✓ Duży tekst" : "Duży tekst",
            style: .default
        ) { [weak self] _ in
            self?.accessibilityManager.toggleLargeText()
            self?.updateUIForAccessibility()
        }
        alert.addAction(largeTextAction)
        
        // Wysoki kontrast
        let highContrastAction = UIAlertAction(
            title: accessibilityManager.isHighContrastEnabled ? "✓ Wysoki kontrast" : "Wysoki kontrast",
            style: .default
        ) { [weak self] _ in
            self?.accessibilityManager.toggleHighContrast()
            self?.updateUIForAccessibility()
        }
        alert.addAction(highContrastAction)
        
        // Pogrubiony tekst
        let boldTextAction = UIAlertAction(
            title: accessibilityManager.isBoldTextEnabled ? "✓ Pogrubiony tekst" : "Pogrubiony tekst",
            style: .default
        ) { [weak self] _ in
            self?.accessibilityManager.toggleBoldText()
            self?.updateUIForAccessibility()
        }
        alert.addAction(boldTextAction)
        
        // Anuluj
        let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel)
        alert.addAction(cancelAction)
        
        // Dla iPad
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = accessibilityButton
        }
        
        present(alert, animated: true)
    }
    
    private func showFilterOptions() {
        let alert = UIAlertController(title: "Filtry dostępności", message: "Wybierz funkcje dostępności:", preferredStyle: .actionSheet)
        
        for filter in AccessibilityManager.availableFilters {
            let isSelected = accessibilityManager.selectedAccessibilityFilters.contains(filter)
            let action = UIAlertAction(
                title: isSelected ? "✓ \(filter)" : filter,
                style: .default
            ) { [weak self] _ in
                self?.accessibilityManager.toggleAccessibilityFilter(filter)
                self?.applyAccessibilityFilters()
            }
            alert.addAction(action)
        }
        
        let clearAction = UIAlertAction(title: "Wyczyść filtry", style: .destructive) { [weak self] _ in
            self?.accessibilityManager.selectedAccessibilityFilters.removeAll()
            self?.restaurantService.filteredRestaurants = self?.restaurantService.restaurants ?? []
            self?.tableView.reloadData()
        }
        alert.addAction(clearAction)
        
        let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = filterButton
        }
        
        present(alert, animated: true)
    }
    
    private func showSortOptions() {
        let alert = UIAlertController(title: "Sortowanie", message: "Wybierz sposób sortowania:", preferredStyle: .actionSheet)
        
        let distanceAction = UIAlertAction(title: "Według odległości", style: .default) { [weak self] _ in
            self?.restaurantService.sortByDistance()
            self?.tableView.reloadData()
        }
        alert.addAction(distanceAction)
        
        let ratingAction = UIAlertAction(title: "Według oceny", style: .default) { [weak self] _ in
            self?.restaurantService.sortByRating()
            self?.tableView.reloadData()
        }
        alert.addAction(ratingAction)
        
        let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = sortButton
        }
        
        present(alert, animated: true)
    }
    
    private func applyAccessibilityFilters() {
        restaurantService.filterByAccessibility(filters: accessibilityManager.selectedAccessibilityFilters)
        tableView.reloadData()
    }
    
    private func updateUIForAccessibility() {
        // Aktualizacja kolorów
        let colors = accessibilityManager.getAccessibilityColors()
        view.backgroundColor = colors.background
        
        // Aktualizacja czcionek
        let font = accessibilityManager.getAccessibilityFont()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font,
            .foregroundColor: colors.foreground
        ]
        
        // Aktualizacja tabeli
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension RestaurantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantService.filteredRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell
        let restaurant = restaurantService.filteredRestaurants[indexPath.row]
        cell.configure(with: restaurant, accessibilityManager: accessibilityManager, restaurantService: restaurantService)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RestaurantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let restaurant = restaurantService.filteredRestaurants[indexPath.row]
        let detailVC = RestaurantDetailViewController()
        detailVC.restaurant = restaurant
        detailVC.accessibilityManager = accessibilityManager
        detailVC.restaurantService = restaurantService
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension RestaurantListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        restaurantService.searchRestaurants(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - RestaurantTableViewCell
class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var accessibilityIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        // Podstawowa konfiguracja komórki
        selectionStyle = .default
        accessoryType = .disclosureIndicator
    }
    
    func configure(with restaurant: Restaurant, accessibilityManager: AccessibilityManager, restaurantService: RestaurantService) {
        // Podstawowe informacje
        nameLabel.text = restaurant.name
        cuisineLabel.text = restaurant.cuisine
        ratingLabel.text = String(format: "%.1f ⭐", restaurant.rating)
        priceLabel.text = restaurant.priceRange.displayName
        distanceLabel.text = restaurantService.getDistance(to: restaurant)
        
        // Ustawienia dostępności
        let font = accessibilityManager.getAccessibilityFont()
        let colors = accessibilityManager.getAccessibilityColors()
        
        nameLabel.font = font
        nameLabel.textColor = colors.foreground
        
        cuisineLabel.font = font.withSize(font.pointSize * 0.9)
        cuisineLabel.textColor = colors.foreground
        
        ratingLabel.font = font.withSize(font.pointSize * 0.9)
        ratingLabel.textColor = colors.foreground
        
        priceLabel.font = font.withSize(font.pointSize * 0.9)
        priceLabel.textColor = colors.foreground
        
        distanceLabel.font = font.withSize(font.pointSize * 0.9)
        distanceLabel.textColor = colors.foreground
        
        // Ikona dostępności
        let hasAccessibilityFeatures = !restaurant.accessibilityFeatures.availableFeatures.isEmpty
        accessibilityIcon.isHidden = !hasAccessibilityFeatures
        accessibilityIcon.image = hasAccessibilityFeatures ? UIImage(systemName: "accessibility") : nil
        accessibilityIcon.tintColor = .systemBlue
        
        // Etykiety dostępności
        nameLabel.accessibilityLabel = "\(restaurant.name), \(restaurant.cuisine), ocena \(restaurant.rating), \(restaurant.priceRange.displayName)"
        if hasAccessibilityFeatures {
            nameLabel.accessibilityLabel?.append(", dostępne funkcje dostępności")
        }
    }
}

// MARK: - Combine
import Combine

private var cancellables = Set<AnyCancellable>()