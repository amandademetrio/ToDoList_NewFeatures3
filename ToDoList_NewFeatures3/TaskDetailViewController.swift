//
//  TaskDetailViewController.swift
//  ToDoList_NewFeatures3
//
//  Created by Amanda Demetrio on 9/20/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    var delegate: TaskDetailViewDelegate?
    
    var taskTitle: String?
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    var taskDesc: String?
    @IBOutlet weak var taskDescLabel: UILabel!
    
    var taskDate: Date?
    @IBOutlet weak var taskDateLabel: UILabel!
    
    var isDone: Bool?
    @IBOutlet weak var isDoneSwitch: UISwitch!
    
    var indexPath: IndexPath?
    
    @IBAction func isDoneSwitched(_ sender: UISwitch) {
        delegate?.changeTaskStatus(indexPath!, sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitleLabel.text = taskTitle
        taskDescLabel.text = taskDesc
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateToFormat = dateFormatter.string(from: taskDate!)
        taskDateLabel.text = "\(String(describing: dateToFormat))"
        
        if isDone == true {
            isDoneSwitch.setOn(true, animated: true)
        }
        else {
            isDoneSwitch.setOn(false, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
