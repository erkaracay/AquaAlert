//
//  Shapes.swift
//  AquaAlert
//
//  Created by Suphi Erkin Karaçay on 18.12.2024.
//

import SwiftUI

struct BottleShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            // Start at the neck top center
            path.move(to: CGPoint(x: width * 0.5, y: height * 0.08))
            
            // Right side of the neck
            path.addLine(to: CGPoint(x: width * 0.62, y: height * 0.08))
            path.addLine(to: CGPoint(x: width * 0.62, y: height * 0.18))
            
            // Right shoulder
            path.addQuadCurve(to: CGPoint(x: width * 0.82, y: height * 0.33),
                              control: CGPoint(x: width * 0.72, y: height * 0.23))
            
            // Right body
            path.addLine(to: CGPoint(x: width * 0.82, y: height * 0.8))
            
            // Right bottom curve
            path.addQuadCurve(to: CGPoint(x: width * 0.18, y: height * 0.8),
                              control: CGPoint(x: width * 0.5, y: height * 0.9))
            
            // Left body
            path.addLine(to: CGPoint(x: width * 0.18, y: height * 0.33))
            
            // Left shoulder
            path.addQuadCurve(to: CGPoint(x: width * 0.38, y: height * 0.18),
                              control: CGPoint(x: width * 0.28, y: height * 0.23))
            
            // Left side of the neck
            path.addLine(to: CGPoint(x: width * 0.38, y: height * 0.08))
            path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.08))
            
            // Close the path
            path.closeSubpath()
        }
    }
}



struct WaveShape: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    var phase: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midHeight = rect.height / 2
        let width = rect.width

        path.move(to: CGPoint(x: 0, y: midHeight))

        for x in stride(from: 0, to: width, by: 1) {
            let relativeX = x / width
            let sine = sin((relativeX * frequency + phase) * 2 * .pi)
            let y = midHeight + amplitude * sine
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}
