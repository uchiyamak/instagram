//
//  PostData.swift
//  Instagram
//
//  Created by 内山和也 on 2018/08/21.
//  Copyright © 2018年 kazuya.uchiyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []    //配列？サイズは指定しなくて良い？２次元配列の場合は？
    var isLiked: Bool = false
    var comments: [String] = []

    
    init(snapshot: DataSnapshot, myId: String) {    //関数？インスタンス化するときに１度だけ呼び出される
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        self.imageString = valueDictionary["image"] as? String   //!と?の違いがいまいちわからない
        image = UIImage(data: Data(base64Encoded: self.imageString!, options: .ignoreUnknownCharacters)!)    //ここで画像に戻している？
        
        self.name = valueDictionary["name"] as? String      //imageStringはselfいらなかったのになんで？本当は必要
        
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionary["likes"] as? [String] {  //なぜこれだけラップしてるのか
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        if let comments = valueDictionary["comments"] as? [String] {        //追加
            self.comments = comments
        }

    }
}
