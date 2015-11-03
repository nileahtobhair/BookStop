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
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var detailItem: Book? {
        didSet { //update view when items in bookshelf changed
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the ui
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.adjustsFontSizeToFitWidth = true
                label.sizeToFit()
                label.text = detail.author
                label.font = UIFont(name: "Georgia", size: 20)
                label.minimumScaleFactor = 0.5
            }
            if let label = self.priceLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = "Price     :  "+String(detail.price/100) + "      (" + detail.currencyCode + ")"
                label.sizeToFit()
                label.minimumScaleFactor = 0.5
            }
            if let label = self.isbnLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = "ISBN: "+detail.isbn
                label.minimumScaleFactor = 0.5
            }
            if let label = self.currencyLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = detail.currencyCode
            }
            if let label = self.bookTitleLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = detail.title
                label.numberOfLines = 0
                label.sizeToFit()
                
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

