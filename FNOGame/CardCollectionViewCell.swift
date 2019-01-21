//
//  CardCollectionViewCell.swift
//  FNOGame
//
//  Created by Zach Eriksen on 8/10/18.
//  Copyright © 2018 cri. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    private let duration = 0.35
    static public let id = "cardID"
    var isFaceDown: Bool = true {
        didSet {
            UIView.transition(with: self, duration: duration, options: oldValue ? .transitionFlipFromRight : .transitionFlipFromLeft, animations: nil, completion: nil)
            
        }
    }
    var isMatched: Bool = false
    var answerText: String?
    var answerImage: UIImage?
    var handleCompletion: (() -> ())?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func load(image: UIImage? = nil, text: String? = nil) {
        layer.cornerRadius = 8
        answerImage = image
        answerText = text
        backgroundColor = .white
    }
    
    func placeDown() {
        isFaceDown = true
        imageView.isHidden = true
        label.isHidden = true
        isMatched = false
    }
    
    @discardableResult
    func flip() -> Bool {
        if !isMatched {
            if isFaceDown {
                if let text = answerText {
                    label.text = text
                    imageView.isHidden = true
                    label.isHidden = false
                } else if let image = answerImage {
                    imageView.image = image
                    imageView.isHidden = false
                    label.isHidden = true
                }
                isFaceDown = false
            } else {
                isFaceDown = true
                imageView.isHidden = true
                label.isHidden = true
            }
            return isFaceDown
        } else {
            alpha = 0.5
            return isMatched
        }
    }
}
