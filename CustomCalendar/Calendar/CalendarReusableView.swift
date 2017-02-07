//
//  CalendarReusableView.swift
//  CustomCalendar
//
//  Created by Dimitris C. on 07/02/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarReusableView: UICollectionViewCell, Reusable, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    var calendar: JTAppleCalendarView!
    var model: AvailabilityData!
    
    let dayActiveColor = UIColor.white
    let dayInactiveColor = UIColor.lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
        
        self.isUserInteractionEnabled = true
        
        self.calendar = JTAppleCalendarView()
        self.calendar.allowsMultipleSelection = true
        self.calendar.cellInset = CGPoint(x: 2, y: 2)
        self.calendar.registerCellViewClass(type: AvailabilityCalendarCell.self)
        self.calendar.registerHeaderView(classTypeNames: [AvailabilityCalendarHeader.self])
        
        self.addSubview(self.calendar)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.width - 8
        let height = self.frame.height - 8
        self.calendar.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        self.calendar.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: self.frame.width - 8, height: 70)
    }
    
    // maybe not the most effiecient way of create a header cell!
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        let headerCell = (header as? AvailabilityCalendarHeader)
        
        let month = Calendar.autoupdatingCurrent.dateComponents([.month], from: range.start).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        
        let year = Calendar.autoupdatingCurrent.component(.year, from: range.start)
        headerCell?.title?.text = monthName + " " + String(year)
        
        headerCell?.layoutIfNeeded()
        let days = DateFormatter().shortWeekdaySymbols ?? []
        
        headerCell?.buildWeekdays(for: days, with: calendar.cellInset)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let availabilityCell = cell as! AvailabilityCalendarCell
        
        // Setup Cell text
        availabilityCell.dayLabel.text = cellState.text
        availabilityCell.setNeedsLayout()
        
        configure(cell: availabilityCell, for: date, with: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleDayCellView, cellState: CellState) -> Bool {
        let adjusted = self.model.boundaries.minimumDate
        return date >= adjusted && cellState.dateBelongsTo == .thisMonth
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let availabilityCell = cell as! AvailabilityCalendarCell
        
        let availabilityState = availabilityCell.state.next()
        availabilityCell.update(with: availabilityState)
        configure(cell: availabilityCell, for: date, with: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let availabilityCell = cell as! AvailabilityCalendarCell
        
        let availabilityState = availabilityCell.state.next()
        availabilityCell.update(with: availabilityState)
        configure(cell: availabilityCell, for: date, with: cellState)
    }
    
    func configure(cell: AvailabilityCalendarCell, for date: Date, with cellState: CellState) {
        
        let adjusted = self.model.boundaries.minimumDate
        let dateIsGreaterOrEqual = date >= adjusted
        if cellState.dateBelongsTo == .thisMonth {
            cell.dayLabel.isHidden = false
            if !dateIsGreaterOrEqual {
                cell.dayLabel.textColor = dayInactiveColor
            } else {
                cell.dayLabel.textColor = dayActiveColor
            }
            cell.view.isHidden = !dateIsGreaterOrEqual
        } else {
            cell.dayLabel.isHidden = true
            cell.view.isHidden = true
            cell.dayLabel.textColor = dayActiveColor
        }
    }
    
    func update(with model: AvailabilityData) {
        self.model = model
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.reloadData()
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let startDate = self.model.boundaries.minimumDate
        let endDate = self.model.boundaries.maximumDate
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.autoupdatingCurrent,
                                                 generateInDates: .forFirstMonthOnly,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: false)
        
        return parameters
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.calendar.delegate = nil
        self.calendar.dataSource = nil
    }
}

class AvailabilityCalendarHeader: JTAppleHeaderView {
    var title: UILabel!
    var divider: UIView!
    
    var labels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.title = UILabel(frame: CGRect.zero)
        self.title?.font = UIFont.systemFont(ofSize: 15)
        self.title?.textColor = UIColor.black
        if let title = self.title {
            self.addSubview(title)
        }
        
        self.divider = UIView()
        self.divider?.backgroundColor = UIColor(red:0.84, green:0.84, blue:0.85, alpha:1.00)
        if let divider = self.divider {
            self.addSubview(divider)
        }
        
    }
    
    fileprivate func buildWeekdays(`for` names: [String], with offset: CGPoint) {
        
        for name in names {
            let origin = CGPoint.zero
            let size = CGSize(width: self.frame.width / 7, height: 0)
            let label = UILabel(frame: CGRect(origin: origin, size: size))
            label.text = name
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.gray
            label.textAlignment = .center
            self.addSubview(label)
            
            label.sizeToFit()
            label.frame.size.width = self.frame.width / 7
            
            self.labels.append(label)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.title?.sizeToFit()
        
        self.divider?.frame.size.width = self.frame.width - 20
        self.divider?.frame.size.height = 1
        self.divider?.center = self.center
        
        self.title?.frame.origin.y = (self.divider.frame.minY - self.title.frame.height) * 0.5
        self.title?.center.x = self.center.x
        
        for (index,label) in labels.enumerated() {
            label.sizeToFit()
            label.frame.size.width = self.frame.width / 7
            label.frame.origin.x = CGFloat(index) * label.frame.width
            label.frame.origin.y = self.divider.frame.maxY + ((self.frame.height - self.divider.frame.maxY) - label.frame.height) * 0.5
        }
    }
}
