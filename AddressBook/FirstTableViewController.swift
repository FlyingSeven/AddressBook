//
//  FirstTableViewController.swift
//  AddressBook
//
//  Created by Seven on 11/24/15.
//  Copyright © 2015 Seven. All rights reserved.
//

import UIKit

class FirstTableViewController: UITableViewController {
    
    var contactsArr = CoreDataManger.sharedInstance.queryModel(nil)
    var keyArr = [String]()
    var allInfoDic = [String:[contactMo]]()
    
    func handleContacts(contacts: [contactMo]) {
        if contactsArr.count > 0 {
            keyArr.removeAll()
            allInfoDic.removeAll()
            for contact in contactsArr {
               let firstC = transformToPinyin(contact.name!, true)
                var everyArr = allInfoDic[firstC]
                if everyArr == nil {
                    everyArr = [contactMo]()
                    keyArr.append(firstC)
                    everyArr?.append(contact)
                    allInfoDic[firstC] = everyArr
                } else {
                    everyArr?.append(contact)
                    allInfoDic[firstC] = everyArr
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        handleContacts(contactsArr)
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func unwindToDetailVc(sender: UIStoryboardSegue) {
        if let _ = sender.sourceViewController as? DetailVc {
            contactsArr = CoreDataManger.sharedInstance.queryModel(nil)
            handleContacts(contactsArr)
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return keyArr.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = keyArr[section]
        let valueArr = allInfoDic[key]
        return (valueArr?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        if !allInfoDic.isEmpty {
            let key = keyArr[indexPath.section]
            let infoArr = allInfoDic[key]
            let sortArr = infoArr?.sort({ (s1, s2) -> Bool in
                return transformToPinyin(s1.name!, false) < transformToPinyin(s2.name!, false)
            })
            let m = sortArr![indexPath.row]
            cell.nameLab.text = m.name
            cell.phoneLab.text = m.phoneNum
            cell.AvatarImg.image = UIImage(data: m.avatarImg!)
        }

        // Configure the cell...

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let key = keyArr[indexPath.section]
            var userArr = allInfoDic[key]!
            let contact = userArr[indexPath.row]
            userArr.removeAtIndex(indexPath.row)
            if userArr.count > 0 {
                allInfoDic[key] = userArr
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }else {
                keyArr.removeAtIndex(indexPath.section)
                allInfoDic.removeValueForKey(key)
               let sectionSet = NSIndexSet(index: indexPath.section)
               tableView.deleteSections(sectionSet, withRowAnimation: .Fade)
            }
            CoreDataManger.sharedInstance.deleteModelByName(contact.name!)
            contactsArr = CoreDataManger.sharedInstance.queryModel(nil)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
     override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        keyArr.sortInPlace()
        return keyArr[section]
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "update" {
            let detailVc = segue.destinationViewController as! DetailVc
            if allInfoDic.count > 0 {
                if sender!.isKindOfClass(CustomTableViewCell) {
                    let index = tableView.indexPathForCell(sender as! CustomTableViewCell)
                    let key = keyArr[(index?.section)!]
                    let contact = allInfoDic[key]![(index?.row)!]
                    detailVc.contact = contact
                }
            }
        }
    }
    
    func transformToPinyin(vari: String, _ isOne: Bool) -> String {
        let mutableString = NSMutableString(string: vari)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        if !isOne {
            return mutableString as String
        } else {
            return mutableString.substringToIndex(1)
        }
    }
}
