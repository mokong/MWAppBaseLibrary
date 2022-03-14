//
//  UIKit_Extensions.swift
//  MWAppBase
//
//  Created by MorganWang on 8/12/2021.
//

import Foundation
import UIKit

extension UIButton {
    func setInsets(
        forContentPadding contentPadding: UIEdgeInsets,
        imageTitlePadding: CGFloat
    ) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
}

extension UIView {
    func removeAllTextLayers() {
        if let tempSubLayers = layer.sublayers {
            for subLayer in tempSubLayers {
                if let _ = subLayer as? CATextLayer {
                    subLayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func addWaterMarkText(_ text: String?, textColor: UIColor, font: UIFont, direction: MWWaterMarkIDPhotoType, finishCallback: (() -> Void)?) {
        // 计算水印文字的宽高
        guard let str = text as NSString? else {
            finishCallback?()
            return
        }
        
        let textSize = str.size(withAttributes: [NSAttributedString.Key.font : font])
        let height = MWScreenHeight

        let line = 5
        let row = 10
        let leftRowSpace: CGFloat = 30.0
        let centerRowSpace: CGFloat = 140.0
        let layerHeight: CGFloat = 60.0
        let lineSpace = height/5.0 - layerHeight
        let layerHeightExtra = 5.0 // 加高一点，防止文字被切割

        for i in 0..<line {
            for j in 0..<row {
                let textLayer = CATextLayer()
                textLayer.contentsScale = MWScreenScale
                let fontName = font.fontName as CFString
                textLayer.font = CGFont(fontName)
                textLayer.fontSize = font.pointSize
                textLayer.foregroundColor = textColor.cgColor
                textLayer.string = text
                
                var left = leftRowSpace*CGFloat(i) + CGFloat(j) * (0.0 + centerRowSpace)
                if direction == .fullScreenRight {
                   left = MWScreenWidth - left
                }
                let top = CGFloat(i) * layerHeight + lineSpace * CGFloat(i + 0)
                let width = textSize.width + layerHeightExtra
                let height = textSize.height + layerHeightExtra
//                print("left: %f, top: %f", left, top)
                textLayer.frame = CGRect(x: left, y: top, width: width, height: height)
                
                // 旋转文字
                if direction == .fullScreenRight {
                    textLayer.transform = CATransform3DMakeRotation(.pi/5.0, 0.0, 0.0, 3.0)
                }
                else {
                    textLayer.transform = CATransform3DMakeRotation(-.pi/5.0, 0.0, 0.0, 3.0)
                }
                self.layer.addSublayer(textLayer)
            }
        }
        
        finishCallback?()
    }
    
    /// Remove all subviews
    func removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    public func snapshotImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            rendererContext.cgContext.setFillColor(UIColor.cyan.cgColor)
            rendererContext.cgContext.setStrokeColor(UIColor.yellow.cgColor)
            layer.render(in: rendererContext.cgContext)
        }
    }

    public func snapshotView() -> UIView? {
        if let snapshotImage = snapshotImage() {
            return UIImageView(image: snapshotImage)
        } else {
            return nil
        }
    }
}
