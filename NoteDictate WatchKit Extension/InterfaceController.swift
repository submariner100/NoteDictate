//
//  InterfaceController.swift
//  NoteDictate WatchKit Extension
//
//  Created by Macbook on 16/05/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    
     @IBOutlet var table: WKInterfaceTable!
     var notes = [String]()
     var savePath = InterfaceController.getDocumentsDirectory().appendingPathComponent("notes").path
     
     
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
     
        notes = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? [String] ?? [String]()
     
        table.setNumberOfRows(notes.count, withRowType: "Row")
     
        for rowIndex in 0 ..< notes.count {
          
               set(row: rowIndex, to: notes[rowIndex])
          
          
          }
     }
     
     func set(row rowIndex: Int, to text: String) {
     
     guard let row = table.rowController(at: rowIndex) as? NoteSelectRow else { return }
     row.textLabel.setText(text)
     
     }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
     @IBAction func addNewNote() {
     
          // 1. request user input
          presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { [unowned self]
          result in
          
          // 2. convert the returned item to a string if possible, otherwise bail out
          guard let result = result?.first as? String else { return }
          
          // 3. insert a new row
          self.table.insertRows(at: IndexSet(integer: self.notes.count), withRowType: "Row")
          
          // 4. give our new row the correct text
          self.set(row: self.notes.count, to: result)
          
          // 5. append the new note to our array
          self.notes.append(result)
          
          NSKeyedArchiver.archiveRootObject(self.notes, toFile: self.savePath)
          
          
       }
     }
     
     override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
          return ["index" : String(rowIndex + 1), "note" : notes[rowIndex]]
     }
     
     static func getDocumentsDirectory() -> URL {
          
          let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
          
          return paths[0]
          
          
     }

}
