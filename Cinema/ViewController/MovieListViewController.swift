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
    fileprivate var currentPage = 1
    
    fileprivate var bShowEmptyView : Bool = false{
        didSet{
            self.emptyView?.isHidden = !bShowEmptyView
        }
    }
    private lazy var emptyView : EmptyView? = {
        if let view = EmptyView.loadFromXib(){
            view.bind(type: .MovieList)
            self.view.addSubview(view)
            view.fit(self.view)
            return view
        }
        return nil
    }()
    
    fileprivate let loadMoreToggle = PublishSubject<Int>()
    
    fileprivate let didPress = PublishSubject<Movie>()
    
    private let disposeBag = DisposeBag()
    
    fileprivate var dataSource : [Movie] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "lbl_common_loading".localized)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.requestAPI(currentPage)
        
        didPress
            .debounce(0.25, scheduler: MainScheduler.instance)  // prevent multiple click
            .subscribe(onNext: { [weak self] (movie) in
                // click on movie
                // openMovie
                self?.open(movie)
            }).disposed(by: disposeBag)
        
        loadMoreToggle
            .distinctUntilChanged() // prevent load same page twice
            .subscribe(onNext: { [weak self] (page) in
                self?.requestAPI(page)
            }).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func requestAPI(_ page : Int){
        DebugUtil.log(level: .Info, domain: .API, message: "get page \(page)")
        
        APIManager.getMovieList(page: page)
            .subscribe(onNext: { [weak self] (response, json) in
                
                if let refresh = self?.refreshControl, refresh.isRefreshing{
                    refresh.endRefreshing()
                }
                
                guard let json = json as? [String : Any] else {return} // handle format error
                
                if let datas = json["results"] as? [[String: Any]]{
                    self?.dataSource.append(contentsOf: MovieManager.shared.parse(data: datas))
                    self?.tableView.reloadData()
                }
                if let page = json["page"] as? Int{
                    self?.currentPage = page
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
    @objc private func reload(){
        self.dataSource.removeAll()
        self.tableView.reloadData()
        self.loadMoreToggle.onNext(0)   // to reset distinctuntil change
        self.loadMoreToggle.onNext(1)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= dataSource.count - 3{   // almost reach bottom of table
            self.loadMoreToggle.onNext(currentPage + 1)
        }
    }
}
