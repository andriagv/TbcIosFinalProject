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
import CoreLocation

protocol MapViewProtocol: AnyObject {
    func updateAnnotations(with events: [Event])
}

final class MapViewController: UIViewController, MapViewProtocol {
    private let viewModel: MapViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    private var userDidInteractWithMap = false

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var zoomInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("➕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        let zoomInAction = UIAction { [weak self] _ in
            self?.zoomIn()
        }
        button.addAction(zoomInAction, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var zoomOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("➖", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        let zoomOutAction = UIAction { [weak self] _ in
            self?.zoomOut()
        }
        button.addAction(zoomOutAction, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        setupLocationManager()
        setupZoomButtons()
        bindViewModel()
        viewModel.loadEvents()
    }
    
    private func setupUI() {
        title = "Events Map"
        view.backgroundColor = .systemBackground
    }
    
    private func setupMapView() {
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
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupZoomButtons() {
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        
        NSLayoutConstraint.activate([
            zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            zoomInButton.widthAnchor.constraint(equalToConstant: 50),
            zoomInButton.heightAnchor.constraint(equalToConstant: 50),
            
            zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            zoomOutButton.bottomAnchor.constraint(equalTo: zoomInButton.topAnchor, constant: -10),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 50),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func zoomIn() {
        userDidInteractWithMap = true
        var region = mapView.region
        region.span.latitudeDelta *= 0.5
        region.span.longitudeDelta *= 0.5
        mapView.setRegion(region, animated: true)
    }
    
    private func zoomOut() {
        userDidInteractWithMap = true
        var region = mapView.region
        region.span.latitudeDelta *= 2.0
        region.span.longitudeDelta *= 2.0
        mapView.setRegion(region, animated: true)
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

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        if !userDidInteractWithMap {
            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                latitudinalMeters: 5000,
                longitudinalMeters: 5000
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            print("❌ Location permission denied")
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        userDidInteractWithMap = true  
    }
    
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
