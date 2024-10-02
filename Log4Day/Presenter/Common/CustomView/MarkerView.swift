//
//  MapMarkerImageView.swift
//  Log4Day
//
//  Created by 유철원 on 9/27/24.
//

import SwiftUI

struct MarkerView: View {

    @State var isPointed: Bool = false
    @State var isDeleteMode: Bool
    
    var index: Int
    
    var count: Int
    
    var image: UIImage?

    var body: some View {
        VStack {
            ZStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .cornerRadius(9.2, corners: .allCorners)
                        .padding(3)
                    VStack {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle((isPointed && !isDeleteMode) ? .mint : .white)
//                                        .cornerRadius(4, corners: .allCorners)
                                Text(String(index+1))
                                    .font(.system(size: 10,weight: .bold))
                                    .foregroundStyle((isPointed && !isDeleteMode) ? .white : .gray)
                                    .padding(2)
                            }
                            Spacer()
                        }
                        Spacer()
                        if count > 1 {
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle((isPointed && !isDeleteMode) ? .mint : .white)
    //                                        .cornerRadius(4, corners: .allCorners)
                                    Image(systemName: "plus")
                                        .font(.system(size: 10,weight: .bold))
                                        .foregroundStyle((isPointed && !isDeleteMode) ? .white : .gray)
                                        .padding(2)
                                }
                              
                            }
                        }
                    }
                }
                HStack {
                    Text(String(index+1))
                        .font(.headline)
                        .foregroundColor((isPointed && !isDeleteMode) ? .mint : .gray)
                        .opacity(image == nil ? 1 : 0)
                }
            }
        }
        .frame(width: image == nil ? 50 : 60, height: image == nil ? 50 : 60)
        .padding(.bottom, 11)
        .background(
            ImageBubble(isPointed: $isPointed,
                        isDeleteMode: $isDeleteMode)
        )
    }
   
}

struct ImageBubble: View {
    
    @Binding var isPointed: Bool
    @Binding var isDeleteMode: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Ellipse()
                .frame(width: 20, height: 3)
                .foregroundColor(.black.opacity(0.5))
            Triangle()
                .frame(width: 12, height: 8)
                .foregroundStyle((isPointed && !isDeleteMode) ? .mint : .white)
                .clipShape(Triangle())
                .padding(.bottom, 3)
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 6)
                    .background(.white)
                    .foregroundStyle((isPointed && !isDeleteMode) ? .mint : .white)
                    .cornerRadius(12, corners: .allCorners)
                Spacer()
            }
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
