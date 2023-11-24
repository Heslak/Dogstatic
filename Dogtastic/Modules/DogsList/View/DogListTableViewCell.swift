//
//  DogListTableViewCell.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import UIKit
import Combine

class DogListTableViewCell: UITableViewCell {
    
    static let cellName = "DogListTableViewCell"
    
    private lazy var dogImageView: UIImageView = {
        let dImageView = UIImageView()
        dImageView.translatesAutoresizingMaskIntoConstraints = false
        dImageView.layer.cornerRadius = 16.0
        dImageView.layer.masksToBounds = true
        return dImageView
    }()
    
    private lazy var conteinerView: UIView = {
        let iView = UIView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.layer.cornerRadius = 16.0
        iView.layer.masksToBounds = true
        iView.backgroundColor = .white
        return iView
    }()
    
    private lazy var dogInfoView: DogInfoView = {
        let dInfoView = DogInfoView()
        dInfoView.translatesAutoresizingMaskIntoConstraints = false
        return dInfoView
    }()
    
    private var subscribers = Set<AnyCancellable>()
    private var currentUrl: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(dogImageView)
        contentView.addSubview(conteinerView)
        contentView.addSubview(dogInfoView)
        contentView.bringSubviewToFront(dogImageView)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        dogImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                          constant: 15.0).isActive = true
        dogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: 15.0).isActive = true
        dogImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -15.0).isActive = true
        dogImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                            multiplier: 0.35).isActive = true
                
        conteinerView.topAnchor.constraint(equalTo: dogImageView.topAnchor,
                                           constant: 30.0).isActive = true
        conteinerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        conteinerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        conteinerView.bottomAnchor.constraint(equalTo: dogImageView.bottomAnchor).isActive = true
        
        dogInfoView.topAnchor.constraint(equalTo: conteinerView.topAnchor).isActive = true
        dogInfoView.leadingAnchor.constraint(equalTo: dogImageView.trailingAnchor).isActive = true
        dogInfoView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor).isActive = true
        dogInfoView.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dogImageView.image  = nil
    }
    
    func configure(dog: Dog) {
        dogInfoView.configure(dog: dog)
        currentUrl = dog.image
        ApiRest.shared.get(from: dog.image)?.sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] data in
            if self?.currentUrl == dog.image {
                self?.dogImageView.image = UIImage(data: data)
            }
        }).store(in: &subscribers)
    }
}
