//
//  QuestionView.swift
//  OpenQuiz
//
//  Created by Zappy on 15/08/2023.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet private var label : UILabel!
    @IBOutlet private var icone : UIImageView!
    
    
    
    
    enum Style {
        case correct, incorrect , standard
    }
    
    var style : Style = .standard {
        didSet{
            setStyle(style)
        }
    }
    
    private func setStyle (_ style : Style){
        switch style {
        case.correct:
            backgroundColor = UIColor(red: 200/255, green: 236/255, blue: 160/255 , alpha: 1 )
            icone.image = UIImage(named: "Icon Correct")
            icone.isHidden = false
        case.incorrect:
            backgroundColor = #colorLiteral(red: 0.9506447911, green: 0.5277531743, blue: 0.5786799788, alpha: 1)
            icone.image = UIImage(named: "Icon Error")
            icone.isHidden = false 
        case.standard:
            backgroundColor = #colorLiteral(red: 0.7493521571, green: 0.7692790031, blue: 0.7861276269, alpha: 1)
            icone.isHidden = true
        }
        
    }
    
    var title = "" {
        didSet {
            label.text = title
        }
    }
    

}
