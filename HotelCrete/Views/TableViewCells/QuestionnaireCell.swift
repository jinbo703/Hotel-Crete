//
//  QuestionnaireCell.swift
//  HotelCrete
//
//  Created by John Nik on 25/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class QuestionnaireCell: BaseTableViewCell {
    
    var answer: String?
    var questionnaireController: QuestionnaireController?
    
    var question: Hotel.Question? {
        
        didSet {
            guard let question = question else { return }
            
            questionTextView.text = question.question
            
            if let answer = question.answer {
                self.answerButton.setTitle(answer.localized(), for: .normal)
            } else {
                self.answerButton.setTitle("Choose".localized(), for: .normal)
            }
        }
    }
    
    lazy var questionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .darkGray
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        return textView
    }()
    
    lazy var answerButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Choose", for: .normal)
        button.addTarget(self, action: #selector(didSelectAnswer), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupQuestionnaireViews()
    }
}

extension QuestionnaireCell {
    
    @objc func didSelectAnswer() {
        let alert = UIAlertController(style: .alert, title: "Questionnaire".localized(), message: "Please tell us your opinion".localized())
        
        let pickerViewValues: [[String]] = [["Excellent", "Very good", "Good", "Average", "Poor", "Yes", "No", "Maybe"].map({$0.localized()})]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 3)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            
            self.answer = values[index.column][index.row]
        }
        
        let answerActioin = UIAlertAction(title: "Done".localized(), style: .cancel) { (action) in
            
            if let _ = self.answer {
                
            } else {
                self.answer = "Average"
            }
            
            print("answered: ", self.answer ?? "")
            
            DispatchQueue.main.async {
                self.answerButton.setTitle(self.answer?.localized(), for: .normal)
            }
            
            if let answer = self.answer {
                self.questionnaireController?.handleQuestionnaireAnswer(answer, cell: self)
            }
        }
        alert.addAction(answerActioin)
        alert.show()
    }
    
}

extension QuestionnaireCell {
    
    fileprivate func setupQuestionnaireViews() {
        
        addSubview(answerButton)
        answerButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 100, height: 40)
        answerButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(questionTextView)
        questionTextView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: answerButton.leftAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
    }
}
