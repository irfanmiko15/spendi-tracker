//
//  Toast.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 28/02/25.
//

import SwiftUI

struct Toast: View {
    var message: String = ""
    @Binding var show: Bool
    var body: some View {
        VStack {
            Spacer()
                Text(message)
            .font(.subheadline)
                .foregroundColor(.primary)
                .padding([.top,.bottom],15)
                .padding([.leading,.trailing],20)
                .background(Color(UIColor.secondarySystemBackground).opacity(0.8))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
        }
        .frame(width: UIScreen.main.bounds.width / 1)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.show = false
            }
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    self.show = false
                }
            }
        })
    }
}

struct ToastModifier : ViewModifier {
    @Binding var show: Bool
    let toastView: Toast
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                toastView
            }
        }
    }
}

extension View {
    func toast(toastView: Toast, show: Binding<Bool>) -> some View {
        self.modifier(ToastModifier.init(show: show, toastView: toastView))
    }
}


