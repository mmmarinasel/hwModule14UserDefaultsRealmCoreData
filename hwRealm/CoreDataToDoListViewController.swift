//
//  CoreDataToDoListViewController.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import UIKit
import CoreData

class CoreDataToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoListTableView2: UITableView!
    var items2: [TaskList] = []
    @IBAction func addTaskButton2(_ sender: Any) {
        let alert = UIAlertController(title: "Новая задача", message: "Введите новую задачу", preferredStyle: .alert)
        var taskAlertTextField: UITextField!
        alert.addTextField { textField in
            taskAlertTextField = textField
            textField.placeholder = "Введите задачу"
        }
        let saveButton = UIAlertAction(title: "Сохранить", style: .default) { action in
            guard let text = taskAlertTextField.text, !text.isEmpty else { return }
            self.saveTask(title: text)
            self.toDoListTableView2.insertRows(at: [IndexPath.init(row: self.items2.count - 1, section: 0)], with: .automatic)
            self.toDoListTableView2.reloadData()
            
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    func saveTask(title: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "TaskList", in: context) else { return }
        let taskObject = TaskList(entity: entity, insertInto: context)
        taskObject.task2 = title
        do {
            try context.save()
            items2.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        do {
            items2 = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
}

extension CoreDataToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items2.count != 0 {
            return items2.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTableView2.dequeueReusableCell(withIdentifier: "coreDataCell") as! CoreDataToDoListTableViewCell
        let task = items2[indexPath.row]
        cell.taskLabel2.text = task.task2
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteTask = items2[indexPath.row]
        let deleteButton = UITableViewRowAction(style: .default, title: "Удалить") { _, _ in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
            context.delete(deleteTask)
            self.items2.remove(at: indexPath.row)
            
            do { try context.save() }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            self.toDoListTableView2.reloadData()
        }
            return [deleteButton]
    }
}
