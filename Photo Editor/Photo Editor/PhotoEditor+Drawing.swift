//
//  PhotoEditor+Drawing.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import UIKit

extension PhotoEditorViewController {
    
    override public func touchesBegan(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        let drawing = isDrawing || isDrawingArrow
        if drawing {
            swiped = false
            if let touch = touches.first {
                lastPoint = touch.location(in: self.canvasImageView)
                firstPoint = lastPoint
            }
        }
            //Hide stickersVC if clicked outside it
        else if stickersVCIsVisible == true {
            if let touch = touches.first {
                let location = touch.location(in: self.view)
                if !stickersViewController.view.frame.contains(location) {
                    removeStickersView()
                }
            }
        }
        
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        let drawing = isDrawing || isDrawingArrow
        if drawing {
            // 6
            swiped = true
            if let touch = touches.first {
                let currentPoint = touch.location(in: canvasImageView)
                if isDrawing {
                    drawLineFrom(lastPoint, toPoint: currentPoint)
                } else if isDrawingArrow {
                    drawArrowFrom(firstPoint, to: currentPoint)
                    arrowDrawBegin = true
                }
                // 7
                lastPoint = currentPoint
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        if isDrawing {
            if !swiped {
                // draw a single point
                drawLineFrom(lastPoint, toPoint: lastPoint)
            }
        }
        arrowDrawBegin = false
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
        let canvasSize = canvasImageView.frame.integral.size
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            canvasImageView.image?.draw(in: CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height))
            // 2
            context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            // 3
            context.setLineCap( CGLineCap.round)
            context.setLineWidth(5.0)
            context.setStrokeColor(drawColor.cgColor)
            context.setBlendMode( CGBlendMode.normal)
            // 4
            context.strokePath()
            // 5
            canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
    }
    
    func drawArrow(from startPoint: CGPoint, to endPoint: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) {
        let length = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
        let tailLength = length - headLength
        
        let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        let tailTransform = CGAffineTransform(translationX: startPoint.x, y: startPoint.y)
            .rotated(by: angle)
        
        let tailPoints = [
            CGPoint(x: 0, y: tailWidth / 2),
            CGPoint(x: tailLength, y: tailWidth / 2),
            CGPoint(x: tailLength, y: headWidth / 2),
            CGPoint(x: length, y: 0),
            CGPoint(x: tailLength, y: -headWidth / 2),
            CGPoint(x: tailLength, y: -tailWidth / 2),
            CGPoint(x: 0, y: -tailWidth / 2),
            CGPoint(x: 0, y: tailWidth / 2)
        ]
        let tailPath = CGMutablePath()
        tailPath.addLines(between: tailPoints, transform: tailTransform)
        let arrowLayer = CAShapeLayer()
        arrowLayer.path = tailPath
        arrowLayer.fillColor = drawColor.cgColor
        arrowLayer.strokeColor = drawColor.cgColor
        arrowLayer.lineCap = .round
        arrowLayer.lineJoin = .round
        arrowLayer.lineWidth = 1.5
        canvasImageView.layer.addSublayer(arrowLayer)
    }
    
    func drawArrowFrom(_ from: CGPoint, to: CGPoint) {
        if arrowDrawBegin {
            canvasImageView.layer.sublayers?.last?.removeFromSuperlayer()
        }
        drawArrow(from: from, to: to, tailWidth: 3, headWidth: 20, headLength: 20)
    }
    
}
