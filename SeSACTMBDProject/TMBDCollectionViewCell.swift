//
//  TMBDCollectionViewCell.swift
//  SeSACTMBDProject
//
//  Created by 박종환 on 2022/08/04.
//

import UIKit

class TMBDCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var rateDescriptLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var iconimageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    func configCell() {
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.contentMode = .scaleAspectFill
        
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 6
        cardView.layer.masksToBounds = false
        
        dateLabel.font = .systemFont(ofSize: 12)
        
        genreLabel.font = .boldSystemFont(ofSize: 16)
        
        rateDescriptLabel.font = .systemFont(ofSize: 12)
        rateDescriptLabel.text = " 평점 "
        rateDescriptLabel.textColor = .white
        rateDescriptLabel.backgroundColor = .blue
        
        rateLabel.backgroundColor = .white
        rateLabel.font = .systemFont(ofSize: 12)
        rateLabel.textAlignment = .center
        
        titleLabel.font = .systemFont(ofSize: 20)
        
        actorsLabel.font = .systemFont(ofSize: 13)
        
        detailLabel.text = "자세히 보기"
        detailLabel.font = .systemFont(ofSize: 12)
        
        iconimageView.image = UIImage(systemName: "chevron.right")
        iconimageView.tintColor = .gray
        
        lineView.backgroundColor = .systemGray4
    }
    
}
