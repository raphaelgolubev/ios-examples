//
//  ConstraintBuilder.swift
//  example-ios
//
//  Created by Рафаэль Голубев on 06.01.2025.
//

import Foundation
import UIKit

@resultBuilder
public struct ConstraintBuilder {
    public typealias Constraint = NSLayoutConstraint
    
    public static func buildBlock(_ components: [Constraint]...) -> [Constraint] {
        components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: Constraint) -> [Constraint] {
        [expression]
    }
    
    public static func buildExpression(_ expression: [Constraint]) -> [Constraint] {
        expression
    }
    
    // Поддержка опциональных значений
    public static func buildOptional(_ component: [Constraint]?) -> [Constraint] {
        component ?? []
    }
    
    // Поддержка условий
    public static func buildEither(first components: [Constraint]) -> [Constraint] {
        components
    }
    
    public static func buildEither(second components: [Constraint]) -> [Constraint] {
        components
    }
    
    // Поддержка циклов
    public static func buildArray(_ components: [[Constraint]]) -> [Constraint] {
        components.flatMap { $0 }
    }
    
    // Поддержка условий #available
    public static func buildLimitedAvailability(_ components: [Constraint]) -> [Constraint] {
        components
    }
}

public extension NSLayoutConstraint {
    static func activate(@ConstraintBuilder _ constraints: () -> [NSLayoutConstraint]) {
        activate(constraints())
    }
}

protocol SubviewContaining { }
extension UIView: SubviewContaining { }

extension SubviewContaining where Self == UIView {
    
    /// Добавляет новое представление в иерархию и активирует констрейнты.
    /// Для текущего представления и представления, которое будет добавлено свойство
    /// `translatesAutoresizingMaskIntoConstraints` устанавливается в значение `false`.
    /// - Parameters:
    ///   - view: Представление, которое необходимо добавить в иерархию.
    ///   - constraints: замыкание `resultBuilder`, в котором настраиваются констрейнты.
    ///
    /// - Пример:
    /// ```swift
    /// let view = UIView()
    /// let view2 = UILabel()
    ///
    /// view.addSubview(view2) { superview, newView in
    ///     if newView.numberOfLines == 0 {
    ///         newView.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.5)
    ///     }
    ///
    ///     newView.topAnchor.constraint(equalTo: superview.topAnchor)
    /// }
    /// ```
    func addSubview<View: UIView>(_ view: View, @ConstraintBuilder constraints: (Self, View) -> [NSLayoutConstraint]) {
        // Автоматический отключаем для текущего и добавляемого представления
        self.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        // Добавляем представление
        addSubview(view)
        // Активируем констрейнты
        NSLayoutConstraint.activate(constraints(self, view))
    }
}

//final class ConstraintBuilderExample {
//    func makeConstraints() {
//        let view = UIView()
//        let view2 = UILabel()
//        
//        view.addSubview(view2) { superview, newView in
//            if newView.numberOfLines == 0 {
//                newView.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.5)
//            }
//            newView.topAnchor.constraint(equalTo: superview.topAnchor)
//        }
//        view.addSubview(view2) { superview, newView in
//            
//        }
//    }
//}
