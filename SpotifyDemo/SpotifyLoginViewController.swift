//
//  SpotifyLoginViewController.swift
//  SpotifySDKDemo
//
//  Created by Chen, Rena on 7/10/17.
//

import UIKit
import PromiseKit
import SafariServices

class SpotifyLoginViewController: UIViewController {
    
    let segueIdentifier = "SpotifyLoginToPlaylist"
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SpotifyLoginViewController.updateAfterLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBActions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        SpotifyManager.shared.login()
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        SpotifyManager.shared.loginClient().then { something -> Void in
            self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
            }.catch { err in
                print(err)
        }
    }
    
    func updateAfterLogin(notification: NSNotification) {
        SpotifyManager.shared.updateAfterFirstLogin()
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
