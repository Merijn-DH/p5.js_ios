
import Foundation
import UIKit
import CoreData
import Foundation

// core: all communications to the devices memory (eg. saving and loading projects)
// NOTE:
//  this could probably be simplified a lot by keeping a general array instead of re-reaching
//  for the memory in every function. Also, is using a struct the proper way?

struct core {
    
    // save a project's javascript and html
    static func saveData(_ js:String, html:String, forName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if projectExists(forName) {
            // update existing entry
            var storedItems = [NSManagedObject]()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
            do {
                let results = try context.fetch(fetchRequest)
                storedItems = results as! [NSManagedObject]
                for i in 0 ..< storedItems.count {
                    let item = storedItems[i]
                    if item.value(forKey: "name") as! String == forName {
                        item.setValue(js, forKey: "js")
                        item.setValue(html, forKey: "html")
                        do {
                            try context.save()
                        } catch {
                            NSLog("could not save")
                        }
                    }
                }
            } catch {
                NSLog("error loading")
            }
        } else {
            // create new entry
            let entity = NSEntityDescription.entity(forEntityName: "Project", in: context)
            let item = NSManagedObject(entity: entity!, insertInto: context)
            item.setValue(forName, forKey: "name")
            item.setValue(js, forKey: "js")
            item.setValue(html, forKey: "html")
            do {
                try context.save()
            } catch {
                NSLog("[error first record save]")
            }
            
        }
    }
    
    // rename a project
    static func renameData(_ newName:String, forName: String) {
            var storedItems = [NSManagedObject]()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
            do {
                let results = try context.fetch(fetchRequest)
                storedItems = results as! [NSManagedObject]
                for i in 0 ..< storedItems.count {
                    let item = storedItems[i]
                    if item.value(forKey: "name") as! String == forName {
                        item.setValue(newName, forKey: "name")
                        do {
                            try context.save()
                        } catch {
                            NSLog("could not save")
                        }
                    }
                }
            } catch {
                NSLog("error loading")
            }
    }
    
    // fetch javascript or html from a project (forKey is "js" or "html")
    static func loadData(_ forKey:String, forName:String) -> String {
        var storedItems = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        do {
            let results = try context.fetch(fetchRequest)
            storedItems = results as! [NSManagedObject]
            if storedItems.count == 0 {
                return "[no data]"
            }
            for i in 0 ..< storedItems.count {
                let item = storedItems[i]
                if item.value(forKey: "name") as! String == forName {
                    return item.value(forKey: forKey) as! String
                }
            }
            return "[no data]"
        } catch {
            NSLog("error loading")
            return ""
        }
    }
    
    // check if a project exists
    static func projectExists(_ forName:String) -> Bool {
        var storedItems = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        do {
            let results = try context.fetch(fetchRequest)
            storedItems = results as! [NSManagedObject]
            if storedItems.count == 0 {
                return false
            }
            for i in 0 ..< storedItems.count {
                let item = storedItems[i]
                if item.value(forKey: "name") as! String == forName {
                    return true
                }
            }
            return false
        } catch {
            NSLog("error loading")
            return false
        }
    }
    
    // get project names
    static func returnNames() -> [String] {
        var storedItems = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        do {
            let results = try context.fetch(fetchRequest)
            storedItems = results as! [NSManagedObject]
            if storedItems.count == 0 {
                return []
            }
            
            var types = [String]()
            for i in 0 ..< storedItems.count {
                let item = storedItems[i]
                types.append(item.value(forKey: "name") as! String)
            }
            return types
        } catch {
            NSLog("error loading")
            return []
        }
    }
    
    static func deleteData(_ name:String) {
        var storedItems = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        do {
            let results = try context.fetch(fetchRequest)
            storedItems = results as! [NSManagedObject]
            
            for i in 0 ..< storedItems.count {
                NSLog(String(i))
                let item = storedItems[i]
                if item.value(forKey: "name") as! String == name {
                    context.delete(storedItems[i])
                    try context.save()
                    break
                }
            }
        } catch {
            NSLog("error deleting")
        }
    }
}
