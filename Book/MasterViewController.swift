//
//  MasterViewController.swift
//  BookStop
//
//  Created by Niamh Lawlor on 30/10/2015.
//  Copyright © 2015 Niamh Lawlor. All rights reserved.
//

import UIKit

struct Bookk{
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
    var bookShelf = [Bookk]()
    
    var url = NSURL(string: "http://private-anon-6e95240a2-tpbookserver.apiary-mock.com/books")
    
    var listOfBooks : NSMutableArray = []
    
  //  var bookShelf = [String: Bookk]()
    
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
                            self.insertNewObject(Bookk(author: book["author"] as! String,
                                title: book["title"] as! String,
                                id: String(book["id"]!!),
                                isbn:book["isbn"] as! String,
                                currencyCode:book["currencyCode"] as! String,
                                imageUrl:"http://covers.openlibrary.org/b/isbn/" + (book["isbn"] as! String) + "-L.jpg",
                                price:book["price"] as! Double,
                                description:"")
                                
                            )
                        }
                      //  self.getDescription("200")
                    } catch {
                        print(error)
                    }
                }
            }
        })
        dataTask.resume()
    } // end of api call function
    
    
   /* func getDescription(id:String)  {
        let session = NSURLSession.sharedSession()
        print(id)
        
        let dataTask = session.dataTaskWithURL(NSURL(string: "http://private-anon-6e95240a2-tpbookserver.apiary-mock.com/book/300")!, completionHandler: { (data: NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            
            if let unwrappedError = error {
                print("error=\(unwrappedError)")
            }
                
            else{
                if var _ = data{
                    do {
                        let JSONInfo = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        print(JSONInfo)
                        let description:String = JSONInfo["description"] as! String
                        let id:String = String(JSONInfo["id"])
                     //  print(description)
                        print(id)
                       // for(var i:Int=0;i<self.objects.count;i++){
                       //     print(self.objects[i].id)
                       //     self.objects[i].description = description
                            
                            
                      //  }
                    } catch {
                        print(error)
                    }
                }
            }
        })
        dataTask.resume()
    } // end of api call function*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        bookModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: Bookk) {
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
       // self.tableView.separatorColor = c
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = bookShelf[indexPath.row]
        cell.textLabel!.text = object.title
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        let label = UILabel(frame: CGRect(x:17, y:17, width:200, height:25))
       // let label = UILabel()
        label.text = object.author
        label.font = UIFont(name: label.font.fontName, size: 5)
        cell.addSubview(label)
        cell.imageView?.frame = CGRectMake( 0, 0, 50, 55 );
      
        return cell
    }
}

