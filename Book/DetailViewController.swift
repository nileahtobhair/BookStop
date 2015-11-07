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
                label.adjustsFontSizeToFitWidth = true
            }
            if let label = self.priceLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = detail.price
            }
            if let label = self.isbnLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = "ISBN: "+detail.isbn
            }
            if let label = self.bookTitleLabel {
                label.text = detail.title
                label.adjustsFontSizeToFitWidth = true
            }
            if let label = self.bookDescription {
                    label.adjustsFontSizeToFitWidth = true
                    label.text = detail.description
                    label.textAlignment = NSTextAlignment.Justified 
            }
            if let cover = self.imageView {
                cover.contentMode = UIViewContentMode.ScaleAspectFit
                cover.image = detail.coverImage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
}

