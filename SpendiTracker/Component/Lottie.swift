//
//  Lottie.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 11/11/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var isPlay: Bool = true
    var frame: Int = 0
    var animation: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: animation)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.3
        if !isPlay {
            animationView.currentProgress = AnimationProgressTime(frame)
        }
        else {
            animationView.play()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
