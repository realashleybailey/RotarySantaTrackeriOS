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
    
    @State private var documentPicker: Bool = false
    @State private var document: String = ""
    
    @State private var setRoute: Bool = false
//    @State private var document: String = ""
    
    var body: some View {
        VStack {
            
            ForEach(routeManager.routeList ?? [], id: \.self) { route in
                Button(action: { updateRoute(route.document) }, label: { buttonView(route.name) }).buttonStyle(BorderedButtonStyle())
            }
            
            Divider()
            
            Button(action: { self.documentPicker = true }, label: { buttonView("Upload Route") }).background(.blue).cornerRadius(7).buttonStyle(BorderedButtonStyle()).disabled(true)
            Button(action: { self.setRoute = true }, label: { buttonView("Set Public Route") }).background(.gray).cornerRadius(7).buttonStyle(BorderedButtonStyle())
            
            Spacer()
        }
        .padding()
        .padding(.horizontal)
        .sheet(isPresented: $documentPicker) {
            DocumentPicker(fileContent: $document).ignoresSafeArea()
        }
        .sheet(isPresented: $setRoute) {
            VStack {
                HStack {
                    Text("Select Public Route")
                        .font(.headline)
                        .padding(.bottom, 3)
                    Spacer()
                }
                
                HStack {
                    Text("Select the route that you are currently participating in from the list below and it will be shown as Santas route on the website for the next 12 hours.")
                        .font(.caption)
                    Spacer()
                }
                
                Divider()
                ForEach(routeManager.routeList ?? [], id: \.self) { route in
                    Button(action: { setPublicRoute(route.id) }, label: { buttonView(route.name) }).buttonStyle(BorderedButtonStyle())
                }
                Spacer()
            }
            .padding()
        }
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

    func setPublicRoute(_ id: String) {
        routeManager.setPublicRoute(id)
        self.setRoute = false
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView()
    }
}
