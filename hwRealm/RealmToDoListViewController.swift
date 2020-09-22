//
//  RealmToDoListViewController.swift
//  hwRealm
//
//  Created by Марина Селезнева on 21.09.2020.
//

import UIKit
import RealmSwift

class Tasks: Object {
    @objc dynamic var task: String = ""
}

class RealmToDoListViewController: UIViewController {

    let realm  = try! Realm()
    var items: Results<Tasks>!
    
    @IBOutlet weak var toDoListTableView: UITableView!
    
    @IBAction func addTaskButton(_ sender: Any) {
        let alert = UIAlertController(title: "Новая задача", message: "Введите новую задачу", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Новая задача"
        }
        
        let saveButton = UIAlertAction(title: "Сохранить", style: .default) { action in
            guard let text = alertTextField.text, !text.isEmpty else { return }
            let task = Tasks()
            task.task = text
            try! self.realm.write {
                self.realm.add(task)
            }
            
            self.toDoListTableView.insertRows(at: [IndexPath.init(row: self.items.count - 1, section: 0)], with: .automatic)
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(Tasks.self)
    }
    

}

extension RealmToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count != 0 {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTableView.dequeueReusableCell(withIdentifier: "realmCell") as! RealmToDoListTableViewCell
        let item = items[indexPath.row]
        cell.taskLabel.text = item.task
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteTask = items[indexPath.row]
        let deleteButton = UITableViewRowAction(style: .default, title: "Удалить") { _, _ in
            try! self.realm.write {
                self.realm.delete(deleteTask)
                self.toDoListTableView.reloadData()
            }
        }
        return [deleteButton]
    }
}
