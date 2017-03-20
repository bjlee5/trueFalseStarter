//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

// Really close. Issues are in the didTapAnswerButton func - Correct or Wrong will not populate on the screen. Once game is completed, the score is not populating on the screen. The code in the Stack Overflow example speaks about using a 'Next' button which we do not have. How to replace this functionality? // 

class MainVC: UIViewController {
    
    let questionsPerRound = 7
    var questionsAsked = 0
    var correctQuestions = 0
    var questionIndexes: [Int]!
    var currentQuestionIndex = 0
    
    var gameSound: SystemSoundID = 0
    
    
    let questions: [Quiz] = [
        Quiz(question: "Barack Obama was first elected president of the United States in what year?", answers: ["2008", "2004", "2012", "2010"], correctAnswer: 0),
        Quiz(question: "How many U.S. presidents were only children?", answers: ["Two", "None", "Three", "One"], correctAnswer: 1),
        Quiz(question: "Who was the first Roman Catholic to be Vice President of the United States of America?", answers: ["Joe Biden", "Dick Cheney", "Mike Pence", "George H.W. Bush"], correctAnswer: 0),
        Quiz(question: "How many US Supreme Court justices are there?", answers: ["Eleven", "Five", "Seven", "Nine"], correctAnswer: 3),
        Quiz(question: "Which US president was known as 'The Great Communicator'?", answers: ["Ronald Regan", "Barack Obama", "George W Bush", "John F Kennedy"], correctAnswer: 0),
        Quiz(question: "The Electoral College in the United States is made up of how many electors?", answers: ["600", "500", "538", "578"], correctAnswer: 2),
        Quiz(question: "How old must a person be to run for President of the United States?", answers: ["35", "38", "42", "45"], correctAnswer: 0)]
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    @IBOutlet weak var answerD: UIButton!
    
    lazy var buttons: [UIButton] = { return [self.answerA, self.answerB, self.answerC, self.answerD] }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        questionIndexes = Array(0 ..< questions.count)
        questionIndexes.shuffle()
        updateLabelsAndButtonsForIndex(questionIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // New methods from example //
    
    func updateLabelsAndButtonsForIndex(questionIndex: Int) {
        // if we're done, show message in `endLabel` and hide `nextButton`
        guard questionIndex < questions.count else {
            playAgainButton.isHidden = true
            return
        }
        // update our property
        
        currentQuestionIndex = questionIndex
        
        // hide end label and next button
        
        hideEndLabelAndNextButton()
        
        // identify which question we're presenting
        
        let questionObject = questions[questionIndexes[questionIndex]]
        
        // update question label and answer buttons accordingly
        
        questionField.text = questionObject.question
        for (answerIndex, button) in buttons.enumerated() {
            button.setTitle(questionObject.answers[answerIndex], for: .normal)
        }
    }
    
    func hideEndLabelAndNextButton() {
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        answerA.isHidden = true
        answerB.isHidden = true
        answerC.isHidden = true
        answerD.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
// Old methods //
    
    @IBAction func didTapAnswerButton(button: UIButton) {
        questionsAsked += 1
        
        let buttonIndex = buttons.index(of: button)
        let questionObject = questions[questionIndexes[currentQuestionIndex]]
        
        if buttonIndex == questionObject.correctAnswer {
            questionField.text = "CORRECT!"
            correctQuestions += 1
            updateLabelsAndButtonsForIndex(questionIndex: currentQuestionIndex + 1)
        } else {
            questionField.text = "WRONG!"
            updateLabelsAndButtonsForIndex(questionIndex: currentQuestionIndex + 1)
        }
        loadNextRoundWithDelay(seconds: 2)
    }
    

    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
        playAgainButton.isHidden = false
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        answerA.isHidden = false
        answerB.isHidden = false
        answerC.isHidden = false
        answerD.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
