//
//  ViewController.swift
//  MovieFinder
//
//  Created by Mehreen Kanwal on 25.01.23.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet var movieSearchLabel : UILabel!
    
    @IBOutlet var table: UITableView!
    @IBOutlet var field : UITextField!
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        table.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.identifier)
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    func searchMovies() {
        field.resignFirstResponder()
        guard let text = field.text , !text.isEmpty else  {
            return
        }
        let query = text.replacingOccurrences(of: " ", with: "%20")
        movies.removeAll()

        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=3aea79ac&s=\(query)&type=movie")!,
                                   
                                   completionHandler: { data, response, error in
                                   guard let data = data, error == nil else {
                                        return
                                    }
                                    var result: MovieResult?
                                    do {
                                        result = try JSONDecoder().decode(MovieResult.self, from: data)
                                    }
                                    catch {
                                        print("error")
                                    }
                                    guard let finalResult = result else {
                                        return
                                    }
                                    let newMovies = finalResult.Search
                                    self.movies.append(contentsOf: newMovies)
                                    DispatchQueue.main.async {
                                        self.table.reloadData()
                                    }

        }).resume()
    }


}

extension ViewController : UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell {
        cell.configure(with: movies[indexPath.row])
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 267
    }
}


struct MovieResult: Codable {
    let Search: [Movie]
}

struct Movie: Codable {
    let title: String
    let year: String
    let imdbID: String
    let _Type: String
    let Poster: String

    private enum CodingKeys: String, CodingKey {
        case title = "Title", year = "Year", imdbID, _Type = "Type", Poster
    }
}
