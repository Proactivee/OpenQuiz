//
//  ViewController.swift
//  OpenQuiz
//
//  Created by Zappy on 14/08/2023.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var newGameButton : UIButton!
    @IBOutlet weak var questionView : QuestionView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue : "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionLoaded) , name: name, object: nil)
        // Do any additional setup after loading the view.
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector (dragQuestionView (_:) ))
        questionView.addGestureRecognizer(panGestureRecognizer)
        
//        Modifie corner radius
        newGameButton.layer.cornerRadius = 10
        questionView.layer.cornerRadius = 10
    }
    
    
    
    var game = Game()
    
    @objc func questionLoaded(){
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.title = game.currentQuestion.title
    }
                                                          
    @objc func dragQuestionView(_ sender : UIPanGestureRecognizer){
        if game.state == .ongoing{
            switch sender.state{
            case .began, .changed:
                transformQuestionViewWith(gesture : sender)
            case .ended, .cancelled:
                answerQuestion()
            default:
                break
            }
        }
       
            
        }
    
    func transformQuestionViewWith(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform (translationX: translation.x, y: translation.y)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationpercent = translation.x/(screenWidth/2)
        let rotationAngle = (CGFloat.pi/6) * translationpercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
         
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 0{
            questionView.style = .correct
        }else{
            questionView.style = .incorrect
        }
    }
    
    func answerQuestion (){
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
            
          
        case .incorrect:
            game.answerCurrentQuestion(with: false)
            
        case .standard:
            break
        }
        
        score.text = "\(game.score) / 10"
        
        
        if game.score >= 5  {
            
            score.transform = .identity
            score.transform = CGAffineTransform(scaleX: 2, y: 2)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8) {
                self.score.transform = .identity
            }
        }
         
        
//        Effets Boing et trnaslation extérieur ecran
        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform : CGAffineTransform
        
        if questionView.style == .correct{
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        }else{
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        
        UIView.animate(withDuration: 0.5) {
            self.questionView.transform = translationTransform
        } completion: { (success) in
            self.showQuestionView()
        }

      
    }
    
    private func showQuestionView(){
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX:  0.1, y: 0.1)
        questionView.style = .standard
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8,options: [],animations: {
            self.questionView.transform = .identity
        },completion: nil)
            
       
        
        switch game.state{
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
          
        }
    }
                    
    

    @IBAction func didTapeNewGameButton() {
        startNewGame()
    }
    
    
    private func startNewGame(){
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        questionView.title = "Loading ..."
        questionView.style = .standard
        score.text = "0 / 10"
        game.refresh()
    }
}

 
