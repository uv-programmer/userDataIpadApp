//
//  ListViewController.swift
//  UserDataApp
//
//  Created by Ajay on 23/02/22.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    @IBOutlet weak var userListTblView: UITableView!
    
    var userDataArray = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        // Do any additional setup after loading the view.
    }
    

    
    
    
    
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Usersdata")
        
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
//        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
//
        do {
            let result = try managedContext.fetch(fetchRequest)
            userDataArray = result as! [NSManagedObject]
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "firstname") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    
    
    
    
    
    
    

}

extension ListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (userListTblView.dequeueReusableCell(withIdentifier: "UserDataTableViewCell", for: indexPath) as? UserDataTableViewCell)!
        let data = userDataArray[indexPath.row]
        cell.nameLbl.text = (data.value(forKey: "firstname") as! String)
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let data = userDataArray[indexPath.row]
        web.mobileNumber = (data.value(forKey: "mobilenumber") as! String)
        
        self.navigationController?.pushViewController(web, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    
    
    
    
}
