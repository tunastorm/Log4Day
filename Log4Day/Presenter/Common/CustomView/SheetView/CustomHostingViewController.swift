//
//  CustomHostingViewController.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import SwiftUI

/* CUSTOM HOSTING CONTROLLER */

// Custom UIHostingController for halfsheet
final class CustomHostingController<Content: View>: UIHostingController<Content> {

    override func viewDidLoad() {
        view.backgroundColor = .clear
        // setting presentation controller properties
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            // to show grab protion
            presentationController.prefersGrabberVisible = true
        }
    }
}
