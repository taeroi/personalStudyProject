//
//  ViewController.swift
//  UpgradedUITableViewTutorial
//
//  Created by 태로고침 on 2021/04/06.
//

import UIKit

class ArtistListViewController: UIViewController {
    
    let artists = Artist.artistsFromBundle()

    @IBOutlet weak var artistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Artist"
        
        
        
        artistTableView.rowHeight = UITableView.automaticDimension
        artistTableView.estimatedRowHeight = 140
        
        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification,
                                               object: .none,
                                               queue: OperationQueue.main) { [weak self] _ in
            self?.artistTableView.reloadData()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArtistDetailViewController,
           let indexPath = artistTableView.indexPathForSelectedRow {
            destination.selectedArtist = artists[indexPath.row]
        }
    }
}

extension ArtistListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as! ArtistTableViewCell
        
        let artist = artists[indexPath.row]
        
        cell.bioLabel.text = artist.bio
        cell.nameLabel.text = artist.name
        cell.artistImageView.image = artist.image
        
        return cell
    }
}

