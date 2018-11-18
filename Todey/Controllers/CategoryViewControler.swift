//
//  CategoryViewControlerTableViewController.swift
//  Todey
//
//  Created by Avilash on 16/10/18.
//  Copyright © 2018 Avilash. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewControlerTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      loadCategories ()
    }
    
    //MARK: - TableView DataSource Methods.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        // ?? = Nil Coalesing Operator.
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet."
        
        return cell
        
    }
    
    //MARK: - Table View Delegate Methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods.
    
    func saveCategories(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error Saving Category \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadCategories () {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - Add New Categories.
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField ()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add A New Category"
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}
