
import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation

class RealtimeFirestore: NSObject  {
    
    let db = Firestore.firestore()
    
    func updateLocation(_ location: CLLocationCoordinate2D) {
        
        let batch = db.batch()
        
        let currentLocation = db.collection("places").document("tracker-1")
        batch.updateData(["location": GeoPoint(latitude: location.latitude, longitude: location.longitude)], forDocument: currentLocation)
        
//        let historyLocation = db.collection("places").document("tracker-1").collection("history").document(currentDateTime())
//        batch.setData(["location": GeoPoint(latitude: location.latitude, longitude: location.longitude), "time": Firebase.Timestamp()], forDocument: historyLocation)
//

        batch.commit()
        
    }
    
    func currentDateTime() -> String {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.string(from: date)
    }
}
