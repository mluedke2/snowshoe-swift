//
//  SnowShoeView.swift
//  Pods
//
//  Created by Matt Luedke on 8/27/15.
//
//

import OAuthSwift
import ObjectMapper

open class SnowShoeView: UIView {
    
    open var appKey: String?
    open var appSecret: String?
    open var delegate: SnowShoeDelegate?
    
    let baseUrl = "https://beta.snowshoestamp.com/api/v2/stamp"
    let touchCount = 5
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupStampDetection()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStampDetection()
    }
    
    func setupStampDetection() {
        let tapRecognizer = SSTapGestureRecognizer(target: self, action: #selector(SnowShoeView.handleStamp(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleStamp(_ sender: SSTapGestureRecognizer) {
        
        //Check stamp count is correct amount.
        var curTouchCount: Int? = (sender.allTouches?.count)!
        if (curTouchCount != touchCount) {
            curTouchCount = nil
        }
        
        if let appKey = appKey, let appSecret = appSecret, let _ = curTouchCount {
            var stampPoints = [[Double]]()
            
            for touch in sender.allTouches! {
                let point = touch.location(in: self)
                stampPoints.append([Double(point.x), Double(point.y)])
            }
            
            let data = try? JSONSerialization.data(withJSONObject: stampPoints, options: [])
            let base64Encoded = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            let client = OAuthSwiftClient(consumerKey: appKey, consumerSecret: appSecret)
            
            _ = client.post(baseUrl,
                            parameters: ["data": base64Encoded],
                            success: { response  in
                                let response = SnowShoeResult(JSONString: response.string!)
                                self.delegate?.onStampResult(response)
            },
                            failure: { error in
                                print("ERROR: \(error.localizedDescription)")
                                self.delegate?.onStampResult(nil)
            })
            
            delegate?.onStampRequestMade()
            
        } else {
            if let _ = appKey, let _ = appSecret {
                
            }
            else {
                assertionFailure("error: neither appKey nor appSecret can be empty")
            }
        }
    }
}
