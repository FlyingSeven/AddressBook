//
//  DetailVc.swift
//  AddressBook
//
//  Created by Seven on 11/24/15.
//  Copyright © 2015 Seven. All rights reserved.
//

import UIKit

class DetailVc: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var contact: contactMo?
    
// MARK: properties
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
// MARK: Actions
    
    @IBAction func showAvatar(sender: UITapGestureRecognizer) {
    }
    
    @IBAction func changeAvatar(sender: UIButton) {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .PhotoLibrary
        imgPicker.delegate = self
        presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func cancle(sender: UIBarButtonItem) {
        if (presentingViewController is UINavigationController) {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
// MARK: UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        avatarImgView.image = selectImg
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// MARK: UITextfied delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveBtn.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidInfo()
        navigationItem.title = nameTF.text
    }
    
    func checkValidInfo() {
        let text1 = nameTF.text ?? ""
        let text2 = phoneTF.text ?? ""
        let text3 = genderTF.text ?? ""
        saveBtn.enabled = !(text1.isEmpty || text2.isEmpty || text3.isEmpty)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkValidInfo()
        avatarImgView.layer.borderWidth = 0.7
        avatarImgView.layer.borderColor = UIColor(red: 0.3, green: 0.9, blue: 0.4, alpha: 0.7).CGColor
        if let newContact = contact {
            nameTF.text = newContact.name
            phoneTF.text = newContact.phoneNum
            genderTF.text = newContact.gender
            avatarImgView.image = UIImage(data: newContact.avatarImg!)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameTF.resignFirstResponder()
        phoneTF.resignFirstResponder()
        genderTF.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveBtn === sender {
            if contact == nil {
                CoreDataManger.sharedInstance.addModelToCoreData((nameTF.text!, phoneTF.text!, UIImagePNGRepresentation(avatarImgView.image!)!, genderTF.text!))
            }else {
                let name = contact?.name
                contact?.name = nameTF.text!
                contact?.phoneNum = phoneTF.text!
                contact?.avatarImg = UIImagePNGRepresentation(avatarImgView.image!)!
                contact?.gender = genderTF.text
                CoreDataManger.sharedInstance.updateModel(name!, contact: contact!)
            }
            contact = CoreDataManger.sharedInstance.queryModel(nameTF.text!).first
        }
    }
}
