//
//  CatsShowViewController.swift
//  CatsShow
//
//  Created by Tanzeem Ahamad.


import UIKit
import Kingfisher

class CatsShowViewController: UIViewController, CatsShowViewModelImageURLOutput,CatsShowViewModelFactDataOutput,CatsShowViewModelImageOutput {
        
    var viewModel:CatsShowViewModel?
    
    private let catFactLabel : UILabel =  CatLabel().label
    private let catFactTextView:UITextView = CatTextView().textView
    private let catImageView:UIImageView = CatImageView().imageView
    private let catImageViewCached:UIImageView = CatImageView().imageView
    
    init(viewModel:CatsShowViewModel?){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel?.catImageUrlOutput = self
        self.viewModel?.catImageOutput = self
        self.viewModel?.catDataOutput = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndConfigureViews()
        fetchCatData()
        fetchCatImageRequest() // it does not support caching hence fetching will be slow
        //fetchCatImageRequestUsingCache() // fetching of image must be very fast in second attempt due to the caching using KingFisher Libraty
        fetchCachedCatImageRequest()// fetching of image must be very fast in second attempt due to the caching without usingn KingFisher Library
    }
    
    func setupAndConfigureViews(){
        view.backgroundColor = .white
        configureAndAddCatFactLabel()
        configureAndAddFactTextView()
        configureAndAddFactImageView()
        configureAndAddImageCachedView()
        configureAndAddNextButton()
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func nextButtonPressed() {
        fetchCatData()
        fetchCatImageRequest()
        //fetchCatImageRequestUsingCache()
        fetchCachedCatImageRequest()
    }
    
  
   

    
    func fetchCachedCatImageRequest(){ // Image Caching without using any 3rd Party Library
        viewModel?.fetchCachedCatImageRequest{ [weak self] (data, error) in
            if error != nil{
                print("Error")
                return
            }
            DispatchQueue.main.async {
                self?.catImageViewCached.image = UIImage(data: data!)
            }
        }
    }
    
    
    func fetchCatImageRequest(){ // No Image Caching
        viewModel?.fetchCatImageRequest(){ [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.catImageView.image = data
                }
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    func fetchCatImageRequestUsingCache(){ // Image caching using KingFisher Library
        viewModel?.fetchCatImageRequestUsingCache(){ [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.catImageViewCached.kf.setImage(with: url, completionHandler:  { result in
                        self?.handleKFResult(result: result)
                    })
                }
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    func fetchCatData(){
        viewModel?.fetchCatDataRequest(){ [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.catFactTextView.text = data.facts[0]
                }
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    // Delegates
    func updateImageView(image : UIImage?) {
        DispatchQueue.main.async {
            self.catImageView.image = image
        }
    }
      
    func updateImageViewFromURL(catImageUrl:URL){
        DispatchQueue.main.async {
            let imageResource = ImageResource(downloadURL: catImageUrl)
            let placeHolder = UIImage(named: "Cat.jpeg")
            self.catImageViewCached.kf.setImage(with: imageResource, placeholder: placeHolder, completionHandler: { result in
                self.handleKFResult(result: result)
            })
        }
    }
    
    func updateFactView(dataModel:CatDataModel){
        DispatchQueue.main.async {
            self.catFactTextView.text = dataModel.facts[0]
        }
    }
    
    func handleKFResult(result:Result<RetrieveImageResult, KingfisherError>){
        switch(result){
        case.success(let retrieveImageResult):
            let image = retrieveImageResult.image
            let cacheType = retrieveImageResult.cacheType
            let source = retrieveImageResult.source
            let originalSource = retrieveImageResult.originalSource
            let str = "image:\(image), cacheType:\(cacheType), source:\(source), OrgSource:\(originalSource) "
            print(str)
        case .failure(let err):
            print(err.localizedDescription)
            handleKFError(error: err)
         }
    }
    
    func handleError(error:ErrorCodes){
        let localizedTitleStr = NSLocalizedString("error", comment: "")
        showAlertWithOkButtonOnly( title: localizedTitleStr,message: error.localizedDescription)
    }
  
    func handleKFError(error:KingfisherError){
        let localizedTitleStr = NSLocalizedString("error", comment: "")
        showAlertWithOkButtonOnly( title: localizedTitleStr,message: error.localizedDescription)
    }
    
    func showAlertWithOkButtonOnly(title:String,message:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message:message,preferredStyle: .alert)
            let nsLocalizedOKStr = NSLocalizedString("ok", comment: "")
            alert.addAction(UIAlertAction(title: nsLocalizedOKStr, style: .default, handler: nil))
            self.present(alert,animated:true,completion: nil)
        }
    }
    
    func configureAndAddCatFactLabel(){
        let localizedCatFactStr = NSLocalizedString("cat", comment: "") + " " + NSLocalizedString("fact", comment: "")
        catFactLabel.text = localizedCatFactStr
        catFactLabel.frame = CGRect(x: Int(self.view.center.x) - 100/2,
                                 y: 55,
                                 width:  100,
                                 height: 40)
        view.addSubview(catFactLabel)
    }
    
    func configureAndAddFactTextView(){
        catFactTextView.frame = CGRect(x:45, y: catFactLabel.frame.maxY+5, width: 350, height: 100.0)
        view.addSubview(catFactTextView)
    }
    
    func configureAndAddFactImageView(){
        catImageView.frame = CGRect(x: catFactTextView.frame.minX, y: catFactTextView.frame.maxY+10, width: catFactTextView.frame.width, height: 280)
        view.addSubview(catImageView)
    }
    
    func  configureAndAddImageCachedView(){
        catImageViewCached.frame = CGRect(x: catFactTextView.frame.minX, y: catImageView.frame.maxY+10, width: catFactTextView.frame.width, height: catImageView.frame.height)
        catImageViewCached.kf.indicatorType = .activity
        view.addSubview(catImageViewCached)
    }
    
    func  configureAndAddNextButton(){
        let nextButton = UIButton()
         nextButton.setTitle(NSLocalizedString("next", comment: "") + " " + NSLocalizedString("cat", comment: ""), for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        nextButton.frame = CGRect(x: Int(self.view.center.x) - 100/2,
                                  y: Int(catImageViewCached.frame.maxY+5),
                                  width:  100,
                                  height: Int(catFactLabel.frame.height))
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)
    }
}

