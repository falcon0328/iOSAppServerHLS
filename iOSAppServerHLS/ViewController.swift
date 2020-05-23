//
//  ViewController.swift
//  iOSAppServerHLS
//
//  Created by aseo on 2020/05/24.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let avPlayerVC = AVPlayerViewController()
        let avPlayer = AVPlayer(url: URL(string: "http://localhost:8080/prog_index.m3u8")!)
        avPlayerVC.player = avPlayer
        present(avPlayerVC, animated: true) { avPlayer.play() }
    }

}

