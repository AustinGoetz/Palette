//
//  PaletteTableViewCell.swift
//  Palette
//
//  Created by Austin Goetz on 10/13/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {
    
    // MARK: - Class Properties
    var photo: UnsplashPhoto? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addAllSubviews()
        constrainPaletteImageView()
        constrainPaletteDescriptionLabel()
        constrainColorPaletteView()
    }

    // MARK: - Class Functions
    func updateViews() {        
        guard let photo = photo else { return }
        fetchAndSetImage(for: photo)
        fetchAndSetColorBlocks(for: photo)
        paletteDescriptionLabel.text = photo.description
    }
    
    func addAllSubviews() {
        self.addSubview(paletteImageView)
        self.addSubview(paletteDescriptionLabel)
        self.addSubview(colorPaletteView)
    }
    
    func constrainPaletteImageView() {
        let imageViewWidth = self.contentView.frame.width - (2 * SpacingConstants.outerHorizontalPadding)
        paletteImageView.anchor(top: self.contentView.topAnchor, bottom: nil, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, topPadding: SpacingConstants.outerVerticalPadding, bottomPadding: 0, leadingPadding: SpacingConstants.outerHorizontalPadding, trailingPadding: SpacingConstants.outerHorizontalPadding, width: imageViewWidth, height: imageViewWidth)
    }
    
    func constrainPaletteDescriptionLabel() {
        paletteDescriptionLabel.anchor(top: paletteImageView.bottomAnchor, bottom: nil, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, topPadding: SpacingConstants.verticalObjectBuffer, bottomPadding: 0, leadingPadding: SpacingConstants.outerHorizontalPadding, trailingPadding: SpacingConstants.outerHorizontalPadding, width: nil, height: SpacingConstants.smallElementHeight)
    }
    
    func constrainColorPaletteView() {
        colorPaletteView.anchor(top: paletteDescriptionLabel.bottomAnchor, bottom: self.contentView.bottomAnchor, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, topPadding: SpacingConstants.verticalObjectBuffer, bottomPadding: SpacingConstants.outerVerticalPadding, leadingPadding: SpacingConstants.outerHorizontalPadding, trailingPadding: SpacingConstants.outerHorizontalPadding, width: nil, height: SpacingConstants.mediumElementHeight)
    }
    
    func fetchAndSetImage(for unsplashPhoto: UnsplashPhoto) {
        UnsplashService.shared.fetchImage(for: unsplashPhoto) { (image) in
            DispatchQueue.main.async {
                self.paletteImageView.image = image
            }
        }
    }
    
    func fetchAndSetColorBlocks(for unsplashPhoto: UnsplashPhoto) {
        ImaggaService.shared.fetchColorsFor(imagePath: unsplashPhoto.urls.regular) { (colors) in
            guard let colors = colors else { return }
            DispatchQueue.main.async {
                self.colorPaletteView.colors = colors
            }
        }
    }
    
    // MARK: - Views
    let paletteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let paletteDescriptionLabel: UILabel = {
        let label = UILabel()

        return label
    }()
    
    let colorPaletteView: ColorPaletteView = {
        let paletteView = ColorPaletteView()
        
        return paletteView
    }()
}
