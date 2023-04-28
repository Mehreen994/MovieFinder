//
//  MovieTableViewCell.swift
//  MovieFinder
//
//  Created by Mehreen Kanwal on 25.01.23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieYearLabel: UILabel!
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var cellContainerView : UIView!
    @IBOutlet var readMoreLabel : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
        
    static let identifier = "MovieTableViewCell"

    static var nib = UINib(nibName: "MovieTableViewCell",
                     bundle: nil)
    
    func configure(with model: Movie) {
        self.movieTitleLabel.text = model.title
        self.movieYearLabel.text = model.year
        let url = model.Poster
        if let data = try? Data(contentsOf: URL(string: url)!) {
            self.moviePosterImageView.image = UIImage(data: data)
            self.cellContainerView.layer.cornerRadius = 20.0
            self.cellContainerView.clipsToBounds = true
            self.moviePosterImageView.layer.cornerRadius = 20.0
            self.moviePosterImageView.clipsToBounds = true
           
        }
    }
}
