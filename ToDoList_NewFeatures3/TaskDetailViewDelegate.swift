//
//  TaskDetailViewDelegate.swift
//  ToDoList_NewFeatures3
//
//  Created by Amanda Demetrio on 9/20/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import Foundation
import UIKit

protocol TaskDetailViewDelegate {
    func changeTaskStatus(_ indexPath: IndexPath, _ switchUI: UISwitch)
}
