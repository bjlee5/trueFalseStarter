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
    
    lazy var button: [UIButton] = { return [self.answerA, self.answerB, self.answerC, self.answerD] }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        questionIndexes = Array(0 ..< questions.count)
        questionIndexes.shuffle()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        currentQuestionIndex = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        let questionDictionary = questions[currentQuestionIndex]
        questionField.text = questionDictionary.question
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
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        /*
        
        let selectedQuestionDict = questions[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.correctA
        
        if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2) */
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
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
