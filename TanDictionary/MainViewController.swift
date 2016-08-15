//
//  MainViewController.swift
//  TanDictionary
//
//  Created by dinh trong thang on 8/11/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var tus = [Tuc]()
    var dictionarySelected:Int = 0
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate=self
        // Do any additional setup after loading the view.
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func segmentAction(sender: AnyObject) {
        print(segmentControl.selectedSegmentIndex)
        self.dictionarySelected = segmentControl.selectedSegmentIndex
    }
}
extension MainViewController:UITableViewDelegate{
    
}
extension MainViewController:UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tus.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MainTableViewCell
        cell.mainLabel.text = tus[indexPath.row].phrase.text
        return cell
    }
}
extension MainViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        SearchManager.shareSearchManager.delegate=self
        SearchManager.shareSearchManager.getDataFromSearchText(self.searchBar.text!,dictionIndex:self.dictionarySelected)
    }
}
extension MainViewController:SearchManagerDelegate {
    func assignData(tus: [Tuc]) {
        self.tus = tus
        print(tus.count)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
}
