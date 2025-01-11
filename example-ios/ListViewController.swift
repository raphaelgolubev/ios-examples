//
//  ViewController.swift
//  example-ios
//
//  Created by Рафаэль Голубев on 06.01.2025.
//

import UIKit
import SwiftUI

final class ListViewController: UIViewController {
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Data Source
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<String, ListItem> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { [viewModel] cell, indexPath, listItem in
            var configutation = UIListContentConfiguration.cell()
            configutation.image = viewModel.cellImage(for: listItem)
            configutation.text = viewModel.cellTitle(for: listItem)
            cell.contentConfiguration = configutation
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { [viewModel] supplementaryView, elementKind, indexPath in
            var configutation = UIListContentConfiguration.header()
            configutation.text = viewModel.headerTitle(in: indexPath.section)
            configutation.secondaryText = viewModel.secondaryHeaderTitle(in: indexPath.section)
            supplementaryView.contentConfiguration = configutation
        }
        let dataSource = UICollectionViewDiffableDataSource<String, ListItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, listItem in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: listItem)
        })
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        return dataSource
    }
    
    private lazy var dataSource = makeDataSource()
    
    // MARK: Loading a View
    
    private func makeCollectionView() -> UICollectionView {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }
    
    private lazy var collectionView = makeCollectionView()
    
    override func loadView() {
        title = "My Examples"
        view = UIView(frame: .zero)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        viewModel.reloadContent(in: dataSource)
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listItem = dataSource.itemIdentifier(for: indexPath)
        // Обработка нажатия на ячейку
        print("Выбрана ячейка: \(listItem?.name ?? "неизвестно")")
        // Здесь вы можете выполнить переход на другой экран или выполнить другое действие
        
        if let controller = listItem?.viewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

extension ListViewController {
    @MainActor final class ViewModel {
        let listSections: [ListSection]
        
        init(listSections: [ListSection]) {
            self.listSections = listSections
        }
        
        func cellTitle(for listItem: ListItem) -> String {
            listItem.name
        }
        
        func cellImage(for listItem: ListItem) -> UIImage {
            var image = listItem.icon ?? UIImage(systemName: "xmark")!
            image = image.withRenderingMode(.alwaysOriginal)
            return image
        }
        
        func headerTitle(in section: Int) -> String {
            listSections[section].name
        }
        
        func secondaryHeaderTitle(in section: Int) -> String? {
            listSections[section].secondaryName
        }
        
        func reloadContent(in dataSource: UICollectionViewDiffableDataSource<String, ListItem>) {
            var snapshot = NSDiffableDataSourceSnapshot<String, ListItem>()
            snapshot.appendSections(listSections.map(\.name))
            listSections.forEach({ section in
                snapshot.appendItems(section.items, toSection: section.name)
            })
            dataSource.apply(snapshot)
        }
    }
}

struct ListSection: Hashable {
    let name: String
    let secondaryName: String
    let items: [ListItem]
    
    static let uikit = ListSection(name: "UIKit", secondaryName: "Пользовательский интерфейс", items: [
        ListItem(name: "Drawing View", icon: UIImage(systemName: "pencil"), viewController: DrawingViewController()),
    ])

    static let networking = ListSection(name: "Networking", secondaryName: "Работа с сетью", items: [
        ListItem(name: "Placeholder 3", icon: UIImage(systemName: "circle"), viewController: nil),
    ])
    
    static let metal = ListSection(name: "Metal", secondaryName: "Шейдеры", items: [
        ListItem(name: "Лупа", icon: UIImage(systemName: "magnifyingglass"), viewController:
                    UIHostingController(rootView: MagnificationLoupeShaderView())
        ),
        ListItem(name: "CD диск", icon: UIImage(systemName: "opticaldisc.fill"), viewController:
                    UIHostingController(rootView: CDShaderView())
        ),
        ListItem(name: "Mega Shader", icon: UIImage(systemName: "wave"), viewController:
                    UIHostingController(rootView: GradientShaderView())
        ),
    ])
}

struct ListItem: Hashable {
    let name: String
    let icon: UIImage?
    let viewController: UIViewController?
}

#Preview {
    UINavigationController(rootViewController:
        ListViewController(viewModel: ListViewController.ViewModel(
            listSections: [
                .uikit, .metal, .networking
            ]
        ))
    )
}
