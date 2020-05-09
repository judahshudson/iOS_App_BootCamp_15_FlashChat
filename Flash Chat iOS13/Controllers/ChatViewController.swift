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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var logOut: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "⚡️FlashChat"
        title = K.appName
        navigationItem.hidesBackButton = true
        
        //register our table view to use  Views / xib design file (MessageCell.xib)
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        tableView.dataSource = self
        
        loadMessages()
    }
    
    //retreive messages from Firestore, dispaly in tableView
    func loadMessages() {
        //messages = []
                                                
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)  //sort by time
            .addSnapshotListener { (querrySnapshot, error) in   //listen for new messages
            
            self.messages = []  //empty out old messages
            
            if let e = error {
                print("there was an issue retrieving data from Firestore \(e)")
            } else {
                if let snapshotDocuments = querrySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            //load messages despite delay internet connection (missed in viewDidLoad() )
                            //fetch main thread in foreground
                            DispatchQueue.main.async {
                                //update messages to tableView
                                self.tableView.reloadData()
                                //scroll to bottom of messages (see latest message)
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //send sent message to firebase firestore (database)
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                //add time stamp to messages -> sort by order sent
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("there was an issue saving data to Firestore, \(e)")
                } else {
                    print("successfully saved data")
                    //click send -> clear old message from text field (ready for type new message)
                    DispatchQueue.main.async {  //tap into main thread, not stuck in background (closures tend to be background)
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        //log out
        do {
            //log out successful
            try Auth.auth().signOut()
            print("logged out")
            //go to WelcomeViewController
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
        
        /*
        my first way to go back to home screen
        //go to WelcomeViewController
        performSegue(withIdentifier: "LogOut", sender: self)
        */
    }

}

//protocol responsible for populating the TableView
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
            as! MessageCell //cast reusable cell as a MessageCell class
        //cell.label.text = messages[indexPath.row].body
        cell.label.text = message.body
        
        //this is a message from current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        //message from another sender
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        
        return cell
    }
}


