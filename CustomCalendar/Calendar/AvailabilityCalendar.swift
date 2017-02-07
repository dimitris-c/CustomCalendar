//
//  AvailabilityCalendar.swift
//  Carlito
//
//  Created by Dimitris C. on 11/01/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import SwiftDate

struct CalendarBoundaries {
    let minimumDate: Date
    let maximumDate: Date
    
    static let now: CalendarBoundaries = CalendarBoundaries(minimumDate: Date(), maximumDate: Date())
}

struct AvailabilityData {
    private(set) var boundaries: CalendarBoundaries = CalendarBoundaries.now
    
    init(minimumDate: Date, maximumDate: Date) {
        self.boundaries = CalendarBoundaries(minimumDate: minimumDate, maximumDate: maximumDate)
    }
    
    init(boundaries: CalendarBoundaries) {
        self.boundaries = boundaries
    }
}

struct AvailabilitySection {
    let cell: String
    let data: AvailabilityData
}

final class AvailabilityCalendar: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    final var collectionView: UICollectionView!
    
    final fileprivate let totalMonthsDisplayed: Int = 12
    
    final fileprivate var sections: [AvailabilitySection] = []
    final fileprivate var flowLayout: UICollectionViewFlowLayout!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        self.collectionView.scrollsToTop = true
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.lightGray
        
        self.view.addSubview(self.collectionView)
        
        // Initialize our custom model for each cell
        let boundaries = self.setupCalendarBoundaries()
        
        self.sections = []
        for boundary in boundaries {
            let data: AvailabilityData = AvailabilityData(boundaries: boundary)
            let section = AvailabilitySection(cell: CalendarReusableView.identifier, data: data)
            sections.append(section)
        }
        
    }
    
    func setupCalendarBoundaries() -> [CalendarBoundaries] {
        var boundaries: [CalendarBoundaries] = []
        
        let now = Date().startOfDay
        let currentMonthEnd = Calendar.autoupdatingCurrent.endOfMonth(for: now)!
        let boundary: CalendarBoundaries = CalendarBoundaries(minimumDate: now, maximumDate: currentMonthEnd)
        boundaries.append(boundary)
        
        let startOfNextMonth = currentMonthEnd + 1.day
        var previousDate: Date = startOfNextMonth.startOfDay
        for _ in 0..<totalMonthsDisplayed {
            let endOfMonth = Calendar.autoupdatingCurrent.endOfMonth(for: previousDate)!
            let boundary = CalendarBoundaries(minimumDate: previousDate, maximumDate: endOfMonth)
            boundaries.append(boundary)
            let aMonthForward = Calendar.autoupdatingCurrent.date(byAdding: .month, value: 1, to: endOfMonth)!
            previousDate = Calendar.autoupdatingCurrent.startOfMonth(for: aMonthForward)!.startOfDay
        }
        
        return boundaries
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calendar"
    
        self.collectionView?.register(CalendarReusableView.self,
                                      forCellWithReuseIdentifier: CalendarReusableView.identifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 10, right: 0)
        self.flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 10, right: 18)
        
        self.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let collectionView = collectionView {
            collectionView.frame = CGRect(origin: .zero, size: self.view.bounds.size)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.row]
        let identifier = section.cell
        let calendarView = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CalendarReusableView
        calendarView.update(with: section.data)
        return calendarView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 18, height: 345)
    }
    
}

