//
//  AppDelegate.m
//  FreeToilet
//
//  Created by Alex Barlow on 27/03/2014.
//  Copyright (c) 2014 Alex Barlow. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate ()
@property (weak) IBOutlet NSMenu *statusMenu;
@end
@implementation AppDelegate
{
    __weak NSMenu *_statusMenu;
    NSStatusItem *_statusItem;
    AFHTTPRequestOperationManager *_manager;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self checkToiletStatus];
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkToiletStatus) userInfo:nil repeats:YES];
}

-(void)awakeFromNib{
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setMenu:_statusMenu];
    [_statusItem setImage:[NSImage imageNamed:@"toilet.png"]];
    [_statusItem setHighlightMode:YES];
}

-(void)checkToiletStatus
{
    [_manager GET:@"http://isthetoiletfree.com/api" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ((BOOL)[responseObject objectForKey:@"has_free_toilet"]) {
                [_statusItem setImage:[NSImage imageNamed:@"toilet.png"]];
            }else{
                [_statusItem setImage:[NSImage imageNamed:@"toilet_busy.png"]];
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

@end
