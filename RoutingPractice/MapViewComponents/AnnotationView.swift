//
//  AnnotationView.swift
//  RoutingPractice
//
//  Created by kjs on 2022/03/28.
//

import MapKit

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

