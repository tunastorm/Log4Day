//
//  MapMarkerImageView.swift
//  Log4Day
//
//  Created by 유철원 on 9/27/24.
//

import SwiftUI

struct MarkerView: View {

    @State var isPointed: Bool = false
    
    var index: Int
    
    var count: Int
    
    var image: UIImage?

    var body: some View {
        VStack {
            ZStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(4)
                    if count > 1 {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .font(.system(size: 5))
                                    .background(.white)
                            }
                            Spacer()
                        }
                    }
                }
                HStack {
                    Text(String(index+1))
                        .font(.headline)
                        .foregroundColor(isPointed ? ColorManager.shared.ciColor.highlightColor : .black)
                        .opacity(image == nil ? 1 : 0)
                }
            }
        }
        .frame(width: image == nil ? 50 : 60, height: image == nil ? 50 : 60)
        .padding(.bottom, 11)
        
        .background(
            ImageBubble(isPointed: $isPointed)
        )
    }
   
}


/**
말풍선 뷰
*/
struct ImageBubble: View {
    
    @Binding var isPointed: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Ellipse()
                .frame(width: 20, height: 3)
                .foregroundColor(.black.opacity(0.5))
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 4)
                    .background(.white)
                    .foregroundStyle(isPointed ? ColorManager.shared.ciColor.highlightColor: .white)
                    .cornerRadius(12)
                Spacer()
            }
            .padding(.bottom, 3)
            Triangle()
//                .stroke(lineWidth: 4)
                .frame(width: 12, height: 8)
//                .background(isPointed ? ColorManager.shared.ciColor.highlightColor : .white)
                .foregroundStyle(isPointed ? ColorManager.shared.ciColor.highlightColor : .white)
                .clipShape(Triangle())
                .padding(.bottom, 3)
        }
    }
    
    struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            
            return path
        }
    }
}
