//
//  CheckDateView.swift
//  HotelCrete
//
//  Created by John Nik on 17/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

protocol CheckDateViewDelegate {
    func handleDate(_ date: String, sender: CheckDateView)
}

class CheckDateView: UIView {
    
    var delegate: CheckDateViewDelegate?
    
    var registerControler: RegisterController?
    
    var dateLabelTitle: String? {
        
        didSet {
            guard let title = dateLabelTitle else { return }
            self.dateLabel.text = title
        }
    }
    
    lazy var datePicker: GMDatePicker = {
        let datePicker = GMDatePicker()
        
        datePicker.delegate = self
        datePicker.config.startDate = Date()
        datePicker.config.animationDuration = 0.5
        datePicker.config.cancelButtonTitle = "Cancel"
        datePicker.config.confirmButtonTitle = "Confirm"
        datePicker.config.contentBackgroundColor = .lightGray
        datePicker.config.headerBackgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        datePicker.config.confirmButtonColor = UIColor.white
        datePicker.config.cancelButtonColor = UIColor.white
        return datePicker
    }()
    
    
    lazy var dateButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.calendar.rawValue)
        button.setImage(image, for: .normal)
        button.tintColor = StyleGuideManager.mainLightBlueBackgroundColor
        button.addTarget(self, action: #selector(handleDatePicker), for: .touchUpInside)
        return button
    }()
    
    lazy var dateLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Check-in date"
        label.textAlignment = .center
        label.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CheckDateView {
    @objc fileprivate func handleDatePicker() {
        
        endEditing(true)
        guard let registerController = registerControler else { return }
        datePicker.show(inVC: registerController)
    }
}

extension CheckDateView: GMDatePickerDelegate {
    func gmDatePicker(_ gmDatePicker: GMDatePicker, didSelect date: Date){
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        print(dateFormatter.string(from: date))
        
        dateLabel.text = dateFormatter.string(from: date)
        delegate?.handleDate(dateFormatter.string(from: date), sender: self)
    }
    func gmDatePickerDidCancelSelection(_ gmDatePicker: GMDatePicker) {
        
    }
}

extension CheckDateView {
    
    fileprivate func setupViews() {
        
        setupButton()
        setupLabel()
    }
    
    private func setupLabel() {
        
        addSubview(dateLabel)
        
        dateLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: dateButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupButton() {
        
        addSubview(dateButton)
        dateButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        dateButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
