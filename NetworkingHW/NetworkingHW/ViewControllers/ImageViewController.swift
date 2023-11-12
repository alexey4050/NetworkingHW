//
//  ImageViewController.swift
//  NetworkingHW
//
//  Created by testing on 12.11.2023.
//

import UIKit

final class ImageViewController: UIViewController {
    private var artworks: [Artwork] = []
    private var currentIndex: Int = 0
    private var timer: Timer?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchArtworks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showNextArtwork), userInfo: nil, repeats: true)
    }
    
    private func fetchArtworks() {
        URLSession.shared.dataTask(with: Link.photosURL.url) { [weak self] data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let artworks = try decoder.decode([Artwork].self, from: data)
                self?.artworks = artworks
                
                DispatchQueue.main.async {
                    self?.showArtwork(at: self?.currentIndex ?? 0)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    private func showArtwork(at index: Int) {
        guard index >= 0 && index < artworks.count else {
            print("Invalid index")
            return
        }
        let artwork = artworks[index]
        guard let url = URL(string: artwork.url) else {
            print("Invalid URL")
            return
        }
        activityIndicator.startAnimating()
        imageView.image = nil
        
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                print(error?.localizedDescription ?? "No data received")
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }.resume()
    }
    
    @objc private func showNextArtwork() {
        currentIndex = (currentIndex + 1) % artworks.count
        showArtwork(at: currentIndex)
    }
}
    
