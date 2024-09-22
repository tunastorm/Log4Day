//
//  UIViewControllerWrapper.swift
//  Log4Day
//
//  Created by 유철원 on 9/13/24.
//

import SwiftUI

import UIKit
import SwiftUI

struct UIViewControllerWrapper<ViewController: UIViewController>: UIViewControllerRepresentable {
   
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }
    
    // SWiftUI View <- Data -> UIKit
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        uiViewController
    }
    
}
