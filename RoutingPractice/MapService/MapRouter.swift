//
//  MapRouter.swift
//  RoutingPractice
//
//  Created by kjs on 2022/03/28.
//

import MapKit

enum CustomError: Error {
    case somethingWrong
}

final class MapRouter: NSObject {
    typealias CompletionHandler = (CLLocationCoordinate2D) -> Void

    private let locationManager = CLLocationManager()
    private let converter = CLGeocoder()

    private var action: CompletionHandler?
    private var startPlace: CLPlacemark?
    private(set) var error: Error?
    private(set) var dispatch: DispatchWorkItem?
    private let dispatchDelay = 0.5

    func configure(action: @escaping CompletionHandler) {
        self.action = action
        setUpLocationManager()
    }

    func route(
        to destination: CLLocationCoordinate2D,
        completionHandler: @escaping (Result<MKDirections.Response, Error>) -> Void
    ) {
        guard let startPoint = startPlace else {
            return
        }
        dispatch?.cancel()

        dispatch = .init {
            let request = MKDirections.Request()
            request.source = .init(placemark: .init(placemark: startPoint))
            request.destination = .init(placemark: .init(coordinate: destination))
            let directions = MKDirections(request: request)

            directions.calculate { response, error in
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }

                if let response = response {
                    completionHandler(.success(response))
                    return
                }

                completionHandler(.failure(CustomError.somethingWrong))
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchDelay) {
            self.dispatch?.perform()
        }
    }

    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}


extension MapRouter: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways else {
            return
        }

        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        converter.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let startPlace = placemarks?.first,
               let startPoint = startPlace.location {
                self.startPlace = startPlace
                self.action?(startPoint.coordinate)
                self.action = nil
            }
        }
    }
}
