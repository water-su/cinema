//
//  MovieListViewController.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit
import RxSwift

class MovieListViewController: UIViewController {

    fileprivate let cellId = "movieCell"
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib.init(nibName: "MovieTableViewCell", bundle: nil) , forCellReuseIdentifier: cellId)
        }
    }
    
    fileprivate let didPress = PublishSubject<Movie>()
    
    private let disposeBag = DisposeBag()
    
    fileprivate var dataSource : [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.requestAPI()
        
        didPress
            .debounce(0.25, scheduler: MainScheduler.instance)  // prevent multiple click
            .subscribe(onNext: { [weak self] (movie) in
                // click on movie
                // openMovie
                self?.open(movie)
            }).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func requestAPI(){
        APIManager.getMovieList(page: 1)
            .subscribe(onNext: { [weak self] (response, json) in
                guard let json = json as? [String : Any] else {return} // handle format error
                if let datas = json["results"] as? [[String: Any]]{
                    self?.dataSource.append(contentsOf: MovieManager.shared.parse(data: datas))
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func open(_ movie: Movie?){
        guard let movie = movie else {return}
        
    }

}
extension MovieListViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieTableViewCell
        let data = self.dataSource[safe:indexPath.row]
        // enhance cell UI
        cell.bind(movie: data)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let movie = self.dataSource[safe: indexPath.row]{
            didPress.onNext(movie)
        }
    }
}
