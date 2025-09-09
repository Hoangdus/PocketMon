//
//  GiantWheel.swift
//  PocketMon
//
//  Created by HoangDus on 4/9/25.
//

import SwiftUI

struct GiantWheel: View {
    
    var size: CGFloat
    var index: Int
    
    init(size: CGFloat, index: Int){
        self.size = size
        self.index = index
    }
    
    var body: some View {
        CircleSlice(
            start: Angle(degrees: size * CGFloat(index)),
            end: Angle(degrees: size * CGFloat(index + 1))
        )
        .fill(Color.red)
        .clockHandRotationEffect(period: 7)
        .frame(width: 200000, height: 200000)
        .offset(x: 0, y: 100000 * 0.9)
    }
}

struct CircleSlice: Shape {
    var start: Angle
    var end: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.midX, startAngle: start, endAngle: end, clockwise: false)
        return path
    }
}
