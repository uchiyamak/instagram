//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 内山和也 on 2018/08/21.
//  Copyright © 2018年 kazuya.uchiyama. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        self.postImageView.image = postData.image   //イメージビューに引数のイメージを渡す
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        //コメントラベルを追加        //２回呼び出されている。
        let comments = postData.comments
        //print("コメント数確認" + String(comments.count))       //String(describing: type(of: text))
        //print("コメント型確認" + String(describing: type(of: comments)))       //String(describing: type(of: text))
        var showComment: String = ""
        for comment in comments {
            showComment = showComment + "\(comment)\n"
        }
        self.commentTextView.text = showComment
        //print("コメントラベル確認用" + self.commentTextView.text!)

    }
}
