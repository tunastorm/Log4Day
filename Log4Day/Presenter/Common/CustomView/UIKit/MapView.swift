//
//  MapView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import UIKit
import NMapsMap

final class MapView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let map = NMFMapView(frame: view.frame)
        view.addSubview(map)
    }
    
}
