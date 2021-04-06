//
//  ComposableListViewController.swift
//  UIComposable
//
//  Created by NGUYEN CHI CONG on 4/6/21.
//

import UIKit

open class ComposableListViewController: UIViewController, ComposableInterface {
    public var composedElements: [UIElement] { elements }

    public func composeInterface(elements: [UIElement]) {
        self.elements = elements

        let pages = elements.compactMap { $0.contentViewController }
        viewControllers = pages

        tableView.reloadData()
    }

    public private(set) var elementSortRule: ((UIElement, UIElement) -> Bool)?

    public func setElementSortRule(_ sortRule: ((UIElement, UIElement) -> Bool)?) {
        elementSortRule = sortRule
    }

    private var elements: [UIElement] = []

    private var validElements: [UIElement] {
        elements.filter { $0.contentViewController != nil }
    }

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

    private lazy var dataSource = DataSource { [unowned self] _ -> Int in
        self.validElements.count
    } cellForRowAtIndexPath: { (tableView, indexPath) -> UITableViewCell in
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

        let model = self.validElements[indexPath.row]
        if let subView = model.contentViewController?.view {
            cell.contentView.addSubview(subView)

            subView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                subView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                subView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                subView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                subView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        }
        return cell
    }

    public private(set) lazy var tableView = UITableView()

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

extension ComposableListViewController {
    private func configureView() {
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        layoutTableView()

        tableView.dataSource = dataSource
    }
}

final class DataSource: NSObject, UITableViewDataSource {
    private let numberOfRows: (UITableView) -> Int
    private let cellForRowAtIndexPath: (UITableView, IndexPath) -> UITableViewCell

    init(numberOfRows: @escaping (UITableView) -> Int,
         cellForRowAtIndexPath: @escaping (UITableView, IndexPath) -> UITableViewCell) {
        self.numberOfRows = numberOfRows
        self.cellForRowAtIndexPath = cellForRowAtIndexPath
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows(tableView)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellForRowAtIndexPath(tableView, indexPath)
    }
}
