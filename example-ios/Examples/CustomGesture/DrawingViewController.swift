//
//  DrawingView.swift
//  example-ios
//
//  Created by Рафаэль Голубев on 11.01.2025.
//

import UIKit

class DrawingView: UIView {
    private var path = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.isMultipleTouchEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        path.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        path.addLine(to: point)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.stroke()
    }
    
    func clear() {
        path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    func getPath() -> UIBezierPath {
        return path
    }
    
    func getImageFromDrawingView() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { [weak self] context in
            guard let self = self else { return }
            UIColor.clear.setFill()
            context.fill(CGRect(origin: .zero, size: self.bounds.size))
            self.layer.render(in: context.cgContext)
        }
    }
}

class DrawingViewController: UIViewController {
    override func loadView() {
        title = "Drawing View"
        self.view = DrawingView()
        self.view.clearsContextBeforeDrawing = true
        
        guard let drawingView = self.view as? DrawingView else { return }
        
        let shareBarButton = UIBarButtonItem(
            title: "Отправить",
            image: .init(systemName: "square.and.arrow.up"),
            primaryAction: .init(handler: { action in
                
            }),
            menu: nil
        )
        
        let addButton = UIBarButtonItem(
            title: "Добавить",
            image: .init(systemName: "plus"),
            primaryAction: .init(handler: { action in
                
            }),
            menu: nil
        )
        
        let deleteBarButton = UIBarButtonItem(
            title: "Очистить",
            image: .init(systemName: "trash"),
            primaryAction: .init(handler: { [drawingView] action in
                drawingView.clear()
            }),
            menu: nil
        )
        deleteBarButton.tintColor = .systemRed
        
        self.toolbarItems = [
            shareBarButton,
            UIBarButtonItem.flexibleSpace(),
            addButton,
            UIBarButtonItem.flexibleSpace(),
            deleteBarButton,
        ]
        
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController:
        DrawingViewController()
    )
}
