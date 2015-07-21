//
//  LoadVC.m
//  AVAudioPlayerDemo
//
//  Created by Richey on 15/7/21.
//  Copyright (c) 2015年 Richey. All rights reserved.
//

#import "LoadVC.h"


@interface LoadVC()<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView *webview;
@end

@implementation LoadVC


-(void)viewDidLoad
{
    self.title = @"onlineMusic";
    _webview =  [[UIWebView alloc]initWithFrame:self.view.frame];
   _webview.backgroundColor = [UIColor whiteColor];
    _webview.scalesPageToFit = YES;
    _webview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin);
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://music.hao123.com/"]]];
    _webview.delegate = self;
    [self.view addSubview:_webview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
   [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
