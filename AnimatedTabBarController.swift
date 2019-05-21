//
//  AnimatedTabBarController.swift
//  what ever
//
//  Created by Alfredo Uzumaki on 2/13/1397 AP.
//

import UIKit

class AnimatedTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var previousItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let items = tabBar.items else { return }
        for i in 0..<items.count {
            tabBar.items![i].imageInsets.top = 15
            deselectItem(self.tabBar, i)
        }
        DispatchQueue.main.async {
            self.selectItem(self.tabBar, 0)
            for i in 1..<self.tabBar.items!.count {
                self.deselectItem(self.tabBar, i)
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for i in 0..<tabBar.items!.count {
            if tabBar.items![i].title == item.title {
                DispatchQueue.main.async {
                    self.selectItem(tabBar, i)
                }
            } else {
                DispatchQueue.main.async {
                    self.deselectItem(tabBar, i)
                }
            }
        }
    }
    
    func selectItem(_ tabBar:UITabBar, _ index: Int) {
        if let item = tabBar.subviews[index + 1].subviews.filter({$0.isKind(of: UILabel.self)}).first {
            let imageView = tabBar.subviews[index + 1].subviews.filter({$0.isKind(of: UIImageView.self)}).first! as! UIImageView
            if let label = item as? UILabel {
                if self.previousItem != label.text {
                    makeIconSmallAnimation(label, imageView, tabBar)
                }
                self.previousItem = label.text!
            }
        }
    }
    
    func deselectItem(_ tabBar:UITabBar, _ index: Int) {
        if let item = tabBar.subviews[index + 1].subviews.filter({$0.isKind(of: UILabel.self)}).first {
            let imageView = tabBar.subviews[index + 1].subviews.filter({$0.isKind(of: UIImageView.self)}).first! as! UIImageView
            if let label = item as? UILabel {
                makeIconLargeAnimation(label, imageView, tabBar)
            }
        }
    }
    
    func makeIconSmallAnimation(_ label: UILabel, _ imageView:UIImageView, _ tabBar:UITabBar) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            label.transform = CGAffineTransform(scaleX: 1, y: 1)
            imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            imageView.contentMode = .scaleAspectFill
            let y = (tabBar.frame.height / 2) + 5
            label.frame = CGRect(origin: CGPoint(x: y, y: y), size: CGSize(width: Int(tabBar.frame.width / CGFloat(tabBar.items!.count)), height: 15))
            label.textAlignment = .center
            tabBar.layoutIfNeeded()
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.makeIconLargeAnimation(label, imageView, tabBar)
            })
        }
    }
    
    func makeIconLargeAnimation(_ label: UILabel, _ imageView:UIImageView, _ tabBar:UITabBar) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            label.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            imageView.transform = .identity
            imageView.contentMode = .scaleAspectFill
            imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            tabBar.layoutIfNeeded()
        }) { (_) in
        }
    }
}

