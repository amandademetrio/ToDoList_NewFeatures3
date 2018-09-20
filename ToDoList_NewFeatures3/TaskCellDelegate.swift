//
//  TaskCellDelegate.swift
//  ToDoList_NewFeatures3
//
//  Created by Amanda Demetrio on 9/20/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import Foundation
import UIKit

protocol TaskCellDelegate {
    //letting the main view know the heart button was pressed
    func sendHeartClickToMainView(_ indexPath: IndexPath)
}
