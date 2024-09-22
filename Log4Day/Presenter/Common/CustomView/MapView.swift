//
//  MapView.swift
//  Log4Day
//
//  Created by 유철원 on 9/20/24.
//

import NMapsMap
import SwiftUI

struct LogDetailMapView: View {
    @Binding var coord: (Double, Double)
    
    var body: some View {
        ZStack {
            UIMapView(coord: $coord)
                .edgesIgnoringSafeArea(.vertical)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
    }
}

struct LogMapMapView: View {
    @Binding var coord: (Double, Double)
    
    var body: some View {
        ZStack {
            UIMapView(coord: $coord)
                .edgesIgnoringSafeArea(.vertical)
        }
    }
}

