//
//  AddTaskViewDelegate.swift
//  ToDoList_NewFeatures3
//
//  Created by Amanda Demetrio on 9/19/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import Foundation
import UIKit

protocol AddTaskViewDelegate {
    func sendDataToMainView(_ taskName: String, _ taskDesc: String, _ dueDate: Date)
}
