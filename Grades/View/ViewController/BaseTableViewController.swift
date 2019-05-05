//
//  BaseTableViewController.swift
//  Grades
//
//  Created by Jiří Zdvomka on 13/03/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class BaseTableViewController: BaseViewController {
    var noContentLabel: UILabel!
    private let bag = DisposeBag()

    var tableView: UITableView!

    override func loadView() {
        super.loadView()

        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        self.tableView = tableView

        let noContentLabel = UILabel()
        noContentLabel.text = L10n.Labels.noContent
        noContentLabel.font = UIFont.Grades.body
        noContentLabel.textColor = UIColor.Theme.grayText
        noContentLabel.isHidden = true
        view.addSubview(noContentLabel)
        noContentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.noContentLabel = noContentLabel
    }

    override func viewWillAppear(_: Bool) {
        if let tableView = self.tableView, let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }

    func loadRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl

        // Fix for table view refresh control
        edgesForExtendedLayout = .all
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.refreshControl!.sizeToFit()
    }
}
