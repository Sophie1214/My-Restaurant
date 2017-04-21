//
//  CoreDataTableViewController.swift
//


import UIKit
import CoreData
import EasyPeasy

class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            self.tableView.register(MySavedRestaurantsTableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableView.sectionIndexColor = .lightGray
            self.tableView.sectionIndexBackgroundColor = UIColor.white.withAlphaComponent(0.5)

            do {
                if let frc = fetchedResultsController {
                    frc.delegate = self
                    try frc.performFetch()
                }
                tableView.reloadData()
            } catch let error {
                print("NSFetchedResultsController.performFetch() failed: \(error)")
            }
        }
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections , sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections , sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }

    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert: tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete: tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                tableView.reloadRows(at: [indexPath!], with: .fade)
            case .move:
                tableView.deleteRows(at: [indexPath!], with: .fade)
                tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
 

/*override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
 let h = tableView.dequeueReusableHeaderFooterView(withIdentifier:"Header")!
 if h.viewWithTag(1) == nil {
 print("configuring a new header view") // only called about 8 times
 
 h.backgroundView = UIView()
 h.backgroundView?.backgroundColor = #colorLiteral(red: 0.8602490425, green: 0.8571409583, blue: 0.8634953499, alpha: 1)
 let lab = UILabel()
 lab.tag = 1
 lab.font = UIFont.systemFont(ofSize: 13)
 lab.textColor = .black
 lab.backgroundColor = .clear
 h.contentView.addSubview(lab)
 lab <- [Left(10), CenterY()]
 }
 let lab = h.contentView.viewWithTag(1) as! UILabel
 lab.text = fetchedResultsController?.sections?[section].name
 lab.sizeToFit()
 return h
 }
 
 override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 return 15
 }
 
 override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
 return 15
 }*/

