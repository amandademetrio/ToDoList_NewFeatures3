//
//  MainTableViewController.swift
//  ToDoList_NewFeatures3
//
//  Created by Amanda Demetrio on 9/19/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class MainTableViewController: UITableViewController {
    
    let sections: [String] = ["To-Do","Completed"]
    
    var tableData: [String:[Task]] = [:]
    
    //Stagging area for stuff to be added to Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.setImage(UIImage(named: "empty"), for: UISearchBarIcon.clear, state: UIControlState.normal)
        tableView.dataSource = self
        tableView.delegate = self
        tableData = fetchAllItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskSegue" {
            let addTaskController = segue.destination as! AddTaskViewController
            addTaskController.delegate = self as AddTaskViewDelegate
            if let indexPath = sender as? IndexPath {
                let key = sections[indexPath.section]
                let task = tableData[key]![indexPath.row]
                addTaskController.taskName = task.title
                addTaskController.taskDesc = task.desc
                addTaskController.dueDate = task.dueDate
                addTaskController.indexPath = indexPath
            }
        }
        else if segue.identifier == "openDetailSegue" {
            let taskDetailController = segue.destination as! TaskDetailViewController
            taskDetailController.delegate = self as? TaskDetailViewDelegate
            if let indexPath = sender as? IndexPath {
                let key = sections[indexPath.section]
                let task = tableData[key]![indexPath.row]
                taskDetailController.taskTitle = task.title
                taskDetailController.taskDesc = task.desc
                taskDetailController.taskDate = task.dueDate
                taskDetailController.isDone = task.isCompleted
                taskDetailController.indexPath = indexPath
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sections[section]
        return tableData[key]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let key = sections[indexPath.section]
        let task = tableData[key]![indexPath.row]
        cell.tasktitleLabel!.text = "\(String(describing: task.title!))"
        cell.descLabel!.text = "\(String(describing: task.desc!))"
        cell.indexPath = indexPath
        //Formatting and assigning date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateToFormat = dateFormatter.string(from: task.dueDate!)
        cell.dueDateLabel!.text = "\(String(describing: dateToFormat))"
        
        if task.isCompleted == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        if task.isLoved == true {
            let image = UIImage(named: "full_heart")
            cell.heartButton.setImage(image, for: .normal)
        }
        else {
            let image = UIImage(named: "empty_heart")
            cell.heartButton.setImage(image, for: .normal)
        }
                
        cell.delegate = self as TaskCellDelegate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let key = sections[indexPath.section]
        let task = tableData[key]![indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, done) in
            self.context.delete(task)
            self.saveContext()
            self.tableData[key]?.remove(at: indexPath.row)
            tableView.reloadData()
            done(true)
        }
        delete.image = UIImage(named: "delete")
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, done) in
            self.performSegue(withIdentifier: "AddTaskSegue", sender: indexPath)
        }
        edit.image = UIImage(named: "edit")
        edit.backgroundColor = UIColor.blue
        
        var actions:[UIContextualAction] = []
        
        if task.isCompleted == true {
            actions = [delete]
        }
        else {
            actions = [delete,edit]
        }
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let key = sections[indexPath.section]
        let task = tableData[key]![indexPath.row]
        
        let markAsComplete = UIContextualAction(style: .normal, title: "Done") { (action, view, done) in
            task.isCompleted = true
            self.tableData = self.fetchAllItems()
            tableView.reloadData()
        }
        
        markAsComplete.backgroundColor = UIColor.green
        markAsComplete.image = UIImage(named: "checkmark")
        
        var actions:[UIContextualAction] = []
        
        if task.isCompleted == true {
            actions = []
        }
        else {
            actions = [markAsComplete]
        }
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openDetailSegue", sender: indexPath)
    }
    
    func fetchAllItems() -> [String:[Task]] {
        var data: [String:[Task]] = [
            "To-Do":[],
            "Completed":[]
        ]
        let taskRequest: NSFetchRequest = Task.fetchRequest()
        do {
            let results = try context.fetch(taskRequest)
            for task in results {
                if task.isCompleted == true {
                    data["Completed"]?.append(task)
                }
                else {
                    data["To-Do"]?.append(task)
                }
            }
        }
        catch {
            print("Errors are \(error)")
        }
        //array 1
        data["Completed"] = data["Completed"]?.sorted(by: {
            $0.dueDate?.compare($1.dueDate!) == .orderedDescending
        })
        //array 2
        data["To-Do"]  = data["To-Do"]?.sorted(by: {
            $0.dueDate?.compare($1.dueDate!) == .orderedDescending
        })
        return data
    }
}

extension MainTableViewController: AddTaskViewDelegate {
    func sendDataToMainView(_ taskName: String, _ taskDesc: String, _ dueDate: Date, _ indexPath: IndexPath?) {
        let task: Task
        if let indexPath = indexPath {
            let key = sections[indexPath.section]
            task = tableData[key]![indexPath.row]
        } else {
            task = Task(context: context)
            task.isCompleted = false
            task.isLoved = false
            tableData["To-Do"]?.append(task)
        }
        task.title = taskName
        task.desc = taskDesc
        task.dueDate = dueDate
        tableView.reloadData()
        saveContext()
        dismiss(animated: true, completion: nil)
    }
}

extension MainTableViewController: TaskDetailViewDelegate {
    func changeTaskStatus(_ indexPath: IndexPath, _ switchUI: UISwitch) {
        let key = sections[indexPath.section]
        let task = tableData[key]![indexPath.row]
        task.isCompleted = switchUI.isOn
        saveContext()
        self.tableData = self.fetchAllItems()
        tableView.reloadData()
    }
}

extension MainTableViewController: TaskCellDelegate {
    func sendHeartClickToMainView(_ indexPath: IndexPath) {
        let key = sections[indexPath.section]
        let task = tableData[key]![indexPath.row]
        
        if task.isLoved == true {
            task.isLoved = false
        }
        else if task.isLoved == false {
            task.isLoved = true
        }
        saveContext()
        self.tableData = self.fetchAllItems()
        tableView.reloadData()
    }
}

extension MainTableViewController: UISearchDisplayDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            tableData = [
                "To-Do":[],
                "Completed":[]
            ]
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            fetchRequest.predicate = predicate
            do {
                let results = try context.fetch(fetchRequest) as Array
                
                for task in results {
                    if (task as AnyObject).isCompleted == true {
                        tableData["Completed"]?.append(task as! Task)
                    }
                    else {
                        tableData["To-Do"]?.append(task as! Task)
                    }
                }
                tableView.reloadData()
            }
            catch {
                print("Could not get search data")
            }
        }
        else {
            self.tableData = self.fetchAllItems()
            tableView.reloadData()
            self.view.endEditing(true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
}
