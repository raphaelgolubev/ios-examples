//
//  ConstraintBuilder.swift
//  example-ios
//
//  Created by Рафаэль Голубев on 06.01.2025.
//

import Foundation
import UIKit

@resultBuilder
struct ConstraintBuilder {
    typealias Constraint = NSLayoutConstraint
    
    static func buildBlock(_ constraints: Constraint...) -> [Constraint] {
        constraints
    }
}

public extension NSLayoutConstraint {
    func activate(_ constraints: NSLayoutConstraint...) {
        NSLayoutConstraint.activate(constraints)
    }
}

final class ConstraintBuilderExample {
    
    func makeConstraints() {
        let view = UIView()
        
        let constraints = NSLayoutConstraint.activate {
            view.topAnchor.constraint(equalTo: $0.topAnchor)
            view.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
        }
    }
}
