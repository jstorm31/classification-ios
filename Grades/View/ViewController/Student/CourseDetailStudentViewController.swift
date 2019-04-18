//
//  CourseDetailStudentViewController.swift
//  Grades
//
//  Created by Jiří Zdvomka on 11/03/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

import Action
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class CourseDetailStudentViewController: BaseTableViewController, BindableType {
    var headerLabel: UILabel!
    var headerGradingOverview: UIGradingOverview!

    var viewModel: CourseDetailStudentViewModel!
    private let bag = DisposeBag()

    private var dataSource: RxTableViewSectionedReloadDataSource<GroupedClassification> {
        return RxTableViewSectionedReloadDataSource<GroupedClassification>(
            configureCell: { _, tableView, indexPath, item in
                // swiftlint:disable force_cast
                let cell = tableView.dequeueReusableCell(withIdentifier: "ClassificationCell", for: indexPath) as! ClassificationCell
                cell.classification = item
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].header
            }
        )
    }

    override func loadView() {
        super.loadView()
        loadView(hasTableHeaderView: true)
        loadRefreshControl()

        navigationItem.title = viewModel.courseCode
        tableView.register(ClassificationCell.self, forCellReuseIdentifier: "ClassificationCell")
        tableView.refreshControl?.addTarget(self, action: #selector(refreshControlPulled(_:)), for: .valueChanged)
        navigationController?.navigationBar.addSubview(UIView())

        loadUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeRightButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.bindOutput()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            viewModel.onBack.execute()
        }
    }

    func bindViewModel() {
        let classificationsObservable = viewModel.classifications.share()

        classificationsObservable
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        classificationsObservable
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
            .drive(showNoContent)
            .disposed(by: bag)

        viewModel.isFetching.asDriver(onErrorJustReturn: false)
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: bag)

        viewModel.error.asObserver()
            .subscribe(onNext: { [weak self] error in
                self?.navigationController?.view
                    .makeCustomToast(error?.localizedDescription, type: .danger, position: .center)
            })
            .disposed(by: bag)

        viewModel.totalPoints
            .unwrap()
            .map { "\($0) \(L10n.Courses.points)" }
            .asDriver(onErrorJustReturn: "")
            .drive(headerGradingOverview.pointsLabel.rx.text)
            .disposed(by: bag)

        viewModel.finalGrade
            .unwrap()
            .do(onNext: { [weak self] grade in
                self?.headerGradingOverview.gradeLabel.textColor = UIColor.Theme.setGradeColor(forGrade: grade)
            })
            .asDriver(onErrorJustReturn: "")
            .drive(headerGradingOverview.gradeLabel.rx.text)
            .disposed(by: bag)
    }

    @objc private func refreshControlPulled(_: UIRefreshControl) {
        viewModel.bindOutput()
    }

    private func loadUI() {
        let headerView = UIView()
        let containerView = UIView()
        headerView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Header label
        let header = UILabel()
        header.text = L10n.Classification.total
        header.font = UIFont.Grades.cellTitle
        header.textColor = UIColor.Theme.text
        containerView.addSubview(header)
        header.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        headerLabel = header

        let gradingOverview = UIGradingOverview()
        containerView.addSubview(gradingOverview)
        gradingOverview.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        headerGradingOverview = gradingOverview

        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(42)
        }
    }
}

extension CourseDetailStudentViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }
}
