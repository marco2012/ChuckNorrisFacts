//
//  ViewController.swift
//  ChuckNorris
//
//  Created by Marco on 03/09/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTextView: UITextView!
    let api = API()
    let button = UIButton.init(type: .custom)
    let progressHUD = ProgressHUD(text: "Loading")
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshBtn.layer.cornerRadius = 8
        
        setupButton()
        
        getJoke()
    }
    
    private func setupButton() {
        button.setImage(UIImage(named: "lang"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(ViewController.didPressButton), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    //This method will call when you press button.
    @objc func didPressButton() {
        let d = UserDefaults.standard
        let selected_language = d.string(forKey: "language") ?? "ITA"
        if selected_language == "ITA" {
            d.set("ENG", forKey: "language")
            refreshBtn.setTitle("Fact", for: .normal)
            //button.setImage(UIImage(named: "eng"), for: .normal)
            getJoke()
        } else if selected_language == "ENG" {
            d.set("ITA", forKey: "language")
            refreshBtn.setTitle("Fatto", for: .normal)
            //button.setImage(UIImage(named: "ita"), for: .normal)
            getJoke()
        }
        d.synchronize()
    }

    @IBAction func factButton(_ sender: UIButton) {
        getJoke()
    }
    
    private func getJoke() {
        myView.showBlurLoader()
        let selected_language = UserDefaults.standard.string(forKey: "language") ?? "ITA"
        if selected_language == "ITA" {
            api.getJokeITA(completionHandler: didLoadJoke)
        } else if selected_language == "ENG" {
            api.getJokeENG(completionHandler: didLoadJoke)
        }
    }
    private func didLoadJoke(joke:String){
        myTextView.text = joke
        myView.removeBluerLoader()
    }
    
}

extension UIView{
    func showBlurLoader(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        
        self.addSubview(blurEffectView)
    }
    
    func removeBluerLoader(){
        self.subviews.compactMap {  $0 as? UIVisualEffectView }.forEach {
            $0.removeFromSuperview()
        }
    }
}
