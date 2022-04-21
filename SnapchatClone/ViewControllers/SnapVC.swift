//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Mehmet Bilir on 21.04.2022.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {
    
    var chosenSnap : Snap?
    var inputArray = [KingfisherSource]()
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snap = chosenSnap {
            timeLabel.text = "Time left : \(snap.timeDifference)"
            
            for image in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: image)!)
            }
        }
        
        let imageSlideshow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.90, height: self.view.frame.height * 0.9))
        imageSlideshow.backgroundColor = .white
        let pageIndicator = UIPageControl()
        pageIndicator.pageIndicatorTintColor = .black
        pageIndicator.currentPageIndicatorTintColor = .gray
        imageSlideshow.pageIndicator = pageIndicator
        imageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        
        imageSlideshow.setImageInputs(inputArray)
        view.addSubview(imageSlideshow)
        view.bringSubviewToFront(timeLabel)
        
        
        
        
    }
    
    


}
