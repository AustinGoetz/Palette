//
//  PaletteListViewController.swift
//  Palette
//
//  Created by Austin Goetz on 10/13/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class PaletteListViewController: UIViewController {
    
    // MARK: - Properties
    var photos: [UnsplashPhoto] = []
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var buttons: [UIButton] {
        return [featuredButton, randomButton, doubleRainbowButton]
    }

    // Step 2 - Add UI Elements to the view
    // MARK: - Lifecycles
    override func loadView() {
        super.loadView()
        // the advantage of doing this in loadView brings the views loading at an earlier process
        // Basically creates the views first, then we style them in the vDL after they have been loaded into the view here
        addAllSubviews()
        setUpButtonStackView()
        constrainPaletteTableView()
        configurePaletteTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "offWhite")
        activateButtons()
        UnsplashService.shared.fetchFromUnsplash(for: .featured) { (photos) in
            guard let photos = photos else { return }
            DispatchQueue.main.async {
                self.photos = photos
                self.paletteTableView.reloadData()
            }
        }
    }
    
    // MARK: - Class Functions
    func addAllSubviews() {
        self.view.addSubview(featuredButton)
        self.view.addSubview(randomButton)
        self.view.addSubview(doubleRainbowButton)
        self.view.addSubview(buttonStackView)
        self.view.addSubview(paletteTableView)
    }
    
    func setUpButtonStackView() {
        buttonStackView.addArrangedSubview(featuredButton)
        buttonStackView.addArrangedSubview(randomButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
        
        buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12).isActive = true
    }
    
    func constrainPaletteTableView() {
        paletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 0, trailingPadding: 0)
    }
    
    func configurePaletteTableView() {
        paletteTableView.delegate = self
        paletteTableView.dataSource = self
        paletteTableView.register(PaletteTableViewCell.self, forCellReuseIdentifier: "photoCell")
    }
    
    func activateButtons() {
        buttons.forEach { $0.addTarget(self, action: #selector(selectButton(sender:)), for: .touchUpInside) }
        featuredButton.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }
    
    @objc func selectButton(sender: UIButton) {
        buttons.forEach { $0.setTitleColor(.lightGray, for: .normal) }
        sender.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
        paletteTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        switch sender {
        case featuredButton:
            searchForCategory(unsplashRoute: .featured)
        case randomButton:
            searchForCategory(unsplashRoute: .random)
        case doubleRainbowButton:
            searchForCategory(unsplashRoute: .doubleRainbow)
        default:
            searchForCategory(unsplashRoute: .featured)
        }
    }
    
    func searchForCategory(unsplashRoute: UnsplashRoute) {
        UnsplashService.shared.fetchFromUnsplash(for: unsplashRoute) { (photos) in
            guard let photos = photos else { return }
            DispatchQueue.main.async {
                self.photos = photos
                self.paletteTableView.reloadData()
            }
        }
    }
    
    // Step 1 - Create UI Elements
    // MARK: - Views
    // Featured button
    let featuredButton: UIButton = {
        let button = UIButton()
        button.setTitle("Featured", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        
        return button
    }()

    // Random button
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Random", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        
        return button
    }()
    
    // Double Rainbow button
    let doubleRainbowButton: UIButton = {
       let button = UIButton()
        button.setTitle("Double Rainbow", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .center
        
        return button
    }()
    
    // Button stack view
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        // Stack view will not display if this is set to true (is by default)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let paletteTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
}

extension PaletteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PaletteTableViewCell else { return UITableViewCell() }
        
        
        let photo = photos[indexPath.row]
        cell.photo = photo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let outerVerticalSpacing: CGFloat = (2 * SpacingConstants.outerVerticalPadding)
        let labelSpace: CGFloat = SpacingConstants.smallElementHeight
        let objectBuffer: CGFloat = SpacingConstants.verticalObjectBuffer
        let colorViewSpace: CGFloat = SpacingConstants.mediumElementHeight
        let secondObjectBuffer: CGFloat = SpacingConstants.verticalObjectBuffer
        
        return imageViewSpace + outerVerticalSpacing + labelSpace + objectBuffer + colorViewSpace + secondObjectBuffer
    }
}
