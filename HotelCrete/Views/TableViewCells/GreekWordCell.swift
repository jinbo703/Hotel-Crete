//
//  GreekWordCell.swift
//  HotelCrete
//
//  Created by John Nik on 27/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SpreadsheetView

let MATRIX_WIDTH = DEVICE_WIDTH - 20
let MATRIX_COLUMN_WIDTH1 = MATRIX_WIDTH / 3  - 30
let MATRIX_COLUMN_WIDTH2 = MATRIX_WIDTH / 3  + 15

let MATRIX_ROW_HEIGHT: CGFloat = 40
let MATRIX_COLUMN_WIDTH = MATRIX_WIDTH / 3 - 2

class SpreadSheetCell: Cell {
    
    var word: String? {
        
        didSet {
            guard let word = word else { return }
            
            if GlobalFunction.isContainedString("</", of: word) {
                titleLabel.attributedText = word.trimmingCharacters(in: .whitespacesAndNewlines).htmlToAttributedString?.trailingNewlineChopped
            } else {
                titleLabel.text = word.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            
        }
    }
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 10
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GreekWordCell: BaseTableViewCell {
    
    let cellId = "cellId"
    
    var greekWordList: GreekWord.GreekWordList? {
        
        didSet {
            guard let greekWordList = greekWordList else { return }
            
            setupGreekWordList(greekWordList)
        }
        
    }
    
    var greekWords: [[String]] = []
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        return label
        
    }()
    
    lazy var spreadSheetView: SpreadsheetView = {
        
        let view = SpreadsheetView()
        view.delegate = self
        view.dataSource = self
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var rightLineView = UIView()
    var bottomLineView = UIView()
    
    override func setupViews() {
        super.setupViews()
        
        selectionStyle = .none
        
        spreadSheetView.register(SpreadSheetCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        addSubview(spreadSheetView)
        spreadSheetView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        rightLineView.backgroundColor = .lightGray
        
        addSubview(rightLineView)
        rightLineView.anchor(top: spreadSheetView.topAnchor, left: nil, bottom: spreadSheetView.bottomAnchor, right: spreadSheetView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 1, height: 0)
        
        
        bottomLineView.backgroundColor = .lightGray
        
        addSubview(bottomLineView)
        bottomLineView.anchor(top: spreadSheetView.bottomAnchor, left: spreadSheetView.leftAnchor, bottom: nil, right: spreadSheetView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        rightLineView.isHidden = true
        bottomLineView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.greekWords.removeAll()
        rightLineView.isHidden = true
        bottomLineView.isHidden = true
    }
    
}

extension GreekWordCell: SpreadsheetViewDelegate, SpreadsheetViewDataSource {
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        
        return greekWords.count
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        if greekWords.count > 0 {
            return greekWords[0].count
        }
        return 3
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SpreadSheetCell
        
        let greekWord = greekWords[indexPath.row][indexPath.column]
        cell.word = greekWord
        
        return cell
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return MATRIX_COLUMN_WIDTH
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        
        let words = greekWords[row]
        
        if var maxWord = words.max(by: {$1.count > $0.count}) {
            var fontSize: CGFloat = 15
            if GlobalFunction.isContainedString("</", of: maxWord) {
                maxWord = maxWord.htmlToString.trailingNewLinesTrimmed
                fontSize = 16
            }
            
            let estimateHeight = GlobalFunction.estimateFrameForText(text: maxWord, width: MATRIX_COLUMN_WIDTH, font: fontSize).height + 20
            
            let height = max(MATRIX_ROW_HEIGHT, estimateHeight)
            
            return height
        }
        
        return MATRIX_ROW_HEIGHT
    }
    
}

extension GreekWordCell {
    
    func setupGreekWordList(_ greekWordList: GreekWord.GreekWordList) {
        
        titleLabel.text = greekWordList.GreekWord.title
        
        
        if greekWordList.GreekDescription.count > 0 {
            let headRecord = ["English", "Greek", "Pronounciation"]
            self.greekWords.append(headRecord)
            
//            rightLineView.isHidden = false
//            bottomLineView.isHidden = false
        } else {
//            rightLineView.isHidden = true
        }
        
        for greekWordDesciption in greekWordList.GreekDescription {
            
            let record = [greekWordDesciption.english, greekWordDesciption.greek, greekWordDesciption.pronunciation]
            self.greekWords.append(record)
        }
        
        self.spreadSheetView.reloadData()
        
    }
    
}
