//
//  ViewController.swift
//  CollectionViewUI
//
//  Created by Kritika Gill on 25/08/21.
//

import UIKit


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

struct jsonstruct:Decodable {
    let url:String
   
}
class ViewController: UIViewController, UITableViewDelegate, UICollectionViewDataSource {
   

   
    @IBOutlet weak var CollectionView: UICollectionView!
    
    
    var arrdata = [jsonstruct]()
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.dataSource = self
      // getdata()
    }

    func getdata(){
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=42")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{if error == nil{
                self.arrdata = try JSONDecoder().decode([jsonstruct].self, from: data!)
                
                for mainarr in self.arrdata{
                    print(mainarr.url)
                   // DispatchQueue.main.async {
                         //self.tableview.reloadData()
                    //}
                   
                }
                }
            
            }catch{
                print("Error in get json data")
            }
            
        }.resume()
    }
    
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customcell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.contentMode = .scaleAspectFill
        
        let defaultLink = "https://api.nasa.gov"
        let completeLink = defaultLink + arrdata[indexPath.row].url
        cell.imageView.downloaded(from: completeLink)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageInfo =  GSImageInfo(image: arrdata, imageMode: GSImageInfo.ImageMode)
       
        let transitioninfo  = GSTransitionInfo(fromView: CollectionView)
       
        let imageViewer = GSImageViewerController(imageInfo:imageInfo, transitioninfo:transitioninfo)
        
    }
}
