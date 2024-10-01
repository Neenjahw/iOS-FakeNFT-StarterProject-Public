protocol StatisticsView: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func updateTableView()
    func showErrorAlert()
}
