//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit


class BusinessCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
