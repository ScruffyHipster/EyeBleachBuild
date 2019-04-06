//
//  Animations.swift
//  EyeBleachBuild
//
//  Created by Tom Murray on 06/04/2019.
//  Copyright © 2019 Tom Murray. All rights reserved.
//

import Foundation
import UIKit

struct UsableAnimations {
	
	let pulse: CASpringAnimation = {
		let pulse = CASpringAnimation(keyPath: "transform.scale")
		pulse.fromValue = 0.85
		pulse.toValue = 1.00
		pulse.damping = 7.5
		pulse.duration = 2.0
		return pulse
	}()
	
	let fadeAnimation: CABasicAnimation = {
		let fadeAnimation = CABasicAnimation(keyPath: "opacity")
		fadeAnimation.fromValue = 0.0
		fadeAnimation.toValue = 1.0
		fadeAnimation.duration = 1.0
		return fadeAnimation
	}()
	
	let fadeIn: CABasicAnimation = {
		let fadeIn = CABasicAnimation(keyPath: "opacity")
		fadeIn.fromValue = 0.0
		fadeIn.toValue = 1
		return fadeIn
	}()
	
	let springPulse: CASpringAnimation = {
		let springPulse = CASpringAnimation(keyPath: "transform.scale")
		springPulse.duration = 0.5
		springPulse.initialVelocity = -10.0
		springPulse.mass = 1
		springPulse.damping = 10
		springPulse.stiffness = 100
		springPulse.duration = 1.0
		springPulse.fromValue = 1.4
		springPulse.toValue = 1.0
		return springPulse
	}()
	
	func fade(layer: CALayer, from: Float, to: Float, duration: Double) {
		let fade = CABasicAnimation(keyPath: "opacity")
		fade.fromValue = from
		fade.toValue = to
		fade.duration = duration
		layer.add(fade, forKey: nil)
	}
	
	let flyRight: CABasicAnimation = {
		let flyRight = CABasicAnimation(keyPath: "position.x")
		
		return flyRight
	}()
		
	func scaleAndTransform(layer: CALayer, from: CGFloat, to: CGFloat, duration: Double) {
		let scaleAndTransform = CABasicAnimation(keyPath: "position.y")
		scaleAndTransform.fromValue = from
		scaleAndTransform.toValue = to
		scaleAndTransform.duration = duration
		layer.add(scaleAndTransform, forKey: nil)
		layer.position.y = to
	}
	
	func opacity(layer: CALayer, from: Float, to: Float, duration: Double) {
		let opacityAnimation = CABasicAnimation(keyPath: "opacity")
		opacityAnimation.fromValue = from
		opacityAnimation.toValue = to
		opacityAnimation.duration = duration
		opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
		layer.add(opacityAnimation, forKey: nil)
		layer.opacity = to
	}
}
