//
//  TaskCell.swift
//  ToDoList_NewFeatures3
//
//  Created by Amanda Demetrio on 9/19/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    var delegate: TaskCellDelegate?
    
    var indexPath: IndexPath? //could be (), try if there's error
    
    @IBOutlet weak var tasktitleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    @IBAction func heartButtonPressed(_ sender: UIButton) {
        delegate?.sendHeartClickToMainView(indexPath!)
    }
}
