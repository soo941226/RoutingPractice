//
//  MapPolylineRenderer.swift
//  RoutingPractice
//
//  Created by kjs on 2022/03/28.
//

import MapKit

final class MapPolylineRenderer: NSObject, MKMapViewDelegate {
    let lineWidth: CGFloat
    let color: UIColor?
    init(lineWidth: CGFloat = 1.0, color: UIColor? = .black) {
        self.lineWidth = lineWidth
        self.color = color
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = lineWidth
        renderer.strokeColor = color
        return renderer
    }
}
