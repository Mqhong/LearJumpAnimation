//
//  ViewController.swift
//  LearJumpAnimation
//
//  Created by mm on 2017/5/17.
//  Copyright © 2017年 mm. All rights reserved.
//

import UIKit


class CollectionCell: UICollectionViewCell{
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
}

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    var imageMaskTransition : ImageMaskTransition?
    var useModalPresent = true
    var nowClassName = [String]()
    var surplusClassName = [String]()
    
    var collectionView:UICollectionView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.view.backgroundColor = UIColor.red
        self._initBtn()
        self.title = "Main";
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
//        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        //注册一个cell
        collectionView?.register(CollectionCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView!)
    }


    
    //MARK: 代理
    //每个区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40;
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCell
        cell.imageView.image = UIImage(named: "movie")
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了这个fuck:\(indexPath.row)")
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionCell
        
        let dvc = JoumpView()
        let config = TransitionConfig.defaultConfig(fromImageView: cell.imageView, toImageView: dvc.imageView)
        self.imageMaskTransition = ImageMaskTransition(config: config)
        if useModalPresent {
            dvc.transitioningDelegate = self.imageMaskTransition
            present(dvc,animated: true, completion: nil)
        }else{
            self.navigationController?.delegate = self.imageMaskTransition
            self.navigationController?.pushViewController(dvc, animated: true)
        }
    }
    
    
    func _initBtn() -> Void {
        let Btn = UIButton(frame: CGRect(x: 100, y: 0, width: 100, height: 100))
        Btn.backgroundColor = UIColor.blue
        Btn.setTitle("跳啊", for: .normal)
        Btn.setTitleColor(UIColor.black, for: .normal)
        self.view .addSubview(Btn)
        Btn.addTarget(self, action: #selector(ViewController.Jump), for: .touchUpInside)
    }
    
    func Jump() -> Void {
        let jumpvc = JoumpView()
        let nava = UINavigationController(rootViewController: jumpvc);
        self.present(nava, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

