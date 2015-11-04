//
//  DetailViewController.swift
//  Book
//
//  Created by Niamh Lawlor on 30/10/2015.
//  Copyright © 2015 Niamh Lawlor. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var isbnLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookDescription: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
  //  @IBOutlet weak var bookDescriptionLabel: UILabel!
    
    var detailItem: Book? {
        didSet { //update view when items in bookshelf changed
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the ui
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.author
              //  label.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 20)
                label.adjustsFontSizeToFitWidth = true
            }
            if let label = self.priceLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = detail.price
            }
            if let label = self.isbnLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = "ISBN: "+detail.isbn
             //   label.font = UIFont(name: "AvenirNext-Regular", size: 20)
            }
            if let label = self.bookTitleLabel {
                label.text = detail.title
                label.adjustsFontSizeToFitWidth = true
            }
            if let label = self.bookDescription {
                label.text = detail.description
                label.adjustsFontSizeToFitWidth = true
            }
            if let _ = self.imageView {
                if let url = NSURL(string: detail.imageUrl) {
                    if let data = NSData(contentsOfURL: url){
                        imageView.contentMode = UIViewContentMode.ScaleAspectFit
                        imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

}

