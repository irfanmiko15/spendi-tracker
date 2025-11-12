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
                .foregroundColor(.white)
                .padding([.top,.bottom],15)
                .padding([.leading,.trailing],20)
                .background(Color(UIColor.black).opacity(0.7))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
        }
        .frame(width: UIScreen.main.bounds.width*0.9)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.show = false
            }
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.show = false
                }
            }
        })
    }
}

struct ToastModifier: ViewModifier {
    @Binding var show: Bool
    let toastView: Toast

    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                toastView
                    .transition(.opacity) // 👈 Fade in/out
                                        .zIndex(1) // ensures it's above everything else
            }
        }
        .animation(.easeInOut(duration: 0.3), value: show)
    }
}

extension View {
    func toast(toastView: Toast, show: Binding<Bool>) -> some View {
        self.modifier(ToastModifier.init(show: show, toastView: toastView))
    }
}


