//
//  ContentView.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 12/10/2022.
//

import SwiftUI
import MapKit
import CoreLocation
import BottomSheet
import FirebaseStorage
import SlideOverCard

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    @StateObject var routeManager = RouteManager()
    
    @State private var locationRequestPresented: Bool = false
    @State private var locationRequestChangePresented: Bool = false
    @State private var mapTypeChangePreseneted: Bool = false
    
    @State private var bottomSheetPosition: BottomSheetPosition = .dynamicBottom
    @State private var bottomSheet2Position: BottomSheetPosition = .hidden
    
    @State private var bottomSheetToolsPosition: Int = 0
    
    var locationRequestOptions: SOCOptions {
        var options = SOCOptions()
        options.insert(.disableDragToDismiss)
        options.insert(.hideExitButton)
        return options
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                MapView().environmentObject(locationManager).environmentObject(routeManager)
            }
            .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, switchablePositions: [.relative(0.5), .dynamicBottom], aboveContent: aboveContent, title: "Santa Routes", content: mainContent)
            .bottomSheet(bottomSheetPosition: self.$bottomSheet2Position, switchablePositions: [.hidden, .dynamicTop], content: mainContent2)
            .enableContentDrag()
            .enableTapToDismiss(true)
            .customThreshold(0.1)
            .enableSwipeToDismiss()
            .edgesIgnoringSafeArea(.vertical)
            .zIndex(0)
            .onAppear(perform: viewDidAppear)
            
            if (!locationManager.locationUpdatesEnabled) {
                PausedOverlay()
                    .transition(AnyTransition.opacity.animation(.easeInOut))
                    .zIndex(1)
            }
            
            HeaderButtonsView(bottomSheetPosition: self.$bottomSheet2Position)
                .environmentObject(locationManager)
                .zIndex(2)
        }
    }
    
    func aboveContent() -> some View {
        return BottomSheetToolBarView().environmentObject(locationManager)
    }
    
    func mainContent() -> some View {
        return BottomSheetView().environmentObject(locationManager).environmentObject(routeManager)
    }
    
    func mainContent2() -> some View {
        return MapTypeChanger(bottomSheetPosition: self.$bottomSheet2Position).environmentObject(locationManager).padding().padding(.bottom, 10)
    }
    
    func viewDidAppear() {
        if (locationManager.locationStatus == .notDetermined) {
            presentLocationRequest()
        } else if (locationManager.locationStatus != .authorizedAlways) {
            presentLocationChangeRequest()
        }
    }
    
    func presentLocationRequest() {
        SOCManager.present(isPresented: $locationRequestPresented, options: locationRequestOptions) {
            LocationRequest(locationRequestPresented: $locationRequestPresented)
        }
    }
    
    func presentLocationChangeRequest() {
        SOCManager.present(isPresented: $locationRequestChangePresented, options: locationRequestOptions) {
            LocationRequestChange(locationRequestChangePresented: $locationRequestChangePresented)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
