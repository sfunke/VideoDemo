//
//  CustomVideoViewController.swift
//  VideoDemo
//
//  Created by Steffen Funke on 08.02.21.
//

import AVKit
import UIKit

class CustomVideoViewController: UIViewController {

    @IBOutlet weak var videoContainer: UIView!

    enum PlaybackType {
        case localFile(_ fileName: String, _ fileExtension: String)
        case url(videoUrl: String)
    }

    var playbackType: PlaybackType!
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        switch playbackType {
        case let .localFile(fileName, fileExtension):
            guard let path = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
                debugPrint("\(fileName).\(fileExtension) not found")
                dismiss(animated: true)
                return
            }
            let url = URL(fileURLWithPath: path)
            presentPlayer(url)
        case .url(let videoUrl):
            guard let url = URL(string: videoUrl) else {
                debugPrint("\(videoUrl) not correct")
                dismiss(animated: true)
                return
            }
            presentPlayer(url)
        case .none:
            debugPrint("Unknown PlaybackType")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
        player = nil
        super.viewDidDisappear(animated)
    }

    private func presentPlayer(_ url: URL) {
        player = AVPlayer(url: url)

        let playerVC = AVPlayerViewController()
        playerVC.player = player
        playerVC.view.frame = CGRect(x: 0, y: 0, width: videoContainer.frame.width, height: videoContainer.frame.height)

        addChild(playerVC)
        videoContainer.addSubview(playerVC.view)
        playerVC.didMove(toParent: self)

        player?.play()
    }
}
