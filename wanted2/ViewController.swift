//
//  ViewController.swift
//  wanted2
//
//  Created by Jo on 2023/02/26.
//

import UIKit

class ViewController: UIViewController, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    
    @IBOutlet weak var iv1: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv4: UIImageView!
    @IBOutlet weak var iv5: UIImageView!
    
    @IBOutlet weak var prgv1: UIProgressView!
    @IBOutlet weak var prgv2: UIProgressView!
    @IBOutlet weak var prgv3: UIProgressView!
    @IBOutlet weak var prgv4: UIProgressView!
    @IBOutlet weak var prgv5: UIProgressView!
    
    private lazy var arrIv = [iv1, iv2, iv3, iv4, iv5]
    private lazy var arrPrgv = [prgv1, prgv2, prgv3, prgv4, prgv5]
    
    private let url = [
        "https://plus.unsplash.com/premium_photo-1669075651762-0e4140044722?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
        "https://images.unsplash.com/photo-1534644107580-3a4dbd494a95?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
        "https://images.unsplash.com/photo-1520004434532-668416a08753?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
        "https://images.unsplash.com/photo-1509869175650-a1d97972541a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
        "https://images.unsplash.com/photo-1606326608606-aa0b62935f2b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"
    ]
    
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loadButtonTouched(_ sender: UIButton) {
        arrIv[sender.tag]?.image = UIImage(systemName: "photo")
        arrPrgv[sender.tag]?.progress = 0
        fetchImage(url: url[sender.tag])
    }
    
    func fetchImage(url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        DispatchQueue.global().async {
            session.downloadTask(with: url).resume()
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        if let urlString = downloadTask.currentRequest?.url?.absoluteString, // index 찾기
           let index = url.firstIndex(of: urlString) {
            DispatchQueue.main.async { [weak self] in
                self?.arrPrgv[index]?.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location),
           let image = UIImage(data: data),
           let urlString = downloadTask.currentRequest?.url?.absoluteString,
           let index = url.firstIndex(of: urlString) {
            DispatchQueue.main.async { [weak self] in
                self?.arrIv[index]?.image = image
            }
        } else {
            fatalError("Cannot load the image")
        }
    }
}
