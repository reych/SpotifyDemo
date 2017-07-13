//
//  PlaylistCollectionViewCell.swift
//  SpotifySDKDemo
//
//  Created by Chen, Rena on 7/10/17.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var track: SPTPlaylistTrack?
    var index: Int = 1
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    
}
