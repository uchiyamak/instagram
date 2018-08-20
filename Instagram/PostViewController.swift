//
//  PostViewController.swift
//  Instagram
//
//  Created by 内山和也 on 2018/08/16.
//  Copyright © 2018年 kazuya.uchiyama. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD        //便利なライブラリって、どうやって知ればいい？ググったらだいたいわかる？

class PostViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    //投稿ボタンをタップした時に呼ばれる
    @IBAction func handlePostButton(_ sender: Any) {
        //ImageViewから画像を取得する
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)    //0.5は何？　＝クオリティ。ライブラリを入れないと、固定値はできない。
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)      //イメージをStringに変換？バイナリデータにしている。バイナリデータ。人間が読めないデータはバイナリデータ。テキストだけどバイナリデータ。
        
        //postDataに必要な情報を取得しておく
        let time = Date.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        //辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath)     //これは何？　保存先を指定している。
        let postDic = ["caption": textField.text!, "image": imageString, "time": String(time), "name": name!]   //timeはstringに変換する必要ある？timeは扱いがめんどくさい。
        postRef.childByAutoId().setValue(postDic)
        
        //HUDで投稿完了を表示
        SVProgressHUD.showSuccess(withStatus: "投稿しました。")
        
        //全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    //キャンセルボタンをタップした時に呼ばれる
    @IBAction func handleCancelButton(_ sender: Any) {
        //画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //受け取った画像をImageViewに設定する
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
