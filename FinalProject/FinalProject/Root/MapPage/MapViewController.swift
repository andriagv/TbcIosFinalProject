//
//  MapViewController.swift
//  FinalProject
//
//  Created by Apple on 28.01.25.
//

import UIKit
import MapKit
import SwiftUI
import Combine

protocol MapViewProtocol: AnyObject {
    func updateAnnotations(with events: [Event])
}

final class MapViewController: UIViewController, MapViewProtocol {
    private var mapView: MKMapView!
    private let viewModel: MapViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MapViewModelProtocol = MapViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMapView()
        bindViewModel()
        viewModel.loadEvents()
    }
    
    private func setupUI() {
        title = "Events Map"
        view.backgroundColor = .pageBack
    }
    
    private func setupMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackingButton)
        
        NSLayoutConstraint.activate([
            trackingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            trackingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func bindViewModel() {
        viewModel.eventsPublisher
            .sink { [weak self] events in
                self?.updateAnnotations(with: events)
            }
            .store(in: &cancellables)
    }
    
    func updateAnnotations(with events: [Event]) {
        mapView.removeAnnotations(mapView.annotations)
        for event in events {
            let annotation = EventAnnotation(event: event)
            mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? EventAnnotation else { return nil }
        
        let identifier = "EventMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = UIImage(systemName: annotation.iconName)
            annotationView?.markerTintColor = annotation.iconColor
            
            let detailsButton = UIButton(type: .infoLight)
            annotationView?.rightCalloutAccessoryView = detailsButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? EventAnnotation else { return }
        
        let eventDetailsView = EventDetailsView(event: annotation.event)
        let hostingController = UIHostingController(rootView: eventDetailsView)
        
        hostingController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

