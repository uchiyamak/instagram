//
//  LoginViewController.swift
//  Instagram
//
//  Created by 内山和也 on 2018/08/16.
//  Copyright © 2018年 kazuya.uchiyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    //ログインボタン
    @IBAction func handleLoginButton(_ sender: Any) {
        
    }
    
    //アカウント作成
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {    //ifなのに条件じゃない
            
            //どっちかが入力されてない時何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT:  何かが空文字です。")
                return
            }
            
            //アドレスとパスワードでユーザー作成。ユーザー作成に成功すると自動的にログイン
            Auth.auth().createUser(withEmail: address, password: password) { user, error in
                if let error = error {
                    //エラーがあったら原因をprintしてreturnすることで以降の処理を実行せず終了
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                //表示名を設定
                let user = Auth.auth().currentUser
                if let user = user {        //if文の使い方　userのletが２回目
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            //プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました。")
                        
                        //画面を閉じてViewControllerに戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
