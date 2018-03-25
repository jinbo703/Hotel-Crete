//
//  QuestionnaireController.swift
//  HotelCrete
//
//  Created by John Nik on 25/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuestionnaireController: UIViewController {
    
    let cellId = "cellId"
    let footerId = "footerId"
    
    var ratingValue: Int?
    
    var questioinnaires: [Hotel.Questionnaire] = []
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .singleLine
        tv.separatorColor = .darkGray
        tv.keyboardDismissMode = .onDrag
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupViews()
        fetchQuestionnaires()
    }
}

extension QuestionnaireController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension QuestionnaireController {
    
    func handleRatingValue(_ value: Int) {
        
        self.ratingValue = value
    }
    
    func handleQuestionnaireAnswer(_ answer: String, cell: QuestionnaireCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let section = indexPath.section
        let row = indexPath.row
        
        questioinnaires[section].value[row].answer = answer
    }
    
}

extension QuestionnaireController {
    
    func handleSubmit(comments: String?) {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        guard let userId = UserDefaults.standard.getUserId() else { return }
        
        var questionnaireAnswers: [Hotel.QuestionnaireAnswer] = []
        
        
        for questionnaire in questioinnaires {
            
            for question in questionnaire.value {
                
                if let id = question.id {
                    let questioonnaireAnswer = Hotel.QuestionnaireAnswer(id: id, value: question.answer)
                    
                    questionnaireAnswers.append(questioonnaireAnswer)
                }
            }
        }
        
        let overallRating = Hotel.OverallRating(userId: userId, result: questionnaireAnswers, rating: ratingValue, comments: comments)
        let questionnairesAnswer = Hotel.QuestionnairesAnswer(QuestionnairesAnswer: overallRating)
        
        APIService.sharedInstance.handleSubmitQuestinnaire(questionnairesAnswer) { (result: Hotel.ResultRating) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                
                if let status = response.status, status {
                    DispatchQueue.main.async {
                        
                        self.showPMAlertOkayAction(title: "Success!".localized(), message: "Thank you for your feedback.".localized(), action: {
                            self.handleDismiss()
                        })
                    }
                } else {
                    self.showErrorMessage(title: "Fail", message: AlertMessages.somethingWentWrong.rawValue)
                }
                
            }
            
        }
    }
    
}

extension QuestionnaireController {
    
    func fetchQuestionnaires() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        let hotelId = UserDefaults.standard.getHotelId()
        let tempHotel = Hotel.HotelId(id: hotelId)
        let request = Hotel.RequestQuestionnaire(Questionnaire: tempHotel)
        
        APIService.sharedInstance.handleGetQuestinnaire(request) { (result: Hotel.ResultQuestionnaire) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let questionnaires = response.result {
                    self.setupQuestionnaires(questionnaires)
                }
            }
            
        }
        
    }
    
    func setupQuestionnaires(_ questionnaires: [Hotel.Questionnaire]) {
        
        for questionaire in questionnaires {
            
            let tempQuestions = questionaire.value
            var newQuestions:[Hotel.Question] = []
            for tempQuestion in tempQuestions{
                
                var category: String?
                var question: String?
                
                if currentLanguage() == DisplayName.england.rawValue {
                    category = tempQuestion.category
                    question = tempQuestion.question
                } else if currentLanguage() == DisplayName.france.rawValue {
                    category = tempQuestion.category_french
                    question = tempQuestion.question_french
                } else if currentLanguage() == DisplayName.germany.rawValue {
                    category = tempQuestion.category_german
                    question = tempQuestion.question_german
                } else if currentLanguage() == DisplayName.italy.rawValue {
                    category = tempQuestion.category_italian
                    question = tempQuestion.question_italian
                } else {
                    category = tempQuestion.category_russian
                    question = tempQuestion.question_russian
                }
                
                
                let newQuestion = Hotel.Question(id: tempQuestion.id, hotelid: tempQuestion.hotelid, category: category, category_greek: nil, question: question, question_greek: nil, created_date: tempQuestion.created_date, answer: nil, category_french: nil, question_french: nil, category_german: nil, question_german: nil, category_italian: nil, question_italian: nil, category_russian: nil, question_russian: nil)
                newQuestions.append(newQuestion)
            }
            
            var category: String?
            
            if newQuestions.count > 0 {
                category = newQuestions[0].category
            }
            
            let newQuestionnaire = Hotel.Questionnaire(category: category, category_greek: nil, value: newQuestions)
            
            self.questioinnaires.append(newQuestionnaire)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension QuestionnaireController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questioinnaires.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questioinnaires[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! QuestionnaireCell
        cell.questionnaireController = self
        let question = questioinnaires[indexPath.section].value[indexPath.row]
        cell.question = question
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let question = questioinnaires[indexPath.section].value[indexPath.row].question
        
        let estimatedSize = GlobalFunction.estimateFrameForText(text: question ?? "", width: view.frame.width - 140, font: CGFloat(19))
        
        let height = max(50, estimatedSize.height + 30)
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let categoryLabel = UILabel()
        categoryLabel.textColor = .white
        categoryLabel.backgroundColor = .lightGray
        categoryLabel.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        let category = questioinnaires[section].category
        categoryLabel.text = category
        
        return categoryLabel
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == questioinnaires.count - 1 {
            let ratingViewCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerId) as! QuestionnaireRatingCell
            ratingViewCell.questionnaireController = self
            return ratingViewCell
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == questioinnaires.count - 1 {
            return 270
        } else {
            return 0
        }
    }
    
}

extension QuestionnaireController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension QuestionnaireController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(QuestionnaireCell.self, forCellReuseIdentifier: cellId)
        tableView.register(QuestionnaireRatingCell.self, forHeaderFooterViewReuseIdentifier: footerId)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func setupNavBar() {
        
        let image = UIImage(named: AssetName.back.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
    }
}

