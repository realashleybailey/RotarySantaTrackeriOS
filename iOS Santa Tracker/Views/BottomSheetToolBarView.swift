//
//  BottomSheetToolBarView.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 15/11/2022.
//

import SwiftUI

struct BottomSheetToolBarView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        HStack {
            Button(action: displayedRegionLockedRoute, label: {})
                .buttonStyle(RoundedToggleButton(isOn: Binding<Bool>(get: { locationManager.displayedRegionLockedRoute }, set: { locationManager.displayedRegionLockedRoute = $0 }), trueIcon: "map", falseIcon: "map.fill"))

            Spacer()
            
            Button(action: locationUpdatesEnabled, label: {})
                .buttonStyle(RoundedToggleButton(isOn: Binding<Bool>(get: { !locationManager.locationUpdatesEnabled }, set: { locationManager.locationUpdatesEnabled = !$0 }), trueIcon: "play.fill", falseIcon: "pause.fill"))
        }
        .padding(8)
    }
    
    func displayedRegionLockedRoute() {
        locationManager.displayedRegionLockedRoute.toggle()
        
        if (locationManager.displayedRegionLockedRoute) {
            locationManager.displayedRegionTracking = false
        }
    }
    
    func locationUpdatesEnabled() {
        locationManager.locationUpdatesEnabled.toggle()
    }
}

struct BottomSheetToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetToolBarView()
    }
}
