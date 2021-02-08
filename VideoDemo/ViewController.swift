//
//  ViewController.swift
//  VideoDemo
//
//  Created by Steffen Funke on 08.02.21.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    let remoteVideoUrl = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_30MB.mp4"
    let localVideoFile = "dummy.m4v"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    // MARK: - Open Video in Custom ViewController

    @IBAction func openVideoFromUrlInCustomVC(_ sender: Any) {
        let customVideoViewController = instantiateCustomVideoViewController()
        customVideoViewController.playbackType = .url(videoUrl: remoteVideoUrl)
        present(customVideoViewController, animated: true)
    }


    @IBAction func openLocalVideoInCustomVC(_ sender: Any) {
        // casting as NNSString is necessary to get those path utility methods
        let fileExtension = (localVideoFile as NSString).pathExtension
        let fileName = (localVideoFile as NSString).deletingPathExtension

        let customVideoViewController = instantiateCustomVideoViewController()
        customVideoViewController.playbackType = .localFile(fileName, fileExtension)
        present(customVideoViewController, animated: true)
    }

    private func instantiateCustomVideoViewController() -> CustomVideoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customVideoViewController = storyboard.instantiateViewController(withIdentifier: "CustomVideoViewController") as! CustomVideoViewController
        return customVideoViewController
    }



    // MARK: - Open Video in Native Player

    @IBAction func openVideoFromUrlInNativeVC(_ sender: Any) {
        let url = try! getUrl(from: remoteVideoUrl)
        openNativePlayer(with: url)
    }

    @IBAction func openLocalVideoInNativeVC(_ sender: Any) {
        // casting as NNSString is necessary to get those path utility methods
        let fileExtension = (localVideoFile as NSString).pathExtension
        let fileName = (localVideoFile as NSString).deletingPathExtension

        let url = try! getUrl(from: fileName, with: fileExtension)
        openNativePlayer(with: url)
    }

    private func getUrl(from fileName: String, with fileExtension: String) throws -> URL {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            // guard let url = Bundle.main.url(forResource: fileName, withExtension: "") else {
            fatalError("\(fileName).\(fileExtension) not found")
            // fatalError("\(fileName) not found")
        }
        let url = URL(fileURLWithPath: path)
        return url
    }

    private func getUrl(from videoUrl: String) throws -> URL {
        guard let url = URL(string: videoUrl) else {
            fatalError("\(videoUrl) not correct")
        }
        return url
    }

    private func openNativePlayer(with videoURL: URL) {
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }


}

