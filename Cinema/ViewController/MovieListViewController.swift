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
            tableView.refreshControl = self.refreshControl
        }
    }
    
    fileprivate var bShowEmptyView : Bool = false{
        didSet{
            self.emptyView?.isHidden = !bShowEmptyView
        }
    }
    
    // TODO: empty view mechanism can be move to base view controller
    private lazy var emptyView : EmptyView? = {
        if let view = EmptyView.loadFromXib(){
            view.bind(type: .MovieList)
            self.view.addSubview(view)
            view.fit(self.view)
            return view
        }
        return nil
    }()
    
    fileprivate let didPress = PublishSubject<Movie>()
    
    fileprivate let hitEnd = PublishSubject<Bool>()
    
    private var request : Observable<[String]> = .empty()
    
    private let disposeBag = DisposeBag()
    
    fileprivate var dataSource : [String] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "lbl_common_loading".localized)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        didPress
            .debounce(0.25, scheduler: MainScheduler.instance)  // prevent multiple click
            .subscribe(onNext: { [weak self] (movie) in
                // click on movie
                // openMovie
                self?.open(movie)
            }).disposed(by: disposeBag)
        
        hitEnd
            .subscribe(onNext: { [weak self](_) in
                self?.loadMore()
            }).disposed(by: disposeBag)
        
        MovieManager.shared
            .moviesPip
            .subscribe(onNext: { [weak self](movies) in
                guard let _self = self else {return}
                if _self.refreshControl.isRefreshing{
                    _self.refreshControl.endRefreshing()
                }
                _self.dataSource.append(contentsOf: movies)
                _self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let vc = MovieViewController()
        vc.bind(movieId: movie.id)
        self.present(vc, animated: true)
    }
    @objc private func reload(){
        self.dataSource.removeAll()
        self.tableView.reloadData()
        MovieManager.shared.reset()
        self.loadMore()
    }
    private func loadMore(){
        DebugUtil.log(level: .Info, domain: .API, message: "loadmore")
        MovieManager.shared.requestToggle.onNext(false)
    }

}
extension MovieListViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        let cnt = self.dataSource.count > 0 ? 1 : 0
        self.bShowEmptyView = cnt == 0 ? true : false
        return cnt
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieTableViewCell
        let data = self.dataSource[safe:indexPath.row]
        // enhance cell UI
        let movie = MovieManager.shared.getMovie(id: data)
        cell.bind(movie: movie)
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
        if let id = self.dataSource[safe: indexPath.row]{
            if let movie = MovieManager.shared.getMovie(id: id){
                didPress.onNext(movie)
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= dataSource.count - 5{   // almost reach bottom of table
            self.hitEnd.onNext(true)
        }
    }
}
