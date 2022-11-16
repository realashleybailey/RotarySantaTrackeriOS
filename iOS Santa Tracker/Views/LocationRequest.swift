//
//  LocationRequest.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 14/11/2022.
//

import Foundation
import SwiftUI
import SlideOverCard

struct LocationRequest: View {
    
    @EnvironmentObject var locationManager: LocationManager
    
    @Binding var locationRequestPresented: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            
            HStack {
                Image(systemName: "location.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.blue)
            }
            
            VStack {
                Text("Your Location").font(.system(size: 28, weight: .bold))
                    .padding(.bottom, 2)
                Text("We need your location permission for this app.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Text("Please click \"Allow While Using App\" then click \"Change to Always Allow\" to grant this app Location Permissions.")
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            
            VStack(spacing: 0) {
                Button("Allow Location", action: {
                    
                    LocationManager.shared.requestLocation()
                    SOCManager.dismiss(isPresented: $locationRequestPresented)
                    
                }).buttonStyle(SOCActionButton())
            }
            
        }.frame(height: 420)
    }
    
}


struct LocationRequestChange: View {
    
    @Binding var locationRequestChangePresented: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            
            HStack {
                Image(systemName: "location.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.blue)
            }
            
            VStack {
                Text("Your Location").font(.system(size: 28, weight: .bold))
                    .padding(.bottom, 2)
                Text("We need your full location for this app to function properly, please change your settings to Always allow location access.")
                    .multilineTextAlignment(.center)
            }
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(Color.gray)
                    .frame(height: 200)
                
                VStack {
                    Image("screen_2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(.top, 250)
                }
                .clipped()
                .frame(maxHeight: 194)
                .cornerRadius(25)
                .padding(3)
            }
            
            VStack(spacing: 0) {
                Button("Open Settings", action: {
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
                    {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                    SOCManager.dismiss(isPresented: $locationRequestChangePresented)
                }).buttonStyle(SOCActionButton())
                Button("Ignore", action: {
                    SOCManager.dismiss(isPresented: $locationRequestChangePresented)
                }).buttonStyle(SOCEmptyButton())
            }
        }.frame(height: 600)
    }
    
}
