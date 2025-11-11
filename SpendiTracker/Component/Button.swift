//
//  Button.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 01/03/25.
//

import Foundation
import SwiftUI

struct PrimaryButton:ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding().frame(maxWidth: .infinity)
            .background(Color.secondaryColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .opacity(configuration.isPressed ? 0.7 : 1)
                    .scaleEffect(configuration.isPressed ? 0.8 : 1)
                    .animation(.easeInOut(duration: 0.2))
    }
}

struct SecondaryButton:ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundColor(Color.black)
            .padding().frame(maxWidth: .infinity)
            .background(Color.textFieldColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .opacity(configuration.isPressed ? 0.7 : 1)
                    .scaleEffect(configuration.isPressed ? 0.8 : 1)
                    .animation(.easeInOut(duration: 0.2))
    }
}
struct CircleImageButton: View {
    var systemImage: String
    var color: Color = .blue
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(color)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .buttonStyle(.plain)
    }
}




struct DisabledButton:ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding().frame(maxWidth: .infinity)
            .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    
    }
}
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Button("a"){
            
        }.buttonStyle(PrimaryButton())
    }
}



