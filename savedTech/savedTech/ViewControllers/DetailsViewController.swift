//
//  DetailsViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 3/9/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var exampleOfReports: [String] = []
    @IBOutlet weak var tableDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDetails.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if exampleOfReports.count > 0 {
            numberOfRows = exampleOfReports.count
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if exampleOfReports.count > 0 {
            cell.textLabel?.text = "\(exampleOfReports[indexPath.row])"
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
