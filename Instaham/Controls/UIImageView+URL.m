//
//  UIImageView+URL.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import "UIImageView+URL.h"

@implementation UIImageView(URL)

- (void)setImageWithURL:(NSURL * _Nonnull)url {
    NSURLSession *session = NSURLSession.sharedSession;
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = [UIImage imageWithData:data];
                    // color me surprised, the size doesn't match the payload.  <GASP!!>
                    //NSLog(@"w = %f, h = %f", self.image.size.width, self.image.size.height);
                });
            }
        }
    }];
    
    [task resume];
}

@end
