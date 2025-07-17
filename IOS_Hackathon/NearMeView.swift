import SwiftUI
import MapKit

// A wrapper struct to make MKMapItem identifiable for SwiftUI views.
struct IdentifiablePlace: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

// MARK: - Location View Model
@Observable
class LocationViewModel: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    var cameraPosition: MapCameraPosition = .automatic
    var searchResults: [IdentifiablePlace] = []
    var isLocationDenied = false
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        DispatchQueue.main.async {
            let region = MKCoordinateRegion(
                center: latestLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            self.cameraPosition = .region(region)
        }
        locationManager.stopUpdatingLocation()
        searchForPlaces(near: latestLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            isLocationDenied = true
        case .notDetermined:
            requestLocationPermission()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    private func searchForPlaces(near coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "psychologist OR clinic OR hospital OR mental health"
        request.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            guard let self = self, let response = response else {
                print("Local search failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                let sortedItems = response.mapItems.sorted(by: {
                    ($0.placemark.location?.distance(from: self.locationManager.location!) ?? 0) <
                        ($1.placemark.location?.distance(from: self.locationManager.location!) ?? 0)
                })
                self.searchResults = sortedItems.map { IdentifiablePlace(mapItem: $0) }
            }
        }
    }
}


// MARK: - Near Me View
struct NearMeView: View {
    @State private var viewModel = LocationViewModel()
    
    var body: some View {
        VStack {
            Map(position: $viewModel.cameraPosition) {
                UserAnnotation()
                
                ForEach(viewModel.searchResults) { place in
                    Marker(place.mapItem.name ?? "Support Service", coordinate: place.mapItem.placemark.coordinate)
                }
            }
            
            if viewModel.searchResults.isEmpty && !viewModel.isLocationDenied {
                VStack {
                    ProgressView()
                        .padding()
                    Text("Finding nearby support...")
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                List(viewModel.searchResults) { place in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(place.mapItem.name ?? "Unknown Place")
                            .font(.headline)
                        if let address = place.mapItem.placemark.title {
                            Text(address)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Nearby Support")
        // THIS IS THE FIX: Changes the large title to a small, inline one.
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.requestLocationPermission()
        }
        .alert("Location Access Denied", isPresented: $viewModel.isLocationDenied) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("To find nearby support, please enable location access for this app in your device's Settings.")
        }
    }
}


// MARK: - Preview
struct NearMeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NearMeView()
        }
    }
}
