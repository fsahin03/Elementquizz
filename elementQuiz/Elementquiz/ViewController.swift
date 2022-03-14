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
    case score
}


class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //updateUI()
        mode = .flashCard
    }
    var mode: Mode = .flashCard {
        didSet{
            switch mode{
            case .flashCard:
                setUpFlashCards()
            case . quiz:
                setUpQuiz()
            }
            updateUI()
        }
    }
    
   
    var state: State = .question
    
    @IBOutlet weak var answerLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    var elementList: [String] = []
    let fixedElements = ["Carbon", "Gold", "Chlorine", "Sodium"]
var currentElementIndex = 0
    @IBOutlet weak var modeSelector: UISegmentedControl!
    //Updates the app's UI in flash card mode
    func updateFlashCardUI(elementName : String){
        //Text field and keyboard
        textField.isHidden = true
        textField.resignFirstResponder()
        if state == .answer {
            answerLabel.text = elementName
        }else{
            answerLabel.text = "?"
        }
        //segmented control
        modeSelector.selectedSegmentIndex = 0
        //Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)
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
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz{
                state = .score
                updateUI()
                return
            }
        }
        state = .question
        updateUI()
    }
    //Updates the app's UI in quiz mode
    func updateQuizUI(elementName : String){
        //Text field and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.resignFirstResponder()
        case.score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        switch state{
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!!"
            } else {
                answerLabel.text = "❌"
            }
        case .score:
            answerLabel.text = ""
            print("Your score is \(correctAnswercount) out of \(elementList.count).")
        }
        if state == .score{
            displayScoreAlert()
        }
        //segmented control
        modeSelector.selectedSegmentIndex = 1
        //Buttons
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Show Score", for: .normal )
        }else{
            nextButton.setTitle("Next Question", for: .normal)
        }
        switch state{
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case.score:
            nextButton.isEnabled = false
        }
    }
    func updateUI(){
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        switch mode{
        case .flashCard:
            updateFlashCardUI(elementName : elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    var answerIsCorrect = false
    var correctAnswercount = 0
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{

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
    func displayScoreAlert(){
        let alert = UIAlertController(title: "Quiz Score", message:"Your score is\(correctAnswercount) out of \(elementList.count)." , preferredStyle: .alert)
    
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:)); alert.addAction(dismissAction)
        present(alert,animated: true,completion: nil )
    }
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }
    
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        }else{
            mode = .quiz
        }
    }
    func setUpFlashCards() {
        state = .question
        currentElementIndex = 0
        elementList = fixedElements
    }
    func setUpQuiz() {
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswercount = 0
        elementList = fixedElements.shuffled()
    }
    
    @IBOutlet weak var showAnswerButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
}
