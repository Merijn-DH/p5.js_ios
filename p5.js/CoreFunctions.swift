
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
    static func saveData(toFile:String, data:String, forProject: String) {
        let documents:String =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        let directory = documents + "/" + forProject + "/"
        if !projectExists(forProject) {
            do {
                    try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: false, attributes: nil)
            } catch { print("error creating directory")}
        }
        do {
            try data.write(toFile: directory + toFile, atomically: false, encoding: .utf8)
        } catch { print("error saving file") }
    }
    
    // rename a project
    static func renameData(_ newName:String, forProject: String) {
        let documents:String =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        let directory = documents + "/" + forProject + "/"
        let newDirectory = documents + "/" + newName + "/"
        print(directory)
        print(newDirectory)
        do {
            try FileManager.default.moveItem(at: URL(fileURLWithPath: directory), to: URL(fileURLWithPath: newDirectory))
        } catch { print("error saving file") }
    }
    
    // fetch javascript or html from a project (forKey is "js" or "html")
    static func loadData(_ forFile:String, forProject:String) -> String {
        let documents:String =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        let filePath = documents + "/" + forProject + "/" + forFile
        do {
            let text = try String(contentsOfFile: filePath, encoding: .utf8)
            return(text);
        } catch { print("error loading file") }
        return ""
    }
    
    // check if a project exists
    static func projectExists(_ forProject:String) -> Bool {
        let projects = returnProjects()
        for i in 0 ..< projects.count {
            if projects[i] == forProject {
                return true
            }
        }
        return false
    }
    
    // get project names
    static func returnProjects() -> [String] {
        let documents:String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/"
        guard var paths : [String] = try? FileManager.default.contentsOfDirectory(atPath: documents) else { return []; }
        for i in (0 ..< paths.count).reversed()  {
            if paths[i].atIndex(0) == "." {
                paths.remove(at: i)
            }
        }
        return paths
    }
    
    static func deleteData(_ forProject:String) {
        let documents:String =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        let directory = documents + "/" + forProject + "/"
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: directory))
        } catch { print("error saving file") }
    }
}
