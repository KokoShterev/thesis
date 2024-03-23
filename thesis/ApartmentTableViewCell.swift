//
//  ApartmentTableViewCell.swift
//  diplomna
//
//  Created by Constantine Shterev on 13.02.24.
//

import UIKit

class ApartmentTableViewCell: UITableViewCell {
    
//     UI Elements
//    private let apartmentImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true // Ensure images fit within the view
//        return imageView
//    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
        
    // Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(apartmentImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(priceLabel)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Layout Configuration
    private func configureLayout() {
//        apartmentImageView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            apartmentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
//            apartmentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            apartmentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            apartmentImageView.widthAnchor.constraint(equalToConstant: 80),
//            apartmentImageView.heightAnchor.constraint(equalToConstant: 80),

//            locationLabel.leadingAnchor.constraint(equalTo: apartmentImageView.trailingAnchor, constant: 10),
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

//            priceLabel.leadingAnchor.constraint(equalTo: apartmentImageView.trailingAnchor, constant: 10),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    // Data Population
    func configure(with apartment: Apartment) {
//        if let imageUrl = apartment.photos.first {
//            apartmentImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(systemName: "photo"))
//        }
//        apartmentImageView.image = apartment.photos.first
        locationLabel.text = apartment.location
        priceLabel.text = "$\(apartment.pricePerNight) / night"
    }
}
