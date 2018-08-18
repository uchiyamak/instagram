//
//  ViewController.swift
//  Instagram
//
//  Created by 内山和也 on 2018/08/12.
//  Copyright © 2018年 kazuya.uchiyama. All rights reserved.
//

import Firebase
import FirebaseAuth     //赤い横線はなんで？
import UIKit
import ESTabBarController

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //vurrentUserが nillならログインしてない
        if Auth.auth().currentUser == nil {
            //ログインしてない時の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")   // add viewcontroller by ID
            self.present(loginViewController!, animated: true, completion: nil) // show modal
        }
    }
    
    func setupTab() {
        //画像のファイルを指定してESTabBarControllerを作成
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        //背景色、選択時の色を設定
        tabBarController.selectedColor = UIColor(red:1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(displayP3Red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        tabBarController.selectionIndicatorHeight = 3
        
        //作成したESTabBarControllerを親のViewControllerに追加する
        addChildViewController(tabBarController)        //didmoveとセット
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false    //なに？
        view.addSubview(tabBarView) //subviewとは
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor), //最後の,いる？
            ])
        tabBarController.didMove(toParentViewController: self)
        
        //タブをタップした時に表示するviewcontrollerを設定する
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(settingViewController, at: 2)
        
        //真ん中のタブはボタンとして扱う
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            //ボタンが押されたらImageViewControllerをモーダルで表示
            let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewController!, animated:true, completion: nil)
            }, at: 1)
        
    }
    


}











