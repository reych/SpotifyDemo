//
//  SpotifyManager.swift
//  SpotifySDKDemo
//
//  Manage login and playback of Spotify playlist and tracks.
//
//  Created by Chen, Rena on 7/10/17.
//

import UIKit
import SafariServices
import AVFoundation
import PromiseKit

class SpotifyManager: NSObject, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate{
    
    // MARK: - Singleton
    
    static let shared = SpotifyManager()
    
    // MARK: Variables
    
    // Variables
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    private var isPremium = false
    
    // Initialzed in either updateAfterFirstLogin: (if first time login) or in viewDidLoad (when there is a check for a session object in User Defaults
    var player: SPTAudioStreamingController?
    var isPlaying = false
    var canPlay = false
    
    var loginUrl: URL?
    
    // MARK: Init
    fileprivate override init() {
        super.init()
        
        setup()
    }

    // MARK: Environment Setup
    private func setup () {
        // insert redirect your url and client ID below
        let redirectURL = "spotify-test-login://callback"
        let clientID = "484e3d627b7d4af9b8d3be79638b678f" // put your client ID here
        auth.redirectURL     = URL(string: redirectURL)
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
        
    }
    
    // MARK: Player initialization
    private func initializePlayer(authSession:SPTSession){
        print("initializePlayer entered")
        if self.player == nil {
            
            print("initializePlayer player not nil")
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            
        }
        
    }
    
    
    // MARK: Audiostreaming Delegate
    
    // Will only happen if you have a premium account.
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        setIsPremium(true)
        canPlay = true
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        print("logged out")
        setIsPremium(false)
    }
    
    func audioStreamingDidBecomeActivePlaybackDevice(_ audioStreaming: SPTAudioStreamingController!) {
        self.canPlay = true
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        self.isPlaying = isPlaying
    }

    
    // MARK: Login
    
    func login(){
        if UIApplication.shared.openURL(loginUrl!) {
                
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
                print("auth can handle")
                
            } else {
                print("not a redirect url")
            }
        }
        
    }
    
    func isPremiumAccount() -> Bool{
        return isPremium
    }
    
    private func setIsPremium(_ value: Bool) {
        isPremium = value
    }
    
    
    // Initialize player when logged in (notification)
    func updateAfterFirstLogin () {
        print("updateAfterFirstLogin")
        
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            initializePlayer(authSession: session)
            
        }
        
    }
    
    // MARK: Player Control
    
    // Get playlist tracks as a promise
    func getPlaylistSnapshot(uri: URL) -> Promise<SPTPlaylistSnapshot> {
        return Promise { fulfill, reject in
            SPTPlaylistSnapshot.playlist(withURI: uri, accessToken: self.session.accessToken, callback: {(error, playlistObj) in
                print("Getting playlist object")
                
                if let playlistSnapshot = playlistObj as! SPTPlaylistSnapshot? {
                    fulfill(playlistSnapshot)
                } else {
                    reject(NSError())
                }
                
                
            })
            
        }
        
    }
    
    
    // Play a track of a playlist at given index.
    // Fulfills true if can be played, fulfills false if cannot.
    func playPlaylist(uri: String, index: UInt) -> Promise<Bool>{
        return Promise { fulfill, reject in
            
            if isPremiumAccount() {
                self.player?.playSpotifyURI(uri, startingWith: index, startingWithPosition: 0, callback: { (error) in
                    self.isPlaying = true
                    if (error != nil) {
                        print("error!")
                        fulfill(false)
                    } else {
                        print("playing")
                        fulfill(true)
                    }
                    
                })
            } else {
                fulfill(false)
            }

        }
        
        
    }
    
    // Pauses the player.
    func pausePlayer() {
        player?.setIsPlaying(false, callback: { (error) in
            // do something
            if(error != nil) {
                print("error!")
            } else {
                print("pause")
            }
        })
    }
    
    // Continues the player.
    func continuePlayer() {
        player?.setIsPlaying(true, callback: { (error) in
            // do something
            if(error != nil) {
                print("error!")
            } else {
                print("pause")
            }
        })
    }
    
    // Returns true if the player is playing something.
    func isPlayingTrack() -> Bool {
        return isPlaying
    }
    
    func playerEnabled() -> Bool {
        return canPlay
    }
    

}
