//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Foundation
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    //hide navigation bar for this menu
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //turn nav bar back when leave this menu
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titleLabel.text = "⚡️FlashChat"
        titleLabel.text = K.appName
        
        
        /*
         old manual way to animate text
         
        titleLabel.text = ""
        let titleText = ["⚡️","F","l","a","s","h","C","h","a","t"]
        var charIndex = 1.0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (myTimer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1 //otherwise timers are all launched at same time, no time delay effect
            
        }
        */
        
        /*
         my kewl first try at timer delay
        var introAnimation = String()
        
        for letter in introText {
            introAnimation.append(letter)
            titleLabel.text = introAnimation
            //timer delay
            NSTimeIntervalSince1970
        }
        */
            
            
        
        
       
    }
    

}
