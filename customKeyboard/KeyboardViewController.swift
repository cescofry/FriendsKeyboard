//
//  KeyboardViewController.swift
//  customKeyboard
//
//  Created by Francesco Frison on 6/17/14.
//  Copyright (c) 2014 Yammer-inc. All rights reserved.
//

import UIKit

class KeyButton : UIButton {
    var key: Character?
}

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton
    
    var buttons : NSArray?
    var friends : Array<Friend>?
    var currentSearch : String?
    

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func setUpButtons() {
    
        var mutButtons = NSMutableArray()
        
        let lowerLetters = "qwertyuiop.asdfghjkl.zxcvbnm"
        
        let lastRow = [("numbersAction", " 123 "),
            ("advanceToNextInputMode", "   ⎈   "),
            ("_", "          Space         "),
            ("returnAction", "  ⏎  "),
            ("delAction", "  ⌫  ")]
        
        let components = lowerLetters.componentsSeparatedByString(".")
        
        let w : Float = 320.0//Float(self.view.frame.width)
        let h : Float = 200.0//Float(self.view.frame.height) / Float(countElements(components))
        let bh =  h / Float(countElements(components) + 1)
        var frame = CGRect(x: 0, y: 0, width: 0, height: bh)
        for row in components {
            let length = Float(countElements(row))
            let bw = w / length
            frame.size.width = bw
            frame.origin.x = 0
            
            for letter in row {
                let button = keybutton(key: letter)
                button.frame = frame;
                self.view.addSubview(button)
                mutButtons.addObject(button)
                
                frame.origin.x += bw
            }
            frame.origin.y += frame.size.height
        }
        
        frame.origin.x = 0
        for (action, title) in lastRow {
            let text : NSString = title
            
            var selector = Selector(action)
            var key : Character?
            if self.respondsToSelector(selector) {
                selector = Selector("keyPressed:")
                key = " "
            }
            
            let button = keybutton(title: title, action: selector, longPress: nil)
            if key {
                button.key = key!
            }
            
            
            frame.size.width = text.sizeWithFont(button.titleLabel.font).width
            button.frame = frame;
            
            self.view.addSubview(button)
            mutButtons.addObject(button)
            frame.origin.x += frame.size.width
        }
        
        self.buttons = mutButtons
    }
    
    func keybutton(#key: Character) -> KeyButton {
        let action = Selector("keyPressed:")
        let longPress = Selector("keyLongPressed:")
        let button = keybutton(title: String(key), action: action, longPress: longPress)
        button.key = key
        
        return button
    }
    
    func keybutton(#title: String, action: Selector?, longPress: Selector?) -> KeyButton {
        let button = KeyButton(frame: CGRectZero)
        
        if action {
            button.addTarget(self, action: action!, forControlEvents: UIControlEvents.TouchUpInside)
        }
        if longPress {
            let longPressGR = UILongPressGestureRecognizer(target: self, action: longPress!)
            button.addGestureRecognizer(longPressGR)
        }
        
        button.setTitle(title, forState:.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        
        button.backgroundColor = UIColor.lightGrayColor()
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        
        return button
    }
    
    /**
    * Actions
    */
    
    func keyPressed(sender: KeyButton) {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText("\(sender.key!)")
    }
    
    func keyLongPressed(sender: UIGestureRecognizer) {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        let btn = sender.view as KeyButton
        
        var friend : Friend?
        
        if btn.key == "f" {
            friend = self.friends![0]
        }
        else if btn.key == "m" {
            friend = self.friends![1]
        }
        else if btn.key == "s" {
            friend = self.friends![2]
        }
        
        if (friend) {
            btn.setBackgroundImage(friend!.image, forState: UIControlState.Normal)
            proxy.insertText(friend!.name)
            
        }
        
    }
    
    func numbersAction() {
        println("activate numbers")
    }
    
    func returnAction() {
        println("return character")
    }

    func delAction() {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.deleteBackward()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        
        self.friends = DataProvider.friends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
        
        println("here we are")
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
    }

}


/*
#pragma mark - Private methods

- (void)setFBListForMyfriendsListTableController
{
if([self.facebook accessToken]) {
NSURL *url = [NSURL URLWithString:[@"https://graph.facebook.com/me/friends?access_token=" stringByAppendingString:self.facebook.accessToken]];
NSURLRequest *request = [NSURLRequest requestWithURL:url];

AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
[self.myFriendsListTableController setDisplayedFriends:[JSON friendsFromJSON]];
} failure:nil];

[operation start];
}

}
*/
