//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        navigationItem.hidesBackButton = true
        
        loadMessage()

        // tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ID.cellNibName, bundle: nil), forCellReuseIdentifier: ID.cellIdentifier)
        
    }
    
    //MARK:- Message Data Method
    func loadMessage() {
        db.collection(FStore.collectionName)
            .order(by: FStore.timeField)
            .addSnapshotListener { (querySnapshot, error) in
                
            if let e = error {
                print("Firestore read error: \(e)")
            } else {
                self.messages = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let senderRead = data[FStore.senderField] as? String, let bodyRead = data[FStore.bodyField] as? String {
                        let newMessage = Message(sender: senderRead, body: bodyRead)
                        self.messages.append(newMessage)
                        print("Read \(newMessage)")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            
                            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                            
                        }
                    }
                }
            }
        }
    }
    

    
    //MARK:- IBActions
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: ", signOutError)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(FStore.collectionName).addDocument(data: [
                FStore.senderField : messageSender,
                FStore.bodyField : messageBody,
                FStore.timeField : Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Firestore upload error: \(e)")
                } else {
                    print("Firestore upload successful")
                    self.messageTextfield.text = ""
                }
            }
        }
        
        
    }
    

}

//MARK:- UITableView
extension ChatViewController: UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ID.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel?.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.meImageView.isHidden = false
            cell.youImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: BrandColors.purple)
            cell.messageLabel.textAlignment = .right
        } else {
            cell.meImageView.isHidden = true
            cell.youImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: BrandColors.purple)
            cell.messageLabel.textColor = UIColor(named: BrandColors.lightPurple)
            cell.messageLabel.textAlignment = .left
        }
        
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
