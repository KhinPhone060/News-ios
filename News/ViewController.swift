//
//  ViewController.swift
//  News
//
//  Created by Khin Phone Ei on 02/02/2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var BreakingNewsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //register cell
        let cellNib = UINib(nibName: "BreakingNewsCollectionViewCell", bundle: nil)
        BreakingNewsCollectionView.register(cellNib, forCellWithReuseIdentifier: "BreakingNewsCollectionViewCell")
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakingNewsCollectionViewCell", for: indexPath) as! BreakingNewsCollectionViewCell
        return cell
    }
    
}

