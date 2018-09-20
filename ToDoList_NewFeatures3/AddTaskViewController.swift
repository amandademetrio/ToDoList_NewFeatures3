//
//  AddTaskViewController.swift
//  ToDoList_NewFeatures3
//
//  Created by Amanda Demetrio on 9/19/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    var delegate: AddTaskViewDelegate?
    
    var taskName: String?
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    var taskDesc: String?
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    var dueDate: Date?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateSelected(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dueDate = sender.date
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        taskName = taskTitleTextField.text
        taskDesc = taskDescriptionTextField.text
        delegate?.sendDataToMainView(taskName!, taskDesc!, dueDate!)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
