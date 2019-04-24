//
//  ViewController.swift
//  Todoy
//
//  Created by IOS User1 on 03/04/19.
//  Copyright © 2019 IOS User1. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    //userDefaults is basically to store small amount of data like storing setting of app, mobile num etc
    //userDefaults is a plist file which loads every time when app launches(it reduces app Performance if we have more data in it) so to avoid that we use database Coredata(framework) ,sqlite
    //userDefaults can store only standard type(String ,Double,Array etc) so to avoid that we created a brand new plist file called items.plist
    //creating our own plist file to store our custom type data, "appendingPathComponent()" method  is used to create our own plist file
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadItems()
    }


    //MARK:- *** TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        //Ternary Operator
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        return cell
        
    }
    //MARK:- *** TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].done)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        tableView.reloadData()
        //to get blink selection on tableview cell
        tableView.deselectRow(at: indexPath, animated: true)

    }
    //MARK:- *** Addbutton item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           // print("add item button pressed")
            print(textField.text!)
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            //saves the items
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        present(alert , animated: true ,completion: nil)
    }
    //MARK:- ModelManipulationMethod
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }catch{
            
        }
    }
    func loadItems() {
        
        let decoder = PropertyListDecoder()
        
        do {
            let data = try Data.init(contentsOf: dataFilePath!)
            self.itemArray = try decoder.decode([Item].self, from: data)
            
        }catch{
            
        }
    }

}


