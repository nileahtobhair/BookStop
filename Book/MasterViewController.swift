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
                           // print(String(book["id"]!!))
                            
                            let session2 = NSURLSession.sharedSession()
                            let dataTask2 = session2.dataTaskWithURL(NSURL(string: "http://tpbookserver.herokuapp.com/book/"+String(book["id"]!!))!, completionHandler: { (dataAPI: NSData?, response:NSURLResponse?, error: NSError?) -> Void in
                            if let unwrappedError = error {
                                print("error=\(unwrappedError)")
                            }
                            else{
                                if var _ = dataAPI{
                                    do {
                                        let JSON = try NSJSONSerialization.JSONObjectWithData(dataAPI!, options: [])
                                        //format book price
                                        //print(JSON)
                                        let format = NSNumberFormatter()
                                        format.currencyCode = book["currencyCode"] as! String
                                        format.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                                        let amount = format.stringFromNumber((book["price"] as! Double)/100)
                                        if let blurbs = (JSON["description"]!){
                                           // print(blurb)
                                            
                                        }
                                        
                                        let blur = JSON["description"]!
                                        var description:String
                                        
                                        if blur == nil{
                                          //  print("it's nil")
                                            description = ""
                                        }
                                        else{
                                            //print(blur!)
                                            description = String(blur!)
                                        }
                              //          print(String(JSON["description"]!!))
                                        self.insertNewObject(Book(author: book["author"] as! String,
                                                title: book["title"] as! String,
                                                id: String(book["id"]!!),
                                                isbn:book["isbn"] as! String,
                                                currencyCode:book["currencyCode"] as! String,
                                                imageUrl:"http://covers.openlibrary.org/b/isbn/" + (book["isbn"] as! String) + "-L.jpg",
                                                price:amount!,
                                                description:description)
                                            )
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        })
                        dataTask2.resume()
                            
                        }
                      
                    } catch {
                        print(error)
                    }
                }
            }
        })
        dataTask.resume()
        dispatch_async(dispatch_get_main_queue(), {
            print("reloading table")
            self.tableView.reloadData()
        })
      print("finished")
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
        self.tableView.separatorStyle = .None  //remove seperator lines in table
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = bookShelf[indexPath.row]
        cell.textLabel!.text = object.title
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        //create new label element and add it to cell
        let label = UILabel(frame: CGRect(x:20, y:50, width:200, height:25))
        label.text = object.author
        label.font = UIFont(name: "GillSans-Italic", size: 10)
        cell.addSubview(label)
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

