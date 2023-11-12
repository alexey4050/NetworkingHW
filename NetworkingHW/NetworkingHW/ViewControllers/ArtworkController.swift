//
//  ViewController.swift
//  NetworkingHW
//
//  Created by testing on 10.11.2023.
//

import UIKit

enum Link {
    case photosURL
    case postsURL
    case todosURL
    
    var url: URL! {
        switch self {
        case .photosURL:
            return URL(string: "https://jsonplaceholder.typicode.com/photos")
        case .postsURL:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")
        case .todosURL:
            return URL(string: "https://jsonplaceholder.typicode.com/todos")
        }
    }
}

enum UserAction: CaseIterable {
    case fetchArtworkFirst
    case fetchArtworkSecond
    case fetchArtworkThird
    
    var title: String {
        switch self {
        case .fetchArtworkFirst:
            return "Fetch Photos"
        case .fetchArtworkSecond:
            return "Fetch Posts"
        case .fetchArtworkThird:
            return "Fetch Todos"
        }
    }
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    var massege: String {
        switch self {
        case .success:
            return "You can see the result in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

//MARK: - Private Methods
final class ArtworkController: UICollectionViewController {
    
    private let userActons = UserAction.allCases
    
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.massege, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ArtworkController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath) as? UserActionCell else { return UICollectionViewCell() }
        
        cell.userActionLabel.text = userActons[indexPath.item].title
        
        return cell
    }
}

//MARK: - CollectionViewDelegate
extension ArtworkController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActons[indexPath.item]
        
        switch userAction {
            
        case .fetchArtworkFirst:
            performSegue(withIdentifier: "showImage", sender: nil)
        case .fetchArtworkSecond:
            fetchArtworkSecond()
        case .fetchArtworkThird:
            fetchArtworkThird()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
    
    private func fetchArtworkSecond() {
        URLSession.shared.dataTask(with: Link.postsURL.url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No data received")
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                print(posts)
                self.showAlert(withStatus: .success)
            } catch let error {
                print(error.localizedDescription)
                self.showAlert(withStatus: .failed)
            }
        }.resume()
    }
    
    private func fetchArtworkThird() {
        URLSession.shared.dataTask(with: Link.todosURL.url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No data received")
                return
            }
            
            do {
                let todos = try JSONDecoder().decode([Todos].self, from: data)
                print(todos)
                self.showAlert(withStatus: .success)
            } catch let error {
                print(error.localizedDescription)
                self.showAlert(withStatus: .failed)
            }
        }.resume()
    }
}


        

