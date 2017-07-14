Spotify Demo
===============================================
Spotify player with albums in a collection view, and a login screen. Written in Swift3, using Spotify iOS SDK (beta).

Updates
-----------------------------------------------
The 'continue without logging in' is not yet accounted for. The player will not work because calls cannot be made to Spotify API without a session token. Logging in with a non-Premium account is also in progress (this will play a 30 second sample instead of trying to stream).

Requirements (Tested)
-----------------------------------------------
* Swift 3
* XCode 8.3.3
* CocoaPods 4.x.x

Frameworks and Dependencies
-----------------------------------------------
* SpotifyAudioPlayback, SpotifyAuthentication, SpotifyMetaData
* PromiseKit

How to run this project
-----------------------------------------------
1. Install pod dependencies.  
  ```
  $ pod install
  ```
2. Open the workspace project.
3. Run simulator to see demo.

How to integrate this project into another project
-----------------------------------------------
We will break this up into three parts: (1) Downloading the SDK and importing frameworks; (2) Creating an account in Spotify Developer to get credentials and callback URL; and (3) Updating your XCode project's project settings. For more information, visit [Spotify Developer Site](https://developer.spotify.com/technologies/spotify-ios-sdk/ "Spotify Developer")

**1. Download SDK and import frameworks:** this should already be included in SpotifyDemo, so you can skip this step. If you still want to do it yourself:
  * Checkout master branch from [Github Spotify iOS SDK](https://github.com/spotify/ios-sdk "ios-sdk").
  * Copy frameworks into a SpotifyFrameworks folder.
  * Create an ObjectiveC bridging header to import frameworks.  

  Install PromiseKit:
  * If you don't have a podfile, run:
  ```
  $ pod init
  ```
  * If you have a pod file, make sure that under your project target, include **pod "PromiseKit", "~> 4.0"**
  * Install.
  ```
  $ pod install
  ```
**2. Create account in Spotify Developer:** Currently this project has credentials from an existing account (you shouldn't actually do this), so you have to create your own account.
  * Go to https://developer.spotify.com/
  * Go to My Apps, at the navigation bar.
  * Login to your Spotify account (don't worry, this is still free as of 07/14/2017).
  * Go to My Applications and **CREATE AN APP**
  * Fill in the following:

    **Application Name:** name of your application  
    **Description:** Describe it.  
    **Redirect URIs:** This can be anything, really. Follow format unique-prefix://callback. We're using this for the login function, so you can call it something like login://returnAfterLogin.  
    **Bundle ID:** This is the ID for your project, of the form com.company.ProjectName  

    Make note of the client ID and secret, this will be used later.

  * Save.

**3. Update XCode project**  
  * In Build Settings -> Other Linker flags -> add **-ObjC** and **$(inherited)**
  * In Build Phases -> Link binary with libraries: SpotifyMetadata.framework, SpotifyAudioPlayback.framework, SpotifyAuthentication.framework
  * In Info -> Add URL type:
    * Identifier: bundle identifier+identifier  (com.company.ProjectName.spotify-auth)
    * URL scheme: first section of callback URL (if your callback was spotify-test-login://callback, then url scheme is spotify-test-login).

Classes
-----------------------------------------------
1. *SpotifyManager: NSObject, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate*  
  Singleton that manages Spotify login and streaming, playback.

2. *SpotifyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource*  
  The ViewController that contains the playlist. Has a collection view that displays clickable albums.

3. *SpotifyLoginViewController: UIViewController*  
  Login page, segues to SpotifyViewController.

4. *PlaylistCollectionViewCell: UICollectionViewCell*  
  Custom cell for the collection view used in SpotifyViewController.  
