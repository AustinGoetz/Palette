//
//  ColorPaletteView.swift
//  Palette
//
//  Created by Austin Goetz on 10/13/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class ColorPaletteView: UIView {

    // MARK: - Class Properties
    var colors: [UIColor]? {
        didSet {
            buildColorBlocks()
        }
    }
    
    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpViews()
    }
    
    // MARK: - Class Functions
    func setUpViews() {
        self.addSubview(colorStackView)
        colorStackView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 0, trailingPadding: 0)
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
    }
    
    func buildColorBlocks() {
        resetStackView()
        guard let colors = colors else { return }
        for color in colors {
            let colorBlock = generateColorBlock(for: color)
            self.addSubview(colorBlock)
            self.colorStackView.addArrangedSubview(colorBlock)
        }
        self.layoutIfNeeded()
    }
    
    func generateColorBlock(for color: UIColor) -> UIView {
        let colorBlock = UIView()
        colorBlock.backgroundColor = color
        
        return colorBlock
    }
    
    func resetStackView() {
        for subview in colorStackView.arrangedSubviews {
            self.colorStackView.removeArrangedSubview(subview)
        }
    }
    
    // MARK: - Views
    let colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()

}
