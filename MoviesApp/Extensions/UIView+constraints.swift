//
//  UIView+constraints.swift
//  MoviesApp
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import UIKit

extension UIView {
    func fill(superview: UIView) {
        constraintVertically(to: superview)
        constraintHorizontally(to: superview)
    }

    func constraintVertically(to view: UIView, constant: CGFloat = 0) {
        topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
    }

    func constraintHorizontally(to view: UIView, constant: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
    }
}
