//
//  ImageViewController.swift
//  TestAR
//
//

import UIKit

class ImageViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  let image: UIImage
  
  init(nibName nibNameOrNil: String?,
                bundle nibBundleOrNil: Bundle?,
                model: UIImage) {
    self.image = model
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = image
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
