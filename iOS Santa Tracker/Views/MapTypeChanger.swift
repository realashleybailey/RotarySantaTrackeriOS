//
//  MapTypeChanger.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 14/11/2022.
//

import SwiftUI
import BottomSheet

struct MapTypeChanger: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @Binding var bottomSheetPosition: BottomSheetPosition
    
    var body: some View {
        VStack {
            HStack {
                MapTypeBox(bottomSheetPosition: self.$bottomSheetPosition, selected: Binding(get: { return locationManager.mapType }, set: { locationManager.mapType = $0 }), type: .explore)
                MapTypeBox(bottomSheetPosition: self.$bottomSheetPosition, selected: Binding(get: { return locationManager.mapType }, set: { locationManager.mapType = $0 }), type: .driving)
            }
            HStack {
                MapTypeBox(bottomSheetPosition: self.$bottomSheetPosition, selected: Binding(get: { return locationManager.mapType }, set: { locationManager.mapType = $0 }), type: .transport)
                MapTypeBox(bottomSheetPosition: self.$bottomSheetPosition, selected: Binding(get: { return locationManager.mapType }, set: { locationManager.mapType = $0 }), type: .satellite)
            }
        }
    }
}

struct MapTypeBox: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var bottomSheetPosition: BottomSheetPosition
    @Binding var selected: MapType
    
    var type: MapType
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(mapTypeConverterText(type: self.type))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.system(size: 10))
                Spacer()
            }
            .padding()
            .frame(height: 30)
            .background(.ultraThinMaterial)
        }
        .background(content: {
            Image(mapTypeConverterImage(type: self.type))
                .resizable()
                .aspectRatio(contentMode: .fill)
        })
        .frame(height: 100)
        .clipped()
        .cornerRadius(10)
        .padding(2)
        .background {
            if (self.selected == self.type) {
                Rectangle()
                    .cornerRadius(11)
                    .foregroundColor(.blue)
            }
        }
        .onTapGesture(perform: changeSelected)
    }
    
    func changeSelected() {
        self.selected = self.type
        self.bottomSheetPosition = .hidden
    }
    
    func mapTypeConverterImage(type: MapType) -> String {
        switch type {
        case .explore:
            return "explore"
        case .driving:
            return "driving"
        case .transport:
            return "transport"
        case .satellite:
            return "satellite"
        }
    }

    func mapTypeConverterText(type: MapType) -> String {
        switch type {
        case .explore:
            return "Explore"
        case .driving:
            return "Driving"
        case .transport:
            return "Public Transport"
        case .satellite:
            return "Satellite"
        }
    }
}

struct MapTypeChanger_Previews: PreviewProvider {
    static var previews: some View {
        MapTypeChanger(bottomSheetPosition: .constant(.hidden)).environmentObject(LocationManager())
    }
}
