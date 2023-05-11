//
//  ViewController.swift
//  Mixer Table
//
//  Created by Владимир on 10.05.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var data: [(Int, Bool)] = []
    let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = (1...30).map { ($0, false) }
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(shuffleData))
    }
    
    @objc func shuffleData() {
        data.shuffle()
        tableView.performBatchUpdates({
            let indexPaths = tableView.indexPathsForVisibleRows ?? []
            for indexPath in indexPaths {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let (number, isChecked) = data[indexPath.row]
        cell.textLabel?.text = "\(number)"
        cell.accessoryType = isChecked ? .checkmark : .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    /*
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     cell.transform = CGAffineTransform(scaleX: 0, y: 0)
     UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
     cell.transform = CGAffineTransform.identity
     }, completion: nil)
     }
     */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var item = data[indexPath.row]
        item.1.toggle()
        data[indexPath.row] = item
        
        if item.1 {
            data.remove(at: indexPath.row)
            data.insert(item, at: 0)
            
            tableView.performBatchUpdates({
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            }) { _ in
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        } else {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}


