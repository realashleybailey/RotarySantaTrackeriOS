//
//  Routes.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 16/11/2022.
//

import Foundation
import Firebase
import FirebaseStorage

typealias RouteList = [RouteItem]

struct RouteItem: Hashable, Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let document: StorageReference
    let uploaded: Firebase.Timestamp
}
