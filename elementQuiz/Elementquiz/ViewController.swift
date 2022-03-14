//
//  ViewController.swift
//  Elementquiz
//
//  Created by SD on 07/03/2022.
//

import UIKit
enum Mode {
    case flashCard
    case quiz
}
enum State {
    case question
    case answer
}
var mode: Mode = .flashCard
var state: State = .question

class ViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    @IBOutlet weak var answerLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    
var currentElementIndex = 0
    @IBOutlet weak var modeSelector: UISegmentedControl!
    //Updates the app's UI in flash card mode
    func updateFlashCardUI(){
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        if state == .answer {
            answerLabel.text = elementName
        }else{
            answerLabel.text = "?"
        }
        
    }
    @IBAction func showAnswer(_ sender: Any) {
        //answerLabel.text = elementList[currentElementIndex]
        state = .answer
        updateUI()
    }
    
    @IBOutlet weak var textField: UITextField!
    //@IBOutlet weak var modeSelector: UISegmentedControl!
    
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex == elementList.count {
            currentElementIndex = 0
        }
        state = .question
        updateUI()
    }
    //Updates the app's UI in quiz mode
    func updateQuizUI(){
         
    }
    func updateUI(){
        switch mode{
        case .flashCard:
            updateFlashCardUI()
        case .quiz:
            updateQuizUI()
        }
    }
    var answerIsCorrect = false
    var correctAnswercount = 0
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        let textFieldContets = textField.text!
        if textFieldContets.lowercased() == elementList[currentElementIndex].lowercased(){
            answerIsCorrect = true
            correctAnswercount += 1
        }else{
            answerIsCorrect = false
        }
        state = .answer
        
        updateUI()
        
        return true
    }
}
