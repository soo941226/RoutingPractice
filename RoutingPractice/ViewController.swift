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
    private let polyLineRenderer = MapPolylineRenderer(lineWidth: 1.0, color: .red)

    override func viewDidLoad() {
        super.viewDidLoad()
        router.configure { [weak self] point in
            self?.mapView.setCenter(point, animated: false)
        } 
        mapView.setCameraZoomRange(.init(maxCenterCoordinateDistance: distance), animated: false)
        mapView.delegate = polyLineRenderer

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
                self.mapView.addOverlay(route.polyline)
            case .failure(let error):
                print(error)
            }
        }
    }
}
