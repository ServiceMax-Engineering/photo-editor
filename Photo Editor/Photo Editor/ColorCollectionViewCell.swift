//
//  ColorCollectionViewCell.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 5/1/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    var isCellSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.layer.cornerRadius = colorView.frame.width / 2
        colorView.clipsToBounds = true
        if isCellSelected {
            colorView.layer.borderWidth = 3.0
        }else{
            colorView.layer.borderWidth = 1.0
        }
        colorView.layer.borderColor = UIColor.white.cgColor
    }
}
