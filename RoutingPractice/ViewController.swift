//
//  ViewController.swift
//  RoutingPractice
//
//  Created by kjs on 2022/03/28.
//

import UIKit
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

final class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let y = 37.29314887492015
        let x = 126.95954608225948
        mapView.setCenter(.init(latitude: y, longitude: x), animated: false)
        mapView.setCameraZoomRange(.init(maxCenterCoordinateDistance: 1000), animated: false)
        mapView.addAnnotation(AnnotaionView(y: y, x: x, title: "입북동행정복지센터", subtitle: "일까요?"))
    }
}

