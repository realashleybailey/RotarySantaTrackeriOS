//
//  GifView.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 14/11/2022.
//

//import Foundation
//import SwiftyGif
//import SwiftUI
//
//struct GifView: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        
//        let view = UIView()
//        
//        let gif = try! UIImage(gifName: "Walkthrough.gif")
//        let imageView = UIImageView(gifImage: gif, loopCount: -1)
//        
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(imageView)
//        
//        NSLayoutConstraint.activate([
//            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            imageView.widthAnchor.constraint(equalTo: view.widthAnchor)
//        ])
//        
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        
//    }
//}
