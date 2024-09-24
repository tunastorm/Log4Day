//
//  HalfSheetManager.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import SwiftUI
import UIKit

// UIKit Integration
struct HalfSheetManager<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    let controller = UIViewController()
    @Binding var showSheet: Bool

    /* 새로 추가한 부분 */
    var onEnd: () -> ()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            // choosing view when showsheet toggled againg
            uiViewController.dismiss(animated: true)
        }
    }
    /* 새로 추가한 부분 */
    // On dismiss
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetManager

        init(parent: HalfSheetManager) {
            self.parent = parent
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
    
}
