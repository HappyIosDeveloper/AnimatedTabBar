//
//  AnimatedTabBarController.swift
//  what ever
//
//  Created by Alfredo Uzumaki on 2/13/1397 AP.
//

import UIKit

class AnimatedTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var titles = [String]()
    var newlyTapped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let items = tabBar.items else { return }
        for i in 0..<items.count {
            titles.append(items[i].title!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.cleanTitles(animation: false)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let secondItemView = self.tabBar.subviews[self.selectedIndex + 1]
        for i in 0..<secondItemView.subviews.count {
            if let label = secondItemView.subviews[i] as? UILabel {
                DispatchQueue.main.async {
                    if label.text! == self.titles[self.selectedIndex] {
                        self.newlyTapped = false
                        label.transform = .identity
                        label.layer.position.y = 0
                    }
                    label.text = ""
                    self.newlyTapped = true
                }
            }
        }
        DispatchQueue.main.async {
            if self.newlyTapped {
                if item == (self.tabBar.items as! [UITabBarItem])[0]{
                    self.tabSelected(index: 0)
                } else if item == (self.tabBar.items as! [UITabBarItem])[1] {
                    self.tabSelected(index: 1)
                } else if item == (self.tabBar.items as! [UITabBarItem])[2] {
                    self.tabSelected(index: 2)
                } else if item == (self.tabBar.items as! [UITabBarItem])[3] {
                    self.tabSelected(index: 3)
                } else {
                    return
                }
            } else {
                self.cleanTitles(animation: false)
            }
        }
    }
    
    
    func tabSelected(index: Int) {
        let secondItemView = self.tabBar.subviews[index+1]
        let secondItemImageView = secondItemView.subviews.first as! UIImageView
        var myLabel = UILabel()
        secondItemImageView.contentMode = .center
        for i in 0..<secondItemView.subviews.count {
            if let label = secondItemView.subviews[i] as? UILabel {
                myLabel = UILabel()
                myLabel = label
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { () -> Void in
            secondItemImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.cleanTitles(animation: false)
            myLabel.text = self.titles[index]
            myLabel.layer.position.y = 0
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    secondItemImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    DispatchQueue.main.async {
                        self.cleanTitles(animation: true)
                    }
                })
            })
        })
    }
    
    func cleanTitles(animation: Bool) {
        for j in 0..<self.tabBar.subviews.count {
            let secondItemView = self.tabBar.subviews[j]
            let secondItemImageView = secondItemView.subviews.first as! UIImageView
            secondItemImageView.contentMode = .center
            for i in 0..<secondItemView.subviews.count {
                if let label = secondItemView.subviews[i] as? UILabel {
                    if animation {
                        UIView.animate(withDuration: 0.5, animations:  {
                            label.layer.position.y = 100
                        })
                    } else {
                        label.layer.position.y = 100
                    }
                }
            }
        }
    }
}
