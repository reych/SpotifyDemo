//
//  SpotifyViewController.swift
//  SpotifySDKDemo
//
//  Created by Chen, Rena on 7/10/17.
//

import UIKit

class SpotifyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    var tracks: Array<SPTPlaylistTrack>?
    var playlistURI = "spotify:user:dinosaur_food:playlist:1q4Ne6WVYdr57Wn1TZVF0M"
    
    var firstPlay = true
    
    let cellReuseIdentifier = "playlistCell"
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get playlist
        SpotifyManager.shared.getPlaylistSnapshot(uri: URL(string:playlistURI)!).then{ playlist -> Void in
            
            if let page = playlist.firstTrackPage as SPTListPage? {
                if let items = page.items as Array<Any>? {
                    print("got playlist snapshot")
                    self.tracks = items as? Array<SPTPlaylistTrack>
                    
                    //let url = self.tracks?[0].previewURL.absoluteString
                    //print(url!)
                    self.collectionView.reloadData()
                }
            }
            self.coverImage.image = self.getImageFromURL(playlist.largestImage.imageURL)
            self.titleLabel.text = playlist.name!
            
        }.catch { err in
            print("Error getting playlist snapshot!")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sptracks = tracks {
            print("sptracks count: \(sptracks.count)")
            return sptracks.count
        }
        print ("No tracks to be found!")
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // fill in cell.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PlaylistCollectionViewCell
        
        //cell.track = tracks?[indexPath.row]
        //cell.index = indexPath.row + 1
        let track = tracks?[indexPath.row]
        cell.indexLabel.text = "\(indexPath.row + 1)" // start count at 1.
        cell.titleLabel.text = track?.name
        cell.albumImage.image = self.getImageFromURL((track?.album.smallestCover.imageURL)!)
        let artists = track?.artists as! Array<SPTPartialArtist>
        cell.artistLabel.text = artists[0].name
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if SpotifyManager.shared.isPremiumAccount() {
            SpotifyManager.shared.playPlaylist(uri: playlistURI, index: UInt(indexPath.row))
            self.playPauseButton.setTitle("PAUSE", for: UIControlState.normal)
        } else {
            // play the individual stuffs.
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        if SpotifyManager.shared.playerEnabled() {
            if SpotifyManager.shared.isPlayingTrack() {
                SpotifyManager.shared.pausePlayer()
                self.playPauseButton.setTitle("PLAY", for: UIControlState.normal)
            } else {
                if firstPlay {
                    SpotifyManager.shared.playPlaylist(uri: playlistURI, index: 0)
                    firstPlay = false
                }
                SpotifyManager.shared.continuePlayer()
                //DispatchQueue.main.async {
                    self.playPauseButton.setTitle("PAUSE", for: UIControlState.normal)
                //}
                
            }
        }
        
    }
    
    
    // Utility
    func getImageFromURL(_ url: URL) -> UIImage{
        let imageData = NSData(contentsOf: url)
        let image = UIImage(data: imageData! as Data)
        return image!
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
