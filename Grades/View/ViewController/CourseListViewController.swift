//
//  CourseListViewController.swift
//  Grades
//
//  Created by Jiří Zdvomka on 05/03/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import RxSwiftExt
import SwiftSVG
import UIKit

// TODO: add UI test
class CourseListViewController: UIViewController, BindableType {
	
	private var tableView: UITableView!
	
	var viewModel: CourseListViewModel!
    var bag = DisposeBag()

    let dataSource = CourseListViewController.dataSource()

    override func loadView() {
        super.loadView()

        navigationItem.title = L10n.Courses.title
		
		let tableView = UITableView()
		tableView.register(CourseListCell.self, forCellReuseIdentifier: "Cell")
		tableView.delegate = self
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		self.tableView = tableView
		
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl!.addTarget(self, action: #selector(refreshControlPulled(_:)), for: .valueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.bindOutput()
        tableView.refreshControl!.beginRefreshing() // TODO: find out better solution for initial load
    }

    func bindViewModel() {
        let courses = viewModel.courses.monitorLoading().share()

        viewModel.coursesError.asObservable()
            .subscribe(onNext: { [weak self] error in
                DispatchQueue.main.async {
                    self?.navigationController?.view.makeCustomToast(error?.localizedDescription,
                                                                     type: .danger,
                                                                     position: .center)
                }
            })
            .disposed(by: bag)

        courses
            .data()
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        courses
            .loading()
            .bind(to: tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: bag)
    }

    @objc private func refreshControlPulled(_: UIRefreshControl) {
        viewModel.bindOutput()
    }
}

extension CourseListViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<CourseGroup> {
        return RxTableViewSectionedReloadDataSource<CourseGroup>(
            configureCell: { _, tableView, indexPath, item in
                // swiftlint:disable force_cast
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CourseListCell
                cell.title.text = item.code
                cell.subtitle.text = "Název předmětu"
                cell.rightLabel.text = "15 b."
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].header
            }
        )
    }
}

extension CourseListViewController: UITableViewDelegate {
	func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
		return 90
	}
}
