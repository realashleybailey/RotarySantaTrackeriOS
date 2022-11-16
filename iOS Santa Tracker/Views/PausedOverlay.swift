//
//  PausedOverlay.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 14/11/2022.
//

import SwiftUI

struct PausedOverlay: View {
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.red, .clear]), startPoint: .top, endPoint: .bottom)
                .frame(maxHeight: UIScreen.main.bounds.height / 3)
                .edgesIgnoringSafeArea(.vertical)
                .allowsHitTesting(false)
            Spacer()
        }
        
        VStack {
            Text("Tracking Paused")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .allowsHitTesting(false)
                .padding(.top, 6)
            Spacer()
        }
    }
}

struct PausedOverlay_Previews: PreviewProvider {
    static var previews: some View {
        PausedOverlay()
    }
}
