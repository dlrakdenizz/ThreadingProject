//
//  ViewController.swift
//  ThreadingProject
//
//  Created by Dilara Akdeniz on 28.09.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let urlStrings = ["https://upload.wikimedia.org/wikipedia/commons/7/74/Earth_poster_large.jpg", "https://www.hhi-ni.com/wp-content/uploads/2017/05/6823214-large.jpg"]
    
    var data = Data()
    
    var tracker = 0 //Resmi değiştirebilmek için bu değişkeni oluşturduk.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        /*
        data = try! Data(contentsOf: URL(string: urlStrings[tracker])!) //Bu internetten görsel indirmek için yapılan en yanlış yöntemdir. contentsOf diyerek URL alınmasını sağlıyoruz ve string olarak url'yi yukarıda oluşturulan urlStrings dizisinden alıyoruz. Herhangi bir try catch işlemi ya da if let, guard let giib bir işlem yapılmıyor ama bizim urlnin yanlış olma ihtimali var.Her yere ! koyarak yüzde yüz doğru bir kod yazdığımızı söylüyoruz.
         imageView.image = UIImage(data: data)
        */
        
        
        //Arka plandaki bir işi öne almak için DispatchQueue.main async kullanıyorduk. Bir işi arka plana almak için DispatchQueue.global.async kullanılır.
        DispatchQueue.global().async {
            self.data = try! Data(contentsOf: URL(string: self.urlStrings[self.tracker])!) //background thread
            DispatchQueue.main.async{
                self.imageView.image = UIImage(data: self.data) //main thread
            }
        }
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(changeImage))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Threading Test"
        return cell
    }

    @objc func changeImage() {
        
        if tracker == 0{
            tracker += 1
        } else {
            tracker -= 1
        }
        
        DispatchQueue.global().async {
            self.data = try! Data(contentsOf: URL(string: self.urlStrings[self.tracker])!) //background thread
            DispatchQueue.main.async{
                self.imageView.image = UIImage(data: self.data) //main thread
            }
        }
    }
}

