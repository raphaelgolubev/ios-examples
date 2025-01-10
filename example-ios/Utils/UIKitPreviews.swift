//
//  UIKitPreviews.swift
//  example-ios
//
//  Created by Рафаэль Голубев on 10.01.2025.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

/// Позволяет просматривать `UIView` в SwiftUI_Previews
/// - Чтобы включить/выключить окно предпросмотра: `Xcode -> Editor -> Canvas`
///
/// Использование:
/// ```
/// final class MyView: UIView {
///     //...
/// }
///
/// // Поместите этот код в top-level файла
/// struct MyView_Previews: PreviewProvider {
///     static var previews: some View {
///         UIViewPreview {
///             MyView()
///         }
///     }
/// }
/// ```
@available(iOS 13.0, *)
public struct UIViewPreview<View: UIView>: UIViewRepresentable {
    public let view: View
    
    public init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: UIViewRepresentable
    public func makeUIView(context: Context) -> UIView {
        return view
    }
    
    public func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

/// Позволяет просматривать `UIViewController` в SwiftUI_Previews
/// - Чтобы включить/выключить окно предпросмотра: `Xcode -> Editor -> Canvas`
///
/// Использование:
/// ```
/// final class MyViewController: UIViewController {
///     //...
/// }
///
/// // Поместите этот код в top-level файла
/// struct MyViewController_Previews: PreviewProvider {
///     static var previews: some View {
///         UIViewControllerPreview {
///             MyViewController()
///         }
///     }
/// }
/// ```
@available(iOS 13.0, *)
public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {

    public let viewController: ViewController

    public init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    public func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
#endif
