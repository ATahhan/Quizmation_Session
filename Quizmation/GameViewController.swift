//
//  GameViewController.swift
//  Quizmation
//
//  Created by Ammar AlTahhan on 03/04/2019.
//  Copyright © 2019 Ammar AlTahhan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    enum Direction {
        case questionIn, questionOut
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var buttonsCenterConstraint: NSLayoutConstraint!
    
    var username: String?
    var questions: [Question] = []
    
    var currentQuestion: Question {
        return questions[currentQuestionNumber]
    }
    private(set) var score = 0
    private(set) var currentQuestionNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNewQuestion()
        setupAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation(direction: .questionIn)
    }
    
    func setupNewQuestion() {
        questionLabel.text = currentQuestion.title
        for button in buttons {
            button.setTitle(currentQuestion.options[button.tag], for: .normal)
            button.backgroundColor = .white
        }
    }
    
    func setupAnimation() {
        buttonsCenterConstraint.constant = -view.bounds.width
        questionLabel.alpha = 0
    }
    
    @IBAction func exitTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Alert", message: "Exiting quiz", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { (_) in
            self.dismiss(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
        
    }
    func startAnimation(direction: Direction) {
        switch direction {
        case .questionIn:
            
            self.buttonsCenterConstraint.constant = 0
            UIView.animate(withDuration: 0.8) {
                self.questionLabel.alpha = 1
                self.view.layoutIfNeeded()
            }
            
        case .questionOut:
            
            UIView.animate(withDuration: 0.8, animations: {
                self.questionLabel.alpha = 0
                self.buttonsCenterConstraint.constant = self.view.bounds.width
                self.view.layoutIfNeeded()
            }) { (_) in
                self.questionOutCompleted()
            }
        }
    }
    
    func questionOutCompleted() {
        guard currentQuestionNumber+1 < questions.count else {
            self.finishGame()
            return
        }
        currentQuestionNumber += 1
        setupNewQuestion()
        setupAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
            self.startAnimation(direction: .questionIn)
        }
        
    }
    
    func finishGame() {
        let alertController = UIAlertController(title: "Congratulations \(username ?? "")", message: "You've scored \(score) out of \(questions.count)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Return to Main Screen", style: .default, handler: { (_) in
            self.dismiss(animated: true)
        }))
        
        present(alertController, animated: true)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if isAnswerCorrect(sender.tag) {
            score += 1
            UIView.animate(withDuration: 0.5, animations: {
                sender.backgroundColor = .green
            }) { (_) in
                self.showNextQuestion()
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                sender.backgroundColor = .red
                for button in self.buttons where button.tag == self.currentQuestion.answer {
                    button.backgroundColor = .green
                }
            }) { (_) in
                self.showNextQuestion()
            }
        }
        
    }
    
    func showNextQuestion() {
        startAnimation(direction: .questionOut)
    }
    
    func isAnswerCorrect(_ number: Int) -> Bool {
        return number == currentQuestion.answer
    }

}
