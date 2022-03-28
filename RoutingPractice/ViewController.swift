//
//  ViewController.swift
//  RoutingPractice
//
//  Created by kjs on 2022/03/28.
//

import UIKit
import MapKit

final class ViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    private var distance: Double = 2000
    
    private let router = MapRouter()

    override func viewDidLoad() {
        super.viewDidLoad()
        router.configure { [weak self] point in
            self?.mapView.setCenter(point, animated: false)
        } 
        mapView.setCameraZoomRange(.init(maxCenterCoordinateDistance: distance), animated: false)
        mapView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClick(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func onClick(_ sender: UIGestureRecognizer) {
        guard let mapView = sender.view as? MKMapView else {
            return
        }
        mapView.removeOverlays(mapView.overlays)
        let touchPoint = sender.location(in: mapView)
        let mapPoint = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        router.route(to: mapPoint) { result in
            switch result {
            case .success(let response):
                guard let route = response.routes.first else { return }
                print(mapPoint)
                print(route.polyline)
                self.mapView.addOverlay(route.polyline)

            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 2
            renderer.strokeColor = .red
            return renderer
        }

        return MKOverlayRenderer()
    }
}
