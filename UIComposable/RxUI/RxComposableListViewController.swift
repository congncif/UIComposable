//
//  RxComposableListViewController.swift
//  UIComposable
//
//  Created by NGUYEN CHI CONG on 12/12/19.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

extension UIElement: IdentifiableType {
    public var identity: String {
        return identifier
    }
}

open class RxComposableListViewController: UIViewController, ComposableInterface {
    private var elements: [UIElement] = []

    public var composedElements: [UIElement] { elements }

    public func composeInterface(elements: [UIElement]) {
        self.elements = elements

        let pages = elements.compactMap { $0.contentViewController }
        viewControllers = pages

        displayItems.accept(elements.filter { $0.contentViewController != nil })
    }

    public private(set) var elementSortRule: ((UIElement, UIElement) -> Bool)?

    public func setElementSortRule(_ sortRule: ((UIElement, UIElement) -> Bool)?) {
        elementSortRule = sortRule
    }

    private typealias Section = AnimatableSectionModel<Int, UIElement>
    private typealias DataSource = RxTableViewSectionedAnimatedDataSource<Section>

    public private(set) lazy var tableView = UITableView()

    private lazy var dataSource: DataSource = self.buildDataSource()
    private let displayItems = BehaviorRelay<[UIElement]>(value: [])
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

    private let disposeBag = DisposeBag()

    override open func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configurePresenter()
    }
}

extension RxComposableListViewController {
    private func configureView() {
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func buildDataSource() -> DataSource {
        let animationConfiguration = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic)
        let transition: DataSource.DecideViewTransition = { _, _, _ in .reload }

        return DataSource(
            animationConfiguration: animationConfiguration,
            decideViewTransition: transition,
            configureCell: { (_, tableView, _, model) -> UITableViewCell in
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
                    subView.snp.makeConstraints { maker in
                        maker.edges.equalToSuperview()
                    }
                }

                return cell
            }
        )
    }

    private func configurePresenter() {
        displayItems
            .map { [Section(model: 0, items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
