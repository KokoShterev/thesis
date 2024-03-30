//
//  CommentTableViewCell.swift
//  thesis
//
//  Created by Constantine Shterev on 28.03.24.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "commentCell"

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // Allow multiline comments
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentTextLabel)

        usernameLabel.backgroundColor = .systemBackground
        commentTextLabel.backgroundColor = .systemBackground

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        commentTextLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            commentTextLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            commentTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with comment: Comment) {
        usernameLabel.text = "\(comment.username):"
        commentTextLabel.text = comment.text
        
        print("Username: \(comment.username), Comment: \(comment.text)")
    }
}
