//
//  BottomSheetView.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 10/11/2022.
//

import SwiftUI
import FirebaseStorage

struct BottomSheetView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var routeManager: RouteManager
    
    var body: some View {
        VStack {
            
            ForEach(routeManager.routeList ?? [], id: \.self) { route in
                Button(action: { updateRoute(route.document) }, label: { buttonView(route.name) }).buttonStyle(BorderedButtonStyle())
            }
            
            Divider()
            
            Button(action: { uploadRoute() }, label: { buttonView("Upload Route") }).background(.blue).cornerRadius(7).buttonStyle(BorderedButtonStyle())
            
            Spacer()
        }
        .padding()
        .padding(.horizontal)
    }
    
    func buttonView(_ name: String) -> some View {
        HStack {
            Spacer()
            Text(name).foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
        }
    }
    
    func updateRoute(_ route: StorageReference) {
        routeManager.loadSpecificRoute(route)
    }
    
    func uploadRoute() {
        
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView()
    }
}
