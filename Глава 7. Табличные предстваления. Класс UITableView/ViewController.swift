//
//  ViewController.swift
//  Глава 7. Табличные предстваления. Класс UITableView
//
//  Created by Dmytro Neboha on 10.10.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private var contacts = [ContactProtocol]() {
        didSet {
            contacts.sort { $0.title < $1.title }
        }
    }
    
    private func loadContacts() {
        contacts.append(Contact(title: "Alex Photographer", phone: "+380973452331"))
        contacts.append(Contact(title: "Dmytro Developer", phone: "+380973450967"))
        contacts.append(Contact(title: "Maks Videographer", phone: "+380973452125"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
    }
    
    @IBAction func showNewContactAlert() {
        // создание Alert Contoller
        let alertController = UIAlertController(title: "Создайте новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
        
        // добавляем первое текстовое поле в AlertController
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        // добавляем второе текстовое поле в AlertController
        alertController.addTextField { textField in
            textField.placeholder = "Номер телефона"
        }
        
        // создаем кнопки. Кнопка создания контакта
        let createButton = UIAlertAction(title: "Создать", style: .default) {
            _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text else {
                return
            }
            
            // создаём новый контакт
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
        
        // кнопка отмены
        let cancelButon = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        // добавляем кнопки в Alert Controller
        alertController.addAction(cancelButon)
        alertController.addAction(createButton)

        
        // отображаем Alert Controller
        self.present(alertController, animated: true, completion: nil)
    }
}



extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // получаем экземпляр ячейки
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаём новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
        private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        // contact name
        configuration.text = contacts[indexPath.row].title
        // phone number
        configuration.secondaryText = contacts[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
}



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("Определяем доступные действия для строки \(indexPath.row)")
        // действие удаление
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") {_,_,_ in
            // удаляем контент
            self.contacts.remove(at: indexPath.row)
            // заново формируем табличное предстваление
            tableView.reloadData()
        }
        // формируем экземпляр, описывающий достыпные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}
