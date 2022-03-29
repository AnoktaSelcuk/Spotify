//
//  MenuBar.swift
//  Spotify
//
//  Created by Alperen Selçuk on 9.02.2022.
//  Copyright © 2022 Alperen Selçuk. All rights reserved.
//

import Foundation
import UIKit

protocol MenuBarDelegate: AnyObject {
    func didSelectItemAt(index: Int)
}


class MenuBar: UIView {
    
    let playListsButton: UIButton!
    let artistButton: UIButton!
    let albumsButton: UIButton!
    var buttons: [UIButton]!
    
    //slider indicator
    let indicator = UIView()
    var indicatorLeading: NSLayoutConstraint?
    var indicatorTrailing: NSLayoutConstraint?
    
    let leadPadding: CGFloat = 16
    let buttonSpace: CGFloat = 36
    
    weak var delegate: MenuBarDelegate?
    
    override init(frame: CGRect) {

        playListsButton = makeButton(withText: "Playlists")
        artistButton    = makeButton(withText: "Artist")
        albumsButton    = makeButton(withText: "Album")
        
        buttons = [playListsButton, artistButton, albumsButton]
        
        super.init(frame: .zero)

        playListsButton.addTarget(self, action: #selector(playListsButtonTapped), for: .primaryActionTriggered)
        artistButton.addTarget(self, action: #selector(artistButtonTapped), for: .primaryActionTriggered)
        albumsButton.addTarget(self, action: #selector(albumsButtonTapped), for: .primaryActionTriggered)
        
        styleIndicator()
        setAlpha(for: playListsButton)
        layout()
    }
    
    private func styleIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .spotifyGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(playListsButton)
        addSubview(artistButton)
        addSubview(albumsButton)
        addSubview(indicator)
        
        NSLayoutConstraint.activate([
            //Buttons
            playListsButton.topAnchor.constraint(equalTo: topAnchor),
            playListsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadPadding),
            artistButton.topAnchor.constraint(equalTo: topAnchor),
            artistButton.leadingAnchor.constraint(equalTo: playListsButton.trailingAnchor, constant: buttonSpace),
            albumsButton.topAnchor.constraint(equalTo: topAnchor),
            albumsButton.leadingAnchor.constraint(equalTo: artistButton.trailingAnchor, constant: buttonSpace),
            
            //bar (indicator)
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        indicatorLeading    = indicator.leadingAnchor.constraint(equalTo: playListsButton.leadingAnchor)
        indicatorTrailing   = indicator.trailingAnchor.constraint(equalTo: playListsButton.trailingAnchor)
        
        indicatorLeading?.isActive  = true
        indicatorTrailing?.isActive = true
    }
} //MenuBar class end

func makeButton(withText text: String) -> UIButton {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    
    return button
}

//MARK: Objc method
extension MenuBar {
    
    @objc func playListsButtonTapped() {
        delegate?.didSelectItemAt(index: 0)
    }
    
    @objc func artistButtonTapped() {
        delegate?.didSelectItemAt(index: 1)
    }
    
    @objc func albumsButtonTapped() {
        delegate?.didSelectItemAt(index: 2)
    }
}

extension MenuBar {
    func selectItem(at index: Int) {
        animateIndicator(to: index)
    }
    
    private func animateIndicator(to index: Int) {
        var button: UIButton
        switch index {
        case 0:
            button = playListsButton
        case 1:
            button = artistButton
        case 2:
            button = albumsButton
        default:
            button = playListsButton
        }
        
        setAlpha(for: button)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func setAlpha(for button: UIButton) {
        playListsButton.alpha   = 0.5
        artistButton.alpha      = 0.5
        albumsButton.alpha      = 0.5
        
        button.alpha = 1
    }
    
       func scrollIndicator(to contentOffset: CGPoint) {
        let index = Int(contentOffset.x / frame.width)
        let atScrollStart = Int(contentOffset.x) % Int(frame.width) == 0
        
        if atScrollStart {
            return
        }
        
        let percentScrolled: CGFloat
        switch index {
        case 0:
             percentScrolled = contentOffset.x / frame.width - 0
        case 1:
            percentScrolled = contentOffset.x / frame.width - 1
        case 2:
            percentScrolled = contentOffset.x / frame.width - 2
        default:
            percentScrolled = contentOffset.x / frame.width
        }
        
        // determine buttons
        var fromButton: UIButton
        var toButton: UIButton
        
        switch index {
        case 2:
            fromButton = buttons[index]
            toButton = buttons[index - 1]
        default:
            fromButton = buttons[index]
            toButton = buttons[index + 1]
        }
        
        // animate alpha of buttons
        switch index {
        case 2:
            break
        default:
            fromButton.alpha = fmax(0.5, (1 - percentScrolled))
            toButton.alpha = fmax(0.5, percentScrolled)
        }
        
        let fromWidth = fromButton.frame.width
        let toWidth = toButton.frame.width
        
        // determine width
        let sectionWidth: CGFloat
        switch index {
        case 0:
            sectionWidth = leadPadding + fromWidth + buttonSpace
        default:
            sectionWidth = fromWidth + buttonSpace
        }

        // normalize x scroll
        let sectionFraction = sectionWidth / frame.width
        let x = contentOffset.x * sectionFraction
        
        let buttonWidthDiff = fromWidth - toWidth
        let widthOffset = buttonWidthDiff * percentScrolled

        // determine leading y
        let y:CGFloat
        switch index {
        case 0:
            if x < leadPadding {
                y = x
            } else {
                y = x - leadPadding * percentScrolled
            }
        case 1:
            y = x + 13
        case 2:
            y = x
        default:
            y = x
        }
        

        indicatorLeading?.constant = y

        let yTrailing: CGFloat
        switch index {
        case 0:
            yTrailing = y - widthOffset
        case 1:
            yTrailing = y - widthOffset - leadPadding
        case 2:
            yTrailing = y - widthOffset - leadPadding / 2
        default:
            yTrailing = y - widthOffset - leadPadding
        }
        
        indicatorTrailing?.constant = yTrailing
        
        print("\(index) percentScrolled=\(percentScrolled)")
    }
    
}



