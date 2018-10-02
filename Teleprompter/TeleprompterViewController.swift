//
//  TeleprompterViewController.swift
//  Teleprompter
//
//  Created by Jacob Sokora on 10/1/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit

class TeleprompterViewController: UIViewController {

	@IBOutlet weak var leftBarConstraint: NSLayoutConstraint!
	@IBOutlet weak var rightBarConstraint: NSLayoutConstraint!
	@IBOutlet weak var teleprompterTextView: UITextView!
	@IBOutlet weak var topOverlayView: UIView!
	
	let barWidth: CGFloat = 15
	var flipped = false
	var timer: Timer?
	var currentOffet = CGPoint.zero
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		teleprompterTextView.textContainerInset = UIEdgeInsets(top: topOverlayView.frame.height + 30, left: 0, bottom: topOverlayView.frame.height + 30, right: 0)
		teleprompterTextView.setContentOffset(currentOffet, animated: false)
	}
	
	@IBAction func playText(_ sender: UIBarButtonItem) {
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
			self.currentOffet.y += 2
			self.teleprompterTextView.setContentOffset(self.currentOffet, animated: true)
		}
	}
	
	@IBAction func pauseText(_ sender: UIBarButtonItem) {
		guard let timer = timer else {
			return
		}
		timer.invalidate()
	}
	
	@IBAction func rewindText(_ sender: UIBarButtonItem) {
		guard let timer = timer else {
			return
		}
		timer.invalidate()
		currentOffet = .zero
		teleprompterTextView.setContentOffset(currentOffet, animated: true)
	}
	
	@IBAction func flipText(_ sender: UIBarButtonItem) {
		let transform = CGAffineTransform(scaleX: 1, y: flipped ? -1 : 1)
		flipped = !flipped
		UIView.animate(withDuration: 0) {
			self.teleprompterTextView.transform = transform
		}
	}
	
	@IBAction func leftBarDragged(_ sender: UIPanGestureRecognizer) {
		let amount = sender.velocity(in: self.view).x / 100
		let newPosition = min(max(leftBarConstraint.constant + amount, 0), (self.view.frame.width / 2) - (barWidth * 2))
		leftBarConstraint.constant = newPosition
		rightBarConstraint.constant = newPosition
	}
	
	@IBAction func rightBarDragged(_ sender: UIPanGestureRecognizer) {
		let amount = sender.velocity(in: self.view).x / 100
		let newPosition = min(max(leftBarConstraint.constant - amount, 0), (self.view.frame.width / 2) - (barWidth * 2))
		leftBarConstraint.constant = newPosition
		rightBarConstraint.constant = newPosition
	}
}
