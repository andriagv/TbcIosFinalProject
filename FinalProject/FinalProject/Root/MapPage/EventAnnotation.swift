//
//  EventAnnotation.swift
//  FinalProject
//
//  Created by Apple on 28.01.25.
//


import MapKit

final class EventAnnotation: NSObject, MKAnnotation {
    let event: Event
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    var iconName: String {
        switch event.type {
        case .camping: return "tent"
        case .hiking: return "figure.hiking"
        case .tour: return "mountain.2.fill"
        }
    }
    
    var iconColor: UIColor {
        switch event.type {
        case .camping: return .systemGreen
        case .hiking: return .systemBrown
        case .tour: return .systemBlue
        }
    }
    
    init(event: Event) {
        self.event = event
        self.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
        self.title = event.name
        self.subtitle = event.location.city
    }
}
