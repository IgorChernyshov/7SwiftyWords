//
//  ViewController.swift
//  7SwiftyWords
//
//  Created by Igor Chernyshov on 28.06.2021.
//

import UIKit

final class ViewController: UIViewController {

	// MARK: - Subviews
	private var cluesLabel: UILabel!
	private var answersLabel: UILabel!
	private var currentAnswer: UITextField!
	private var scoreLabel: UILabel!
	private var letterButtons = [UIButton]()

	// MARK: - Properties
	private var activatedButtons = [UIButton]()
	private var solutions = [String]()
	private var level = 1
	private var correctAnswers = 0
	private var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	// MARK: - Lifecycle
	override func loadView() {
		configureUI()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		loadLevel()
	}

	// MARK: - UI Configuration
	private func configureUI() {
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
		cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		view.addSubview(cluesLabel)

		answersLabel = UILabel()
		answersLabel.translatesAutoresizingMaskIntoConstraints = false
		answersLabel.font = UIFont.systemFont(ofSize: 24)
		answersLabel.text = "ANSWERS"
		answersLabel.numberOfLines = 0
		answersLabel.textAlignment = .right
		answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
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
		submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
		view.addSubview(submitButton)

		let clearButton = UIButton(type: .system)
		clearButton.translatesAutoresizingMaskIntoConstraints = false
		clearButton.setTitle("CLEAR", for: .normal)
		clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
		view.addSubview(clearButton)

		let buttonsView = UIView()
		buttonsView.translatesAutoresizingMaskIntoConstraints = false
		buttonsView.layer.borderWidth = 2.0
		buttonsView.layer.borderColor = UIColor.lightGray.cgColor
		buttonsView.layer.cornerRadius = 8.0
		buttonsView.layer.masksToBounds = true
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
			buttonsView.heightAnchor.constraint(equalToConstant: 320),
			buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
			buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
		])

		let buttonWidth = 150
		let buttonHeight = 80

		for row in 0..<4 {
			for column in 0..<5 {
				let letterButton = UIButton(type: .custom)
				letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
				letterButton.setTitleColor(.systemBlue, for: .normal)
				letterButton.setTitle("WWW", for: .normal)
				let frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
				letterButton.frame = frame
				buttonsView.addSubview(letterButton)
				letterButtons.append(letterButton)
				letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
			}
		}
	}

	// MARK: - Selectors
	@objc private func letterTapped(_ sender: UIButton) {
		guard let buttonTitle = sender.titleLabel?.text else { return }
		currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
		activatedButtons.append(sender)
		UIView.animate(withDuration: 0.3) {
			sender.alpha = 0
		}
	}

	@objc private func submitTapped(_ sender: UIButton) {
		guard let answerText = currentAnswer.text else { return }
		guard let solutionPosition = solutions.firstIndex(of: answerText) else {
			score -= 1
			return showWrongAnswerAlert()
		}

		activatedButtons.removeAll()

		var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
		splitAnswers?[solutionPosition] = answerText
		answersLabel.text = splitAnswers?.joined(separator: "\n")

		currentAnswer.text = ""
		score += 1
		correctAnswers += 1

		if correctAnswers == 7 {
			let alertController = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
			present(alertController, animated: true)
		}
	}

	@objc private func clearTapped(_ sender: UIButton) {
		currentAnswer.text = ""
		UIView.animate(withDuration: 0.3) {
			self.letterButtons.forEach { $0.alpha = 1 }
		}
		activatedButtons.removeAll()
	}

	private func levelUp(action: UIAlertAction) {
		level += 1
		correctAnswers = 0
		solutions.removeAll(keepingCapacity: true)

		loadLevel()

		UIView.animate(withDuration: 0.3) {
			self.letterButtons.forEach { $0.alpha = 1 }
		}
	}

	// MARK: - Alerts
	private func showWrongAnswerAlert() {
		let alertController = UIAlertController(title: "Wrong guess", message: "Your word doesn't answer any of the questions", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
			self?.clearTapped(UIButton())
		})
		present(alertController, animated: true)
	}

	// MARK: - Game Logic
	private func loadLevel() {
		var clueString = ""
		var solutionString = ""
		var letterBits = [String]()

		DispatchQueue.global(qos: .userInteractive).async { [weak self] in
			guard let self = self,
				  let levelFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: "txt"),
				  let levelContents = try? String(contentsOf: levelFileURL) else { return }

			var lines = levelContents.components(separatedBy: "\n")
			lines.shuffle()

			for (index, line) in lines.enumerated() {
				let parts = line.components(separatedBy: ": ")
				let answer = parts[0]
				let clue = parts[1]

				clueString += "\(index + 1). \(clue)\n"

				let solutionWord = answer.replacingOccurrences(of: "|", with: "")
				solutionString += "\(solutionWord.count) letters\n"
				self.solutions.append(solutionWord)

				let bits = answer.components(separatedBy: "|")
				letterBits += bits
			}

			DispatchQueue.main.async {
				self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
				self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

				letterBits.shuffle()

				guard letterBits.count == self.letterButtons.count else { return }
				for index in 0 ..< self.letterButtons.count {
					self.letterButtons[index].setTitle(letterBits[index], for: .normal)
				}
			}
		}
	}
}
