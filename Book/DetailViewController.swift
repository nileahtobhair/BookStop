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
    
    var detailItem: Bookk? {
        didSet {
            // Update the view.
            print("setting label in detail view")
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.author
                print("in detail view - detail item is \(self.detailItem)")
                
            }
            if let label = self.priceLabel {
                label.text = "Price     :  "+String(detail.price/100) + "      (" + detail.currencyCode + ")"
                print(detail.price)
            }
            if let label = self.isbnLabel {
                label.text = "ISBN: "+detail.isbn
            }
            if let label = self.currencyLabel {
                label.text = detail.currencyCode
            }
            if let label = self.bookTitleLabel {
                label.adjustsFontSizeToFitWidth = true
                label.text = detail.title
                print("setting title \(detail.title)")
                
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
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

