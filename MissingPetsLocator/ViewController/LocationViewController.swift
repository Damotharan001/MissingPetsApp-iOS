//
//  LocationViewController.swift
//  MissingPetsLocator
//
//  Created by Damotharan KG on 27/11/24.
//

import UIKit
import MapKit

class LocationViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var delegate: GetAddress?
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 12.9687, longitude: 80.248)
        mapView.centerToLocation(initialLocation)
        self.mapView.delegate = self
        let gestureZ = UILongPressGestureRecognizer(target: self, action: #selector(self.revealRegionDetailsWithLongPressOnMap(sender:)))
        view.addGestureRecognizer(gestureZ)
        self.navigationItem.title = "Select location"
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(LocationViewController.closeAction))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    func getAddress(from latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                completion(nil)
                return
            }
            
            // Construct a readable address from the placemark
            let address = [
                placemark.name,            // Street address or landmark
                placemark.locality,        // City
                placemark.administrativeArea, // State/Region
                placemark.country          // Country
            ].compactMap { $0 }.joined(separator: ", ")
            
            completion(address)
        }
    }
    
    @objc func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        getAddress(from: locationCoordinate.latitude, longitude: locationCoordinate.longitude) { address in
            if let address = address {
                print("Address: \(address)")
                self.delegate?.getAddress(address: "\(address)")
            } else {
                print("Failed to retrieve address")
            }
        }
    }
    
    @objc func closeAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

