//
//  RouteManager.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 14/11/2022.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseCore

class RouteManager: ObservableObject {
    
    @Published var currentRoute: KMLDocument?
    @Published var routeList: RouteList?
    
    private let db: Firestore = Firestore.firestore()
    private let storage: Storage = Storage.storage()
    private let maxSize: Int64 = ((1 * 1024 * 1024) * 2) // 2MB
    private let folder: String = "routes"
    
    init() {
        
        self.loadRouteList()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.loadLatestRoute()
        })
    }
    
    func loadLatestRoute() {
        guard let routeList = self.routeList else {
            loadRouteList()
            return
        }
        
        guard let firstRoute = routeList.first else {
            print("No routes so could not load a default one to the map!")
            return
        }

        loadSpecificRoute(firstRoute.document)
    }
    
    func loadSpecificRoute(_ storageRef: StorageReference) {
        storageRef.getData(maxSize: self.maxSize, completion: self.KMLrouteErrorHandler)
    }
    
    func loadRouteList() {
        db.collection(self.folder).getDocuments(completion: self.RouteListErrorHandler)
    }
    
    func setPublicRoute(_ document: String) {
        let reference = db.document("routes/\(document)")
        db.document("config/map-1").setData(["current_route": reference])
    }
    
    private func KMLrouteErrorHandler(_ data: Data?, _ error: Error?) -> Void {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let data = data else {
            print(error?.localizedDescription ?? "Unknown error occured while getting data for KML document!")
            return
        }
        
        let KMLDocument = self.parseDataToKML(data)
        
        guard let KMLDocument = KMLDocument else {
            print(error?.localizedDescription ?? "Unknown error occured while parsing the KML document!")
            return
        }
        
        self.currentRoute = KMLDocument
    }
    
    private func RouteListErrorHandler(_ list: QuerySnapshot?, _ error: Error?) -> Void {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let list = list else {
            print(error?.localizedDescription ?? "Unknown error occured while getting list of KML documents!")
            return
        }
        
        var routeArray: Array<RouteItem> = []
        
        func forEachFunction(_ data: QueryDocumentSnapshot) -> Void {
            do {
                routeArray.append(try documentToRouteItem(data))
            } catch {
                return
            }
        }
        
        list.documents.forEach(forEachFunction)
        
        self.routeList = routeArray
    }
    
    private func parseDataToKML(_ data: Data) -> KMLDocument? {
        return KMLDocument.parse(data: data)
    }
    
    private func documentToRouteItem(_ data: QueryDocumentSnapshot) throws -> RouteItem {
        let id = data.documentID
        let name = data["name"] as! String
        let document = data["document"] as! String
        let uploaded = data["uploaded"] as! Firebase.Timestamp
        
        if (!self.checkDocumentPath(string: document)) {
            throw ErrorHandler.runtimeError("Internal error: URL scheme must be one of gs://, http://, or https://")
        }
        
        let documentReference = storage.reference(forURL: document)

        return RouteItem(id: id, name: name, document: documentReference, uploaded: uploaded)
    }
    
    private func checkDocumentPath(string: String) -> Bool {
        if string.hasPrefix("gs://") {
            return true
        } else if string.hasPrefix("http://") || string.hasPrefix("https://") {
            return true
        } else {
            return false
        }
    }
}
