//
//  OverlayView.swift
//  RoutingPractice
//
//  Created by kjs on 2022/03/28.
//

import MapKit

final class OverlayView: NSObject, MKOverlay {
    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var boundingMapRect: MKMapRect

    init(y: Double, x: Double, boundingRect: MKMapRect) {
        self.coordinate = .init(latitude: y, longitude: x)
        self.boundingMapRect = boundingRect
    }

    func intersects(_ mapRect: MKMapRect) -> Bool {
        return true
    }
    func canReplaceMapContent() -> Bool {
        return true
    }
}
