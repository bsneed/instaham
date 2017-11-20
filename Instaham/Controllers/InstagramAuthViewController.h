//
//  InstagramAuthViewController.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TokenCompletion)(void);

@interface InstagramAuthViewController : UIViewController

/**
 This completion block will be called once we've received a token.
 */
@property TokenCompletion tokenCompletion;

@end
