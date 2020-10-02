//
//  DVMQuestionViewController.swift
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

import UIKit

class DVMQuestionViewController: UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionCountLabel: UILabel!
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    var currentGame: DVMGame?
    var currentQuestion = 0
    var correctAnswer = 0
    var sessionToken: String?
    var gameCount = 1
    
    let gameType = "multiple"
    let gameDifficulty = "medium"
    let gameNumQuestions = 10
    let gameCategoryId = 18 //Science:Computers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetViews()
        newGame()
    }
    
    @IBAction func answerButtonTouchDown(_ sender: UIButton) {
        if (sender.tag == correctAnswer && currentGame != nil) {
            sender.backgroundColor = .green
        } else {
            sender.backgroundColor = .red
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        
        if sender.tag == 0 && currentGame == nil {
            newGame()
            return
        }
        
        if (sender.tag == correctAnswer && currentGame != nil) {
            let hasMoreQuestions = nextQuestion()
            if !hasMoreQuestions {
                
                let alertController = UIAlertController(title: "Game Over", message: "Another round?", preferredStyle: .alert)
                let firstAction = UIAlertAction(title: "New Round", style: .default) { (pressed) in
                    DispatchQueue.main.async {
                        self.gameCount += 1
                        self.newGame()
                    }
                }
                let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                
                alertController.addAction(firstAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
            }
        } else {
            //            sender.backgroundColor = .red
        }
    }
    
    func updateViews() {
        guard currentGame != nil else { return }
        let question = currentGame?.questions[currentQuestion] as! DVMQuestion
        let currentGameCount = (currentGame!.questions.count * gameCount)
        let currentQuestionNumber = (currentQuestion + 1) + (currentGameCount - gameNumQuestions)
        questionLabel.text = question.question
        categoryLabel.text = question.category
        difficultyLabel.text = "Level:\(question.difficulty.capitalized)"
        questionCountLabel.text = String("Question \(currentQuestionNumber)/\(currentGameCount)")
        
        
        let indicies = [0,1,2,3].shuffled()
        
        let answers = [question.correctAnswer,
                       question.incorrectAnswers[0],
                       question.incorrectAnswers[1],
                       question.incorrectAnswers[2]]
        
        var shuffledArray: [String] = ["","","",""]
        for i in 0...3 {
            let str = "\(answers[i])"
            shuffledArray[i] = str
            if indicies[i] == 0 {
                correctAnswer = i
            }
        }
        
        let answer1String = answers[indicies[0]] as! String
        let answer2String = answers[indicies[1]] as! String
        let answer3String = answers[indicies[2]] as! String
        let answer4String = answers[indicies[3]] as! String
        
        answer1Button.setTitle("\(answer1String)", for: .normal)
        answer2Button.setTitle("\(answer2String)", for: .normal)
        answer3Button.setTitle("\(answer3String)", for: .normal)
        answer4Button.setTitle("\(answer4String)", for: .normal)
    }
    
    func resetViews() {
        questionLabel.text = ""
        categoryLabel.text = ""
        difficultyLabel.text = ""
        questionCountLabel.text = ""
        
        answer1Button.setTitle("", for: .normal)
        answer2Button.setTitle("", for: .normal)
        answer3Button.setTitle("", for: .normal)
        answer4Button.setTitle("", for: .normal)
        
        answer1Button.backgroundColor = .darkGray
        answer2Button.backgroundColor = .darkGray
        answer3Button.backgroundColor = .darkGray
        answer4Button.backgroundColor = .darkGray
    }
    
    func nextQuestion() -> Bool {
        resetViews()
        if currentQuestion + 1 < currentGame!.questions.count {
            currentQuestion = currentQuestion + 1
            updateViews()
            return true
        }else{
            // no more questions left, new game instead?
            //            resetViews()
            currentGame = nil
            answer1Button.setTitle("New Game", for: .normal);
            return false
        }
    }
    
    func newGame() {
        currentQuestion = 0
        if sessionToken == nil {
            DVMGameController.requestSessionToken { (token, responseCode) in
                if responseCode == ResponseCode.success {
                    self.sessionToken = token
                    self.newGame()
                } else {
                    print("[\(#function):\(#line)] -- \(DVMGameController.codeDescription(responseCode))")
                }
            }
        } else {
            guard let sessionToken = sessionToken else { return }
            DVMGameController.fetchNewGame(ofType: gameType, difficulty: gameDifficulty, category: gameCategoryId, numberOfQuestions: gameNumQuestions, sessionToken: sessionToken) { (game, responseCode) in
                if (responseCode == ResponseCode.success) {
                    self.currentGame = game;
                    print("\(self.currentGame!.description)")
                    DispatchQueue.main.async {
                        self.updateViews()
                    }
                } else {
                    print("Error [\(#function):\(#line)] -- Response Code:\(DVMGameController.codeDescription(responseCode))")
                }
            }
        }
    }
}
