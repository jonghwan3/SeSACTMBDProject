//
//  TMDBViewController.swift
//  SeSACTMBDProject
//
//  Created by 박종환 on 2022/08/04.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class TMDBViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var TMBDCollectionView: UICollectionView!
    
    var list: [Movie] = []
    var credits: [Int : [Actor]] = [:]
    var genreList: [Int : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGenre()
        TMBDCollectionView.delegate = self
        TMBDCollectionView.dataSource = self
        TMBDCollectionView.register(UINib(nibName: TMBDCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TMBDCollectionViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = UIScreen.main.bounds.width * 0.1
                let sectionSpacing: CGFloat = UIScreen.main.bounds.width * 0.06
                let width = (UIScreen.main.bounds.width - spacing * 0 - sectionSpacing * 2) / 1
        layout.itemSize = CGSize(width: width, height: width * 1)
                layout.scrollDirection = .vertical
                layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
                layout.minimumInteritemSpacing = spacing
                layout.minimumLineSpacing = spacing
        TMBDCollectionView.collectionViewLayout = layout
        
        let mediaType = Media_Type.movie.rawValue
        let timeWindow = Time_Window.week.rawValue
        requestTrendInfo(mediaType: mediaType, timeWindow: timeWindow)
        
    }
    
    func setGenre() {
        let url = "\(EndPoint.TMBD_GENRE)?api_key=\(APIKey.TMBD_APIKey)"
        AF.request(url, method: .get).validate(statusCode: 200..<299).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
  
                for genre in json["genres"].arrayValue {
                    let id = genre["id"].intValue
                    let name = genre["name"].stringValue
                    
                    self.genreList[id] = name
                }
                self.TMBDCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestTrendInfo(mediaType: String, timeWindow: String) {
        
        let url = "\(EndPoint.TMBD_URL)\(mediaType)/\(timeWindow)?api_key=\(APIKey.TMBD_APIKey)"
        print(url)
        AF.request(url, method: .get).validate(statusCode: 200..<299).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                var index = 0
                
                for item in json["results"].arrayValue {
                    let id = item["id"].stringValue
                    self.requestCreditsInfo(id: id, index: index)
                    let vote_average = round(item["vote_average"].doubleValue * 10) / 10
                    let original_title = item["original_title"].stringValue
                    let genre_ids = item["genre_ids"][0].intValue
                    let release_date = item["release_date"].stringValue
                    let url = URL(string: "\(EndPoint.TMBD_IMG_URL)\(item["backdrop_path"].stringValue)")
                    let data = Movie(movieTitle: original_title, date: release_date, rate: vote_average, genreId: genre_ids, actors: [], url: url)
                    
                    index += 1
                    self.list.append(data)
                }
                
            
                
                self.TMBDCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func requestCreditsInfo(id: String, index: Int) {
        let url = "\(EndPoint.TMBD_CRDIT)\(id)/credits?api_key=\(APIKey.TMBD_APIKey)"
        var actors: [Actor] = []
        AF.request(url, method: .get).validate(statusCode: 200..<299).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                for cast in json["cast"].arrayValue {
                    
                    let name = cast["name"].stringValue
                    let data = Actor(name: name)
                    actors.append(data)
                }
                self.credits[index] = actors
                self.TMBDCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMBDCollectionViewCell.reuseIdentifier, for: indexPath) as? TMBDCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configCell()
        
        cell.titleLabel.text = list[indexPath.item].movieTitle
        cell.rateLabel.text = "\(list[indexPath.item].rate)"
        cell.dateLabel.text = list[indexPath.item].date
        if !genreList.isEmpty {
            cell.genreLabel.text = "#\(genreList[list[indexPath.item].genreId] ?? "NA")"
        }
        cell.imageView.kf.setImage(with: list[indexPath.item].url)
        
        if !credits.isEmpty {
            if let actors = credits[indexPath.item] {
                var actorsName = ""
                if actors.count != 0 {
                    actorsName += actors[0].name
                    for actor in 1..<actors.count {
                        actorsName += ", \(actors[actor].name)"
                    }
                }
                cell.actorsLabel.text = actorsName
            }
        }
        
        return cell
    }

}
