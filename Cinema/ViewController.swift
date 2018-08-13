//
//  ViewController.swift
//  Cinema
//
//  Created by Water Su on 2018/8/6.
//  Copyright © 2018年 iiwa-design. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] (_) in
            // TODO: prepare for splash screen or others
            self?.goNext()
        }
    }

    private func goNext(){
        let vc = MovieListViewController(nibName: "MovieListViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
}

