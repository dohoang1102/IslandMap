//
//  ViewController.h
//  IslandMap
//
//  Created by Kris Bulman on 12-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMMapView;

@interface IslandMapViewController : UIViewController
{
	RMMapView *mapView;
}

@property(nonatomic,strong)RMMapView *mapView;

- (IBAction)swtichTilesource:(id)sender;

@end
