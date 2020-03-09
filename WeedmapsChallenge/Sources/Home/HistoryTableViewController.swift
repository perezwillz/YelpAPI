//
//  SearchTableViewController.swift
//  WeedmapsChallenge
//
//  Created by Perez Willie-Nwobu on 3/7/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let historySelected = Notification.Name("History Selected")
}

class HistoryTableViewController: UITableViewController {
    
    var history: [String] = [] {
        didSet {
            loadViewIfNeeded()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = history[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(Notification(name: .historySelected, object: history[indexPath.row]))
        dismiss(animated: true)
    }
}

