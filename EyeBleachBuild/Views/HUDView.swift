//
//  HUDView.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 18/02/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit


class HUDView: UIView {
	
	//MARK:- Properties
	let activityIndicator: UIActivityIndicatorView = {
		var av = UIActivityIndicatorView()
		av.style = .whiteLarge
		av.startAnimating()
		return av
	}()
	
	var boxText: String?
	
	//MARK:- Functions
	
	class func hudView(in view: UIView, animated: Bool) -> HUDView {
		let hudVew = HUDView(frame: view.bounds)
		view.addSubview(hudVew)
		view.isUserInteractionEnabled = false
		hudVew.show(animated: animated)
		hudVew.backgroundColor = UIColor.clear
		return hudVew
	}
	
	override func draw(_ rect: CGRect) {
		let width: CGFloat = 140
		let height: CGFloat = 140
		let boxRect = CGRect(x: round((bounds.size.width - width) / 2 ), y: round((bounds.size.height - height) / 2 ), width: width, height: height)
		let roundRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 8)
		UIColor(white: 0.3, alpha: 0.8).setFill()
		roundRect.fill()
		
		activityIndicator.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2 - 10)
		
		guard let text = boxText else {return}
		let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]
		let textSize = text.size(withAttributes: attributes)
		let textPoint = CGPoint(x: center.x - round(textSize.width / 2), y: center.y - round(textSize.height / 2) + height / 4)
		text.draw(at: textPoint, withAttributes: attributes)
	}
	
	//TODO:- Redraw this HUDView
	func show(animated: Bool) {
		alpha = 0
		transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
		if animated {
			alpha = 1
			UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [], animations: {
				self.transform = .identity
				self.alpha = 1
			}, completion: {_ in
				UIView.animate(withDuration: 0.2, animations: {
					self.addSubview(self.activityIndicator)
				})
			})
		}
	}
	
	func moveFrom(to: CGFloat, layer: CALayer) {
		let anim = CABasicAnimation(keyPath: "position.y")
		anim.fromValue = layer.position.y
		anim.toValue = to
		anim.duration = 0.5
		layer.add(anim, forKey: nil)
		layer.position.y = to
	}
	
	func remove(animated: Bool) {
		if animated {
			alpha = 0
			superview?.isUserInteractionEnabled = true
			self.removeFromSuperview()
		}
	}
	
	
	
}
