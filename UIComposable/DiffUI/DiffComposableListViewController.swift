//
//  RxComposableListViewController.swift
//  UIComposable
//
//  Created by NGUYEN CHI CONG on 12/12/19.
//

import DiffableDataSources
import Foundation
import UIKit

extension UIElement: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

enum Section {
    case main
}

open class DiffComposableListViewController: UIViewController, ComposableInterface {
    private var elements: [UIElement] = []

    public var composedElements: [UIElement] { elements }

    public func composeInterface(elements: [UIElement]) {
        self.elements = elements

        let pages = elements.compactMap { $0.contentViewController }
        viewControllers = pages

        var snapshot = DiffableDataSourceSnapshot<Section, UIElement>()
        snapshot.appendSections([.main])
        snapshot.appendItems(elements.filter { $0.contentViewController != nil })

        dataSource.apply(snapshot) {
            // completion
        }
    }

    public private(set) var elementSortRule: ((UIElement, UIElement) -> Bool)?

    public func setElementSortRule(_ sortRule: ((UIElement, UIElement) -> Bool)?) {
        elementSortRule = sortRule
    }

    public private(set) lazy var tableView = UITableView()

    private lazy var dataSource: TableViewDiffableDataSource<Section, UIElement> = self.buildDataSource()

    private var viewControllers: [UIViewController] = [] {
        didSet {
            for item in oldValue {
                if !viewControllers.contains(item) {
                    item.removeFromParent()
                }
            }
            for item in viewControllers {
                if !oldValue.contains(item) {
                    addChild(item)
                }
            }
        }
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    open func layoutTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DiffComposableListViewController {
    private func configureView() {
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        layoutTableView()
    }

    private func buildDataSource() -> TableViewDiffableDataSource<Section, UIElement> {
        TableViewDiffableDataSource<Section, UIElement>(tableView: tableView) { tableView, _, model in
            let cellId = "ListViewCell"
            let cell: UITableViewCell
            if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellId) {
                cell = dequeuedCell
            } else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
            }
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }

            if let subView = model.contentViewController?.view {
                cell.contentView.addSubview(subView)

                NSLayoutConstraint.activate([
                    subView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    subView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                    subView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                ])
            }

            return cell
        }
    }
}
