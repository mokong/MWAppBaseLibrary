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
