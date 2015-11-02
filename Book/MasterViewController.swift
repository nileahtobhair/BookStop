//
//  MasterViewController.swift
//  BookStop
//
//  Created by Niamh Lawlor on 30/10/2015.
//  Copyright © 2015 Niamh Lawlor. All rights reserved.
//

import UIKit

struct Book{
    var author:String
    var title:String
    var id:String
    var isbn: String
    var currencyCode: String
    var imageUrl: String
    var price: Double
    var description: String
    
}


class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var bookShelf = [Book]()
    
    var url = NSURL(string: "http://private-anon-6e95240a2-tpbookserver.apiary-mock.com/books")
    
    var listOfBooks : NSMutableArray = []
   
    func bookModel()  {
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(NSURL(string: "http://private-anon-6e95240a2-tpbookserver.apiary-mock.com/books")!, completionHandler: { (data: NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            if let unwrappedError = error {
                print("error=\(unwrappedError)")
            }
            else{
                if var _ = data{
                    do {
                        self.listOfBooks = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSMutableArray
                        for book in self.listOfBooks{
                            self.insertNewObject(Book(author: book["author"] as! String,
                                title: book["title"] as! String,
                                id: String(book["id"]!!),
                                isbn:book["isbn"] as! String,
                                currencyCode:book["currencyCode"] as! String,
                                imageUrl:"http://covers.openlibrary.org/b/isbn/" + (book["isbn"] as! String) + "-L.jpg",
                                price:book["price"] as! Double,
                                description:"")
                            )
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        })
        dataTask.resume()
    } // end of api call function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        bookModel()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("in viewWillAppear")
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        print("didReceiveMemoryWarning")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: Book) {
        bookShelf.insert(sender, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = bookShelf[indexPath.row] //was date
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelf.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.separatorStyle = .None  //remove lines in table
    
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = bookShelf[indexPath.row]
        cell.textLabel!.text = object.title
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        let label = UILabel(frame: CGRect(x:20, y:50, width:200, height:25))
       // let label = UILabel()
        label.text = object.author
        label.font = UIFont(name: "GillSans-Italic", size: 10)
        cell.addSubview(label)
        cell.imageView?.frame = CGRectMake( 0, 0, 50, 55 );
        cell.sizeToFit()
      
        return cell
    }
}

