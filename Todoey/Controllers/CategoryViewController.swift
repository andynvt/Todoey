//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ANDY on 2/17/19.
//  Copyright © 2019 ANDY. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
//import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>?
    
    //Core data
//    var categories = [Category]()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()
        tableView.rowHeight = 80
    }
    
    //MARK: - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No catagories added yet"
        
//        cell.delegate = self
        
        return cell
    }
    
    
    //MARK: - Table View Delagate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    //Core data
//    func saveCatagories() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error when saving category: \(error)")
//        }
//        tableView.reloadData()
//
//    }
    
    
    //Realm
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving catagory: \(error)")
        }
    }
    
    //Core data
//    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
//
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error when fetching data from context: \(error)")
//        }
//        tableView.reloadData()
//
//    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)
        
        tableView.reloadData()

    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }

        }
    }
    
    
    //MARK: - Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //Coredata
//            let newCategory = Category(context: self.context)
//            newCategory.name = textField.text!
//
//            self.categories.append(newCategory)
//            self.saveCatagories()
            
            //Realm
            let newCategory = Category()
            newCategory.name = textField.text!

            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
         
        }
        present(alert, animated: true, completion: nil)
        
    }
    
}
