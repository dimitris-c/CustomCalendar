//
//  ViewController.swift
//  CustomCalendar
//
//  Created by Dimitris C. on 07/02/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView()
        if let tableView = tableView {
            tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
            
            self.view.addSubview(tableView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = self.view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = "Calendar"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // wrong way of detecting a cell but this is for demo purposes
        if indexPath.row == 0 {
            // Go to calendar view controller
            let calendar = AvailabilityCalendar()
            let navigationController = UINavigationController(rootViewController: calendar)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
}

