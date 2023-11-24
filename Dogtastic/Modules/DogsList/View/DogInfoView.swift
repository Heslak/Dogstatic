//
//  DogInfoView.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import UIKit

class DogInfoView: UIView {
    
    private lazy var dogNameLabel: UILabel = {
        let dNameLabel = UILabel()
        dNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dNameLabel.font = .systemFont(ofSize: 22.0)
        dNameLabel.textColor = .dogBlack
        dNameLabel.numberOfLines = 1
        return dNameLabel
    }()
    
    private lazy var dogDescriptionLabel: UILabel = {
        let dDescriptionLabel = UILabel()
        dDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dDescriptionLabel.font = .systemFont(ofSize: 15.0)
        dDescriptionLabel.textColor = .dogGrey
        dDescriptionLabel.numberOfLines = 0
        dDescriptionLabel.textAlignment = .justified
        return dDescriptionLabel
    }()
    
    private lazy var dogAgeLabel: UILabel = {
        let dAgeLabel = UILabel()
        dAgeLabel.translatesAutoresizingMaskIntoConstraints = false
        dAgeLabel.font = .systemFont(ofSize: 15.0)
        dAgeLabel.textColor = .dogBlack
        dAgeLabel.numberOfLines = 1
        return dAgeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(dogNameLabel)
        addSubview(dogDescriptionLabel)
        addSubview(dogAgeLabel)
        
        dogNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0).isActive = true
        dogNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0).isActive = true
        dogNameLabel.heightAnchor.constraint(equalToConstant: 26.5).isActive = true
        dogNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        dogDescriptionLabel.topAnchor.constraint(equalTo: dogNameLabel.bottomAnchor,
                                          constant: 10.0).isActive = true
        dogDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0).isActive = true
        dogDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dogDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: dogAgeLabel.topAnchor,
                                                    constant: -15).isActive = true
        
        dogAgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        dogAgeLabel.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        dogAgeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dogAgeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.0).isActive = true
    }
    
    func configure(dog: Dog) {
        dogNameLabel.text = dog.dogName
        dogDescriptionLabel.text = dog.description
        dogAgeLabel.text = "Almost \(dog.age) years"
    }
}
