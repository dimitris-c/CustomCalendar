//
//  AvailabilityCalendarCell.swift
//  Carlito
//
//  Created by Dimitris C. on 30/11/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import JTAppleCalendar


enum AvailabilityType {
    case available
    case unavailable
    case booked
    
    static let allValues: [AvailabilityType] = [.available, .unavailable, .booked]
    static let toggleableValues: [AvailabilityType] = [.available, .unavailable]
    
    static var index: Int = toggleableValues.count
    
    static func toggle() -> AvailabilityType {
        index += 1
        if index >= toggleableValues.count {
            index = 0
        }
        return toggleableValues[index]
    }
    
    func next() -> AvailabilityType {
        if self == .available {
            return .unavailable
        } else if self == .unavailable {
            return .available
        }
        return .available
    }
}

class AvailabilityCalendarCell: JTAppleDayCellView, Reusable {
    
    final var state: AvailabilityType!
    final var dayLabel: UILabel!
    final var view: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.state = .available
        self.view = UIImageView(image: image(for: .available))
        self.addSubview(view)
        
        self.dayLabel = UILabel()
        self.dayLabel.textColor = UIColor.white
        self.dayLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(self.dayLabel)
        
    }
    
    required init!(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final func update(with state: AvailabilityType) {
        self.state = state
        self.view.image = image(for: state)
        self.view.setNeedsDisplay()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        let width  = self.bounds.width - insets.left - insets.right
        let height = self.bounds.height - insets.top - insets.bottom
        self.view?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.view?.center.x = self.center.x
        self.dayLabel.sizeToFit()
        self.dayLabel.center = self.center
    }
    
    func image(`for` state: AvailabilityType) -> UIImage? {
        switch state {
        case .available: return UIImage(named: "calendar-available-background")
        case .unavailable: return UIImage(named: "calendar-unavailable-background")
        case .booked: return UIImage(named: "calendar-booked-background")
        }
    }
    
}

