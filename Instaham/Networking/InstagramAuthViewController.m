//
//  InstagramAuthViewController.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import "InstagramAuthViewController.h"
#import "Instagram.h"

@interface InstagramAuthViewController () <UIWebViewDelegate>

@end

@implementation InstagramAuthViewController {
    UIWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] initWithFrame: self.view.bounds];
    webView.autoresizesSubviews = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    
    self.view.autoresizesSubviews = YES;
    
    [self.view addSubview:webView];
    
    NSURL *authURL = [Instagram authURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:authURL];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // NSLog(@"%@", request.URL.host);
    // handles the redirects of api.instagram.com to www.instagram.com.
    // so long as it's on instagram.com, i'm good.
    if ([request.URL.host containsString:@"instagram.com"]) {
        return TRUE;
    } else if ([request.URL.host isEqualToString:@"hamography.com"]) {
        NSString *token = [request.URL.fragment stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];
        [Instagram setToken:token];
        self.tokenCompletion();
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }
    
    return FALSE;
}

@end
