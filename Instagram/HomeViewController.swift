//
//  HomeViewController.swift
//  Instagram
//
//  Created by 内山和也 on 2018/08/16.
//  Copyright © 2018年 kazuya.uchiyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    //DatabaseのobserveEbentの登録状態を表す
    var observing = false           //登録状態って何？
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        //テーブルの高さをAutoLayoutで調整
        tableView.rowHeight = UITableViewAutomaticDimension
        //テーブル業の高さの概算値
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100     //heightじゃなくてwidth?正方形だから？
    }
    
    override func viewWillAppear(_ animated: Bool) {        //animatedってなんだっけ？
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                //要素が追加されたらpostarrayに追加してtableviewを表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    //postdataクラスを生成して受け取ったデータを設定
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)      //snapshot, uidはどこからきている？
                        self.postArray.insert(postData, at: 0)
                        
                        //tableviewを再表示
                        self.tableView.reloadData()
                    }
                })
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        //postDataクラスを生成して受け取ったデータを設定
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        //保持している配列からidが同じものを探す  これなんで？
                        var index: Int = 0
                        for post in self.postArray {    //postarrayはどこにある？
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!  //indexは配列？
                                break
                            }
                        }
                        
                        print("確認用：" + String(self.postArray.count))
                        //差し替えるために一度削除
                        self.postArray.remove(at: index)        //最初の立ち上げでホームに戻るとここでエラーになる
                        
                        //削除したところに更新すみのデータを追加
                        self.postArray.insert(postData, at: index)
                        
                        //tableViewを再表示
                        self.tableView.reloadData()
                    }
                    
                })
                
                //DatabaseのobserveEventが上記コードにより登録されたため、trueに
                observing = true
            }
        } else {
            if observing == true {
                //ログアウトを検出したら一旦テーブルをクリアしてオブザーバーを削除
                //テーブルをクリア
                postArray = []
                tableView.reloadData()
                //オブザーバーを削除
                Database.database().reference().removeAllObservers()
                
                //databaseのobserveEbentが上記コードにより解除されたのでfalse
                observing = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    //セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました")
        
        //タップされた時のインデックスを求める
        let touch = event.allTouches?.first     //これは何？
        let point = touch!.location(in: self.tableView)     //整数が入る？
        let indexPath = tableView.indexPathForRow(at: point)    //これは？配列？
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if postData.isLiked {
                //すでにいいねを押していた場合は解除
                var index = -1      //-1は仮？
                for likeId in postData.likes {
                    if likeId == uid {
                        //解除するためにインデックスを保存
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                postData.likes.append(uid)
            }
            
            //増えたlikesをFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
        }
        
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
