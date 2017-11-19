//
//  UIImageView+URL.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(URL)

/**
 Sets the image asynchronously via a URL.
 */
- (void)setImageWithURL:(NSURL * _Nonnull)url;

@end
