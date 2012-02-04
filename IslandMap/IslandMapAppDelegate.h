//
//  AppDelegate.h
//  IslandMap
//
//  Created by Kris Bulman on 12-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IslandMapViewController;

@interface IslandMapAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    IslandMapViewController *viewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet IslandMapViewController *viewController;

@end

