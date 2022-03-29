//
//  TitleBarController.swift
//  Spotify
//
//  Created by Alperen Selçuk on 8.02.2022.
//  Copyright © 2022 Alperen Selçuk. All rights reserved.
//

import UIKit

class MusicViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

class PodcastViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }

}

class TitleBarController: UIViewController {

    var musicBarButtonItem: UIBarButtonItem!
    var podcaseBarButtonItem: UIBarButtonItem!
    
    let container = Container()
    
    let viewControllers: [UIViewController] = [HomeController(), HomeController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItems = [musicBarButtonItem, podcaseBarButtonItem]
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupViews() {
        guard let containerView = container.view else { return }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemPink
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        musicTapped()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        musicBarButtonItem = makeBarButtonItem(text: "Music", selector: #selector(musicTapped))
        podcaseBarButtonItem = makeBarButtonItem(text: "Podcase", selector: #selector(podcaseTapped))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeBarButtonItem(text: String, selector: Selector) -> UIBarButtonItem {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: selector, for: .primaryActionTriggered)
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle).withTraits(traits: [.traitBold]), //buraya withTraits gelecek
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
         
        button.setAttributedTitle(attributedText, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 16)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        
        return barButtonItem
    }
}

//MARK: selectors
extension TitleBarController {
    @objc func musicTapped() {
        if container.children.first == viewControllers[0] { return }
        container.add(viewControllers[0])
        
        animateTransition(fromVC: viewControllers[1], toVC: viewControllers[0]) { (succes) in
            self.viewControllers[1].remove()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.musicBarButtonItem.customView?.alpha = 1.0
            self.podcaseBarButtonItem.customView?.alpha = 0.5
        }
        
    }
    
    @objc func podcaseTapped() {
        if container.children.first == viewControllers[1] { return }
        
        container.add(viewControllers[1])
        
        animateTransition(fromVC: viewControllers[0], toVC: viewControllers[1]) { (succes) in
            self.viewControllers[0].remove()
        }
        UIView.animate(withDuration: 0.5) {
            self.musicBarButtonItem.customView?.alpha = 0.5
            self.podcaseBarButtonItem.customView?.alpha = 1.0
        }

    }
}

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let description = fontDescriptor.withSymbolicTraits(traits)
        
        return UIFont(descriptor: description!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension TitleBarController {
    
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, completion: @escaping((Bool) -> Void)) {
        guard
            let fromView    = fromVC.view,
            let fromIndex   = getIndex(forViewController: fromVC),
            let toView      = toVC.view,
            let toIndex     = getIndex(forViewController: toVC)
            else {
                return
        }
    
        let frame = fromVC.view.frame
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        UIView.animate(withDuration: 0.5, animations: {
            fromView.frame  = fromFrameEnd
            toView.frame   = frame
        }, completion: { success in
            completion(success)
        })
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int?{
        for (index, thisVC) in viewControllers.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
