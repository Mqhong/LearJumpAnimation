//
//  JoumpView.swift
//  LearJumpAnimation
//
//  Created by mm on 2017/5/17.
//  Copyright © 2017年 mm. All rights reserved.
//

import UIKit

class JoumpView: UIViewController {

    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        
        self.view.backgroundColor = UIColor.orange
        let backbtn = UIButton()
        backbtn.frame = CGRect(x: 0, y: 300, width: 100, height: 100)
        backbtn.backgroundColor = UIColor.green
        backbtn .addTarget(self, action: #selector(JoumpView.back), for: .touchUpInside)
        backbtn.setTitle("back", for: .normal)
        backbtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(backbtn)
        self.title = "detail"
        
        self.imageView.frame = CGRect(x: 0, y: 30, width: self.view.bounds.size.width, height: 124)
//        self.imageView.center = CGPoint(x: 60, y: 200)
        self.imageView.image = UIImage(named: "movie")
        self.view.addSubview(self.imageView)
        
        
    }
    
    //MARK: back
    func back() -> Void {
        self.dismiss(animated: true, completion: nil)
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

}
