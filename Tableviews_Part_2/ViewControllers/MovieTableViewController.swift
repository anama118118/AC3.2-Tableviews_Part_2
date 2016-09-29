//
//  MovieTableViewController.swift
//  Tableviews_Part_2//
//  Created by Jason Gresh on 9/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    enum CellStyle {
        case blackAndWhite
        case singleGreenBar
        case greenBackground
    }
    
    var selectedCellStyle = CellStyle.blackAndWhite
    
    @IBAction func layoutOneItemTapped(_ sender: UIBarButtonItem) {
        selectedCellStyle = CellStyle.blackAndWhite
        self.tableView.reloadData()
    }
    @IBAction func layoutTwoItemTapped(_ sender: UIBarButtonItem) {
        selectedCellStyle = CellStyle.singleGreenBar
        self.tableView.reloadData()
    }
    @IBAction func layoutThreeItemTapped(_ sender: UIBarButtonItem) {
        selectedCellStyle = CellStyle.greenBackground
        self.tableView.reloadData()
    }
    @IBAction func barButton(_ sender: UIBarButtonItem) {
    }
    
    enum Century: Int { case twentieth, twentyFirst }
    enum Genre: Int {
        case animation
        case action
        case drama
    }
  
    internal var movieData: [Movie]?

    internal let rawMovieData: [[String : Any]] = movies
    let cellIdentifier1: String = "MovieTableViewCell1"
    let cellIdentifier2: String = "MovieTableViewCell2"
    let cellIdentifier3: String = "MovieTableViewCell3"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movies"
        // 1. need to update our table for self-sizing cells
        
        // converting from array of dictionaries
        // to an array of Movie structs
        var movieContainer: [Movie] = []
        for rawMovie in rawMovieData {
            movieContainer.append(Movie(from: rawMovie))
        }
        movieData = movieContainer
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200.0
    }

    override func viewWillAppear(_ animated: Bool) { //called immidiately after the view did load
        super.viewWillAppear(animated)
        
        //self.navigationController
        // 1. update our nav controller's tints and font
        if let navigationController: UINavigationController = self.navigationController{
            navigationController.navigationBar.tintColor = UIColor.white
            navigationController.navigationBar.barTintColor = UIColor.reelGoodGreen
            navigationController.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : UIFont.systemFont(ofSize: 24.0)
            ]
        }
        
        // 2. add a new bar button
//        let menubarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"reel"), style: .plain, target: nil, action: nil)
//            self.navigationItem.setLeftBarButton(menubarButton, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let genre = Genre.init(rawValue: section),
            let data = byGenre(genre) else  {
                return 0
        }
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anotherIdentifier: String
//        if self.selectedCellStyle == .blackAndWhite {
//            anotherIdentifier = cellIdentifier1
//        } else if self.selectedCellStyle == .singleGreenBar{
//            anotherIdentifier = cellIdentifier2
//        } else {
//            anotherIdentifier = cellIdentifier3
//        }
        
        switch(self.selectedCellStyle) {
        case .blackAndWhite: anotherIdentifier = cellIdentifier1
        case .singleGreenBar: anotherIdentifier = cellIdentifier2
        case .greenBackground: anotherIdentifier = cellIdentifier3
        }
        
        
//        let identifier: String
//        if (indexPath.section  % 2 == 0) {
//            identifier = cellIdentifier1
//        } else {
//            identifier = cellIdentifier2
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: anotherIdentifier, for: indexPath)
        guard let genre = Genre.init(rawValue: indexPath.section),
            let data = byGenre(genre) else {
            return cell
        }
        
        if let movieCell: MovieTableViewCell = cell as? MovieTableViewCell {
            if self.selectedCellStyle == .singleGreenBar {
                 movieCell.movieYearLabel.text = String(data[indexPath.row].year)
            }
//            if (indexPath.section  % 2 == 1) {
//                movieCell.movieYearLabel.text = String(data[indexPath.row].year) //let cellIdentifier: String = "MovieTableViewCell1"uncomment when 2
//            }
            movieCell.movieTitleLabel.text = data[indexPath.row].title
            movieCell.movieSummaryLabel.text = data[indexPath.row].summary
            
            movieCell.moviePosterImageView.image = UIImage(named: data[indexPath.row].poster)
            
            
            return movieCell
        }
        
        // update to use a custom cell subclass
        
        cell.textLabel?.text = data[indexPath.row].title
        cell.detailTextLabel?.text = String(data[indexPath.row].year)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let genre = Genre.init(rawValue: section) else {
            return ""
        }
        
        switch genre {
        case .action:
            return "Action"
        case .animation:
            return "Animation"
        case .drama:
            return "Drama"
        }
    }
    
    // MARK: - Utility
    func by(_ c: Century) -> [Movie]? {
        let filter: (Movie) -> Bool
        switch c {
        case .twentieth:
            filter = { (a) -> Bool in
                a.year < 2001
            }
        case .twentyFirst:
            filter = { (a) -> Bool in
                a.year >= 2001
            }
        }
        
        // after filtering, sort
        let filtered = movieData?.filter(filter).sorted { $0.year < $1.year }
        
        return filtered
    }
    
    func byGenre(_ genre: Genre) -> [Movie]? {
        let filter: (Movie) -> Bool
        switch genre {
        case .action:
            filter = { (a) -> Bool in
                a.genre == "action"
            }
        case .animation:
            filter = { (a) -> Bool in
                a.genre == "animation"
            }
        case .drama:
            filter = { (a) -> Bool in
                a.genre == "drama"
            }
        }
        
        // after filtering, sort
        let filtered = movieData?.filter(filter).sorted { $0.year < $1.year }
        
        return filtered
    }
}
