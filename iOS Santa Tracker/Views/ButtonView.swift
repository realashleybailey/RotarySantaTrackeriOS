//
//  ButtonView.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 10/11/2022.
//

import SwiftUI


struct RoundedActionButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17))
            .foregroundColor(Color(UIColor.primary))
            .padding(.vertical, 6)
            .padding(.horizontal, 20)
            .background(.white)
            .cornerRadius(15)
            .contentShape(RoundedRectangle(cornerRadius: 14))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct RoundedToggleButton: ButtonStyle {
    
    @Binding var isOn: Bool
    
    var trueIcon: String
    var falseIcon: String

    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: !isOn ? falseIcon : trueIcon)
            .foregroundColor(!isOn ? Color(UIColor.primary) : .white)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(!isOn ? .white : Color(UIColor.primary))
            .cornerRadius(15)
            .contentShape(RoundedRectangle(cornerRadius: 14))
            .frame(width: 60, height: 40)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct WhiteButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(.white)
            .foregroundColor(Color(UIColor.primary))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
