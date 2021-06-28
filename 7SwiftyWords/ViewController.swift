//
//  ViewController.swift
//  7SwiftyWords
//
//  Created by Igor Chernyshov on 28.06.2021.
//

import UIKit

final class ViewController: UIViewController {

	// MARK: - Properties
	var cluesLabel: UILabel!
	var answersLabel: UILabel!
	var currentAnswer: UITextField!
	var scoreLabel: UILabel!
	var letterButtons = [UIButton]()

	// MARK: - Lifecycle
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white

		scoreLabel = UILabel()
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		scoreLabel.textAlignment = .right
		scoreLabel.text = "Score: 0"
		view.addSubview(scoreLabel)

		cluesLabel = UILabel()
		cluesLabel.translatesAutoresizingMaskIntoConstraints = false
		cluesLabel.font = UIFont.systemFont(ofSize: 24)
		cluesLabel.text = "CLUES"
		cluesLabel.numberOfLines = 0
//		cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		view.addSubview(cluesLabel)

		answersLabel = UILabel()
		answersLabel.translatesAutoresizingMaskIntoConstraints = false
		answersLabel.font = UIFont.systemFont(ofSize: 24)
		answersLabel.text = "ANSWERS"
		answersLabel.numberOfLines = 0
		answersLabel.textAlignment = .right
//		answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		view.addSubview(answersLabel)

		currentAnswer = UITextField()
		currentAnswer.translatesAutoresizingMaskIntoConstraints = false
		currentAnswer.placeholder = "Tap letters to guess"
		currentAnswer.textAlignment = .center
		currentAnswer.font = UIFont.systemFont(ofSize: 44)
		currentAnswer.isUserInteractionEnabled = false
		view.addSubview(currentAnswer)

		let submitButton = UIButton(type: .system)
		submitButton.translatesAutoresizingMaskIntoConstraints = false
		submitButton.setTitle("SUBMIT", for: .normal)
		view.addSubview(submitButton)

		let clearButton = UIButton(type: .system)
		clearButton.translatesAutoresizingMaskIntoConstraints = false
		clearButton.setTitle("CLEAR", for: .normal)
		view.addSubview(clearButton)

		let buttonsView = UIView()
		buttonsView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(buttonsView)

		NSLayoutConstraint.activate([
			scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

			cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
			cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

			answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
			answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
			answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),

			currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
			currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),

			submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
			submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
			submitButton.heightAnchor.constraint(equalToConstant: 44),

			clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
			clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
			clearButton.heightAnchor.constraint(equalToConstant: 44),

			buttonsView.widthAnchor.constraint(equalToConstant: 750),
			buttonsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 320),
			buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
			buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
		])

		let buttonWidth = 150
		let buttonHeight = 80

		for row in 0..<4 {
			for column in 0..<5 {
				let letterButton = UIButton(type: .system)
				letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
				letterButton.setTitle("WWW", for: .normal)
				let frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
				letterButton.frame = frame
				buttonsView.addSubview(letterButton)
				letterButtons.append(letterButton)
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}
