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
    var coverImage: UIImage
    var price: String
    var description: String!
    
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var bookShelf = [Book]()
    var listOfBooks : NSMutableArray = []
   
    //func to populate the book shelf with books from the BookServerAPI
    func bookModel()  {
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(NSURL(string: "http://tpbookserver.herokuapp.com/books")!, completionHandler: { (data: NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            if let unwrappedError = error {
                print("error=\(unwrappedError)")
            }
            else{
                if var _ = data{
                    do {
                        self.listOfBooks = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSMutableArray
                        for book in self.listOfBooks{
                            
                            let session2 = NSURLSession.sharedSession()
                            let individualBookTask = session2.dataTaskWithURL(NSURL(string: "http://tpbookserver.herokuapp.com/book/"+String(book["id"]!!))!, completionHandler: { (dataAPI: NSData?, response:NSURLResponse?, error: NSError?) -> Void in
                                if var _ = dataAPI{
                                    do {
                                        let JSON = try NSJSONSerialization.JSONObjectWithData(dataAPI!, options: [])
                                        
                                        //format book price
                                        let format = NSNumberFormatter()
                                        format.currencyCode = book["currencyCode"] as! String
                                        format.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                                        let amount = format.stringFromNumber((book["price"] as! Double)/100)
                                       
                                        //get the book cover image from the bookCovers API
                                        var image: UIImage!
                                        if let url = NSURL(string: "http://covers.openlibrary.org/b/isbn/" + (book["isbn"] as! String) + "-L.jpg") {
                                            if let data = NSData(contentsOfURL: url){
                                                image = UIImage(data: data)!
                                                if image != nil{
                                                    image = image!
                                                }
                                            }
                                        }
                                        //parse the description string from the JSON
                                        let blur = JSON["description"]!
                                        var description:String = ""
                                        if blur != nil{
                                            description = String(blur!)
                                        }
                                        //add a new book to the bookShelf using API information
                                        dispatch_async(dispatch_get_main_queue(), {
                                            print("reloading table")
                                            self.tableView.reloadData()
                                        
                                        self.insertNewObject(Book(author: book["author"] as! String,
                                                title: book["title"] as! String,
                                                id: String(book["id"]!!),
                                                isbn:book["isbn"] as! String,
                                                currencyCode:book["currencyCode"] as! String,
                                                coverImage:image,
                                                price:amount!,
                                                description:description)
                                            )
                        
                                        print("finished round")
                                      })
                                    } catch {
                                        print(error)
                                    }
                                }
                        })
                        individualBookTask.resume()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        })
        dataTask.resume()
     
    } // end of bookModel
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //on startup
    override func viewDidLoad() {
        tableView.reloadData()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        bookModel()
    }
    
    func insertNewObject(sender: Book) {
        bookShelf.insert(sender, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        // self.tableView.reloadData()
      
    }
    
    //change controller, view
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelf.count
    }
    
    //insert new book into tableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let label = UILabel(frame: CGRect(x:20, y:50, width:200, height:25))
        self.tableView.separatorStyle = .None  //remove seperator lines in table
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.subviews.last?.removeFromSuperview()
        let object = bookShelf[indexPath.row]
        label.text = object.author
        label.font = UIFont(name: "GillSans-Italic", size: 10)
        cell.addSubview(label)
        cell.textLabel!.text = object.title
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            bookShelf.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

