//
//  ViewController.swift
//  RoutingPractice
//
//  Created by kjs on 2022/03/28.
//

import UIKit
import MapKit
import CoreLocation

final class AnnotaionView: NSObject, MKAnnotation {
    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var title: String?
    private(set) var subtitle: String?

    init(
        y: Double, x: Double,
        title: String? = nil, subtitle: String? = nil
    ) {
        self.coordinate = .init(latitude: y, longitude: x)
        self.title = title
        self.subtitle = subtitle
    }
}

final class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        guard manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways else {
            return
        }

        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        guard let coordinate = locations.first?.coordinate else {
            return
        }

        mapView.setCenter(coordinate, animated: false)
        mapView.setCameraZoomRange(.init(maxCenterCoordinateDistance: 1000), animated: false)
        mapView.addAnnotation(AnnotaionView(
            y: coordinate.latitude, x: coordinate.longitude,
            title: "여긴 어디일까요?", subtitle: "여기가 어디냐면...")
        )
    }
}
