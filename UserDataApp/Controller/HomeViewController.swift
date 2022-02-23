//
//  ViewController.swift
//  UserDataApp
//
//  Created by Ajay on 23/02/22.
//

import UIKit
import SwiftSignatureView
import PDFKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var firstNameTxtfield: UITextField!
    @IBOutlet weak var lastNameTxtfield: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var phoneNumberTxtfield: UITextField!
    @IBOutlet weak var signatureView: SwiftSignatureView!
    
    
    @IBOutlet weak var signImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dobTextField.datePicker(target: self,
                                  doneAction: #selector(doneAction),
                                  cancelAction: #selector(cancelAction),
                                  datePickerMode: .date)
        // Do any additional setup after loading the view.
    }
    
    
    func createData(){
        let firstName = firstNameTxtfield.text ?? ""
        let lastName = lastNameTxtfield.text ?? ""
        let dob = dobTextField.text ?? ""
        let phoneNumber = phoneNumberTxtfield.text ?? ""
            
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Now let’s create an entity and new user records.
            let userEntity = NSEntityDescription.entity(forEntityName: "Usersdata", in: managedContext)!
            
            //final, we need to add some data to our newly created record for each keys using
                            
                let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
                user.setValue(firstName, forKeyPath: "firstname")
                user.setValue(lastName, forKey: "lastname")
                user.setValue(phoneNumber, forKey: "mobilenumber")
                user.setValue(dob, forKey: "dob")
         

            //Now we have set all the values. The next step is to save them inside the Core Data
            
            do {
                try managedContext.save()
                signImage.image = signatureView.signature
                // create the alert
                    let alert = UIAlertController(title: "UserApp", message: "Data saved successfully.", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    
    
    
    
    @IBAction func submitAction(_ sender: Any) {
        createData()
        createPDF()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func createPDF() {
        let firstName = firstNameTxtfield.text ?? ""
        let LastName = lastNameTxtfield.text ?? ""
        let dob = dobTextField.text ?? ""
        let phoneNumber = phoneNumberTxtfield.text ?? ""
        var logoString = ""
        
        
        
        let data = signatureView.signature!.pngData() //be careful! If the image is a Jpeg you have to use UIImageJPEGRepresentation. Use the corresponding method to the image type.

              if let pngRepA = signatureView.signature!.pngData() {

                  let strBase64 = pngRepA.base64EncodedString(options: [])

                   logoString = "data:image/png;base64, \(strBase64)"


              

          }
     
        let image = signatureView.signature! // Your Image
        let imageData = image.pngData() ?? nil
                let base64String = imageData?.base64EncodedString() ?? "" // Your String Image
         
        let html = "<b>I hereby declare that following datas are correct in my knowledge <br> </b> <p>First Name : \(firstName)Last Name: \(LastName)<br> Date of Birth: \(dob) <br> Phone: \(phoneNumber)<br> Image: <img src=\"\(signatureView.signature!)\" style=\"width:100%; max-width:300px; background-color: #003300\">"
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Assign print formatter to UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect

        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

        // 4. Create PDF context and draw

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        // 5. Save PDF file

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        pdfData.write(toFile: "\(documentsPath)/\(phoneNumber).pdf", atomically: true)
    }
    
    
    
    
    
    
    
    @objc
    func cancelAction() {
        self.dobTextField.resignFirstResponder()
    }

    @objc
    func doneAction() {
        if let datePickerView = self.dobTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.dobTextField.text = dateString
            
            self.dobTextField.resignFirstResponder()
        }
    
    


}
}

extension UITextField {
  
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
 
}
