//
//  GeneralNumbersCell.swift
//  HotelCrete
//
//  Created by John Nik on 28/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SpreadsheetView

let MATRIX_NUMBERS_WIDTH = DEVICE_WIDTH - 20
let MATRIX_NUMBERS_COLUMN_WIDTH1 = MATRIX_WIDTH / 2  - 30
let MATRIX_NUMBERS_COLUMN_WIDTH2 = MATRIX_WIDTH / 2  + 15

let MATRIX_NUMBERS_ROW_HEIGHT: CGFloat = 40
let MATRIX_NUMBERS_COLUMN_WIDTH = MATRIX_WIDTH / 2 - 2

class GeneralNumbersCell: BaseTableViewCell {
    
    let cellId = "cellId"
    
    var usefulNumbers: UsefulNumbers.UsefulNumbers? {
        
        didSet {
            
            guard let usefulNumbers = usefulNumbers else { return }
            self.setupUsefulNumbers(usefulNumbers)
        }
    }
    
    var numberRecords: [[String]] = []
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
        
    }()
    
    lazy var spreadSheetView: SpreadsheetView = {
        
        let view = SpreadsheetView()
        view.delegate = self
        view.dataSource = self
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .darkGray
        textView.isUserInteractionEnabled = false
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        return textView
    }()
    
    var rightLineView = UIView()
    var bottomLineView = UIView()
    
    var descriptionTextViewHeightAnchor: NSLayoutConstraint?
    
    override func setupViews() {
        super.setupViews()
        
        selectionStyle = .none
        
        spreadSheetView.register(SpreadSheetCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        
        addSubview(descriptionTextView)
        descriptionTextView.anchor(top: nil, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        descriptionTextViewHeightAnchor = descriptionTextView.heightAnchor.constraint(equalToConstant: 40)
        descriptionTextViewHeightAnchor?.isActive = true
        
        addSubview(spreadSheetView)
        spreadSheetView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: descriptionTextView.topAnchor, right: titleLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.numberRecords.removeAll()
        rightLineView.isHidden = true
        bottomLineView.isHidden = true
    }
    
}


extension GeneralNumbersCell: SpreadsheetViewDelegate, SpreadsheetViewDataSource {
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        
        return numberRecords.count
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        if numberRecords.count > 0 {
            return numberRecords[0].count
        }
        return 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SpreadSheetCell
        
        let word = numberRecords[indexPath.row][indexPath.column]
        cell.word = word
        
        return cell
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return MATRIX_NUMBERS_COLUMN_WIDTH
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        
        let words = numberRecords[row]
        
        if var maxWord = words.max(by: {$1.count > $0.count}) {
            var fontSize: CGFloat = 15
            if GlobalFunction.isContainedString("</", of: maxWord) {
                maxWord = maxWord.htmlToString
                fontSize = 20
            }
            
            let estimateHeight = GlobalFunction.estimateFrameForText(text: maxWord, width: MATRIX_NUMBERS_COLUMN_WIDTH, font: fontSize).height + 20
            
            let height = max(MATRIX_ROW_HEIGHT, estimateHeight)
            return height
        }
        
        return MATRIX_ROW_HEIGHT
    }
    
}

extension GeneralNumbersCell {
    
    func setupUsefulNumbers(_ usefulNumbers: UsefulNumbers.UsefulNumbers) {
        
        titleLabel.text = usefulNumbers.UsefulNumber?.title
        
        if let description = usefulNumbers.UsefulNumber?.description, description.count > 0 {
            descriptionTextView.text = description.htmlToString
            
            let estimatedHeight = GlobalFunction.estimateFrameForText(text: description.htmlToString, width: MATRIX_WIDTH, font: CGFloat(15)).height
            
            self.descriptionTextViewHeightAnchor?.constant = estimatedHeight + 40
        } else {
            self.descriptionTextViewHeightAnchor?.constant = 0
        }
        
        if let usefulNumbersData = usefulNumbers.UsefulData {
            
            for numberDetail in usefulNumbersData {
                
                if let title = numberDetail.title, let number = numberDetail.number {
                    let record = [title, number]
                    self.numberRecords.append(record)
                }
            }
            
        }
        
        self.spreadSheetView.reloadData()
        
    }
    
}

