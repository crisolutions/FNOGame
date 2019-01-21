//
//  ViewController.swift
//  FNOGame
//
//  Created by Zach Eriksen on 8/10/18.
//  Copyright © 2018 cri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var numberOfCards: Int {
        return shuffledData.count
    }
    var scoreText: String {
        return "Score: \(score)"
    }
    var data: [String] = []
    var shuffledData: [String] = []
    var isImage: Bool = true
    var score: Int = 0
    var selectedCards: (CardCollectionViewCell?, CardCollectionViewCell?) = (nil,nil)
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        scoreLabel.text = scoreText
        loadData()
    }
    
    fileprivate func loadData() {
        data = ["banana",
                "bb8",
                "medal",
                "barbra",
                "skunk",
                "table"].shuffled()
        shuffledData.append(contentsOf: data)
        shuffledData.append(contentsOf: data.reversed())
    }
    
    fileprivate func check(lhs: CardCollectionViewCell, rhs: CardCollectionViewCell) -> Bool {
        if let lhsImage = UIImage(named: lhs.answerText ?? ""),
            let rhsImage = rhs.answerImage {
            if lhsImage == rhsImage {
                return true
            }
        }
        if let rhsImage = UIImage(named: rhs.answerText ?? ""),
            let lhsImage = lhs.answerImage {
            if lhsImage == rhsImage {
                return true
            }
        }
        return false
    }
    
    fileprivate func shake(view: UIView) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        return animation
    }
    
    fileprivate func turnCardsOver() {
        collectionView.visibleCells
            .compactMap { $0 as? CardCollectionViewCell }
            .filter { !$0.isFaceDown }
            .forEach { $0.flip() }
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        shuffledData = []
        score = 0
        scoreLabel.text = scoreText
        loadData()
        collectionView.visibleCells
            .compactMap { $0 as? CardCollectionViewCell }
            .forEach { $0.placeDown() }
        turnCardsOver()
        collectionView.reloadData()
        selectedCards = (nil, nil)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else {
            return
        }
        guard let lhs = selectedCards.0 else {
            selectedCards.0 = cell
            cell.flip()
            return
        }
        if selectedCards.1 == nil {
            selectedCards.1 = cell
            cell.flip()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let rhs = self.selectedCards.1 {
                if self.check(lhs: lhs, rhs: rhs) {
                    lhs.isMatched = true
                    rhs.isMatched = true
                } else {
                    self.score += 1
                    self.scoreLabel.text = self.scoreText
                    lhs.layer.add(self.shake(view: lhs), forKey: "position")
                    rhs.layer.add(self.shake(view: rhs), forKey: "position")
                }
                self.turnCardsOver()
                self.selectedCards = (nil,nil)
                
            }
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfCards / 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.id, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        if isImage {
            cell.load(image: UIImage(named: shuffledData[indexPath.row]))
        } else {
            cell.load(text: shuffledData[indexPath.row])
        }
        isImage.toggle()
        return cell
    }
    
    
}
