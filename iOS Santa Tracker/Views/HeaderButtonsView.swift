//
//  HeaderButtonsView.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 16/11/2022.
//

import SwiftUI
import SlideOverCard
import BottomSheet

struct HeaderButtonsView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @Binding var bottomSheetPosition: BottomSheetPosition

    var body: some View {
        VStack {
            HStack {
                Button(action: mapToggleTracking) {
                    Image(systemName: locationManager.displayedRegionTracking ? "location.fill" : "location")
                }.buttonStyle(WhiteButton())
                Spacer()
                Button(action: presentMapTypeChange) {
                    Image(systemName: "square.stack.3d.up.fill")
                }.buttonStyle(WhiteButton())
            }
            .padding(.horizontal)
            Spacer()
        }
    }
    
    func mapToggleTracking() {
        locationManager.displayedRegionTracking.toggle()
        
        if (locationManager.displayedRegionTracking) {
            locationManager.displayedRegionLockedRoute = false
        }
    }
    
    func presentMapTypeChange() {
        self.bottomSheetPosition = .dynamicTop
    }
}

struct HeaderButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderButtonsView(bottomSheetPosition: .constant(.hidden))
    }
}
