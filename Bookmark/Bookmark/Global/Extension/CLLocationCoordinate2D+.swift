//
//  CLLocationCoordinate2D+.swift
//  Bookmark
//
//  Created by heerucan on 2022/09/15.
//

import Foundation

import CoreLocation

extension CLLocationCoordinate2D {
    func calculateDistance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}
