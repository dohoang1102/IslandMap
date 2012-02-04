//
//  ViewController.m
//  IslandMap
//
//  Created by Kris Bulman on 12-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IslandMapViewController.h"
#import "RMMapView.h"
#import "RMMBTilesTileSource.h"
#import "RMTileStreamSource.h"

@implementation IslandMapViewController
{
    BOOL showsLocalTileSource;
}

@synthesize mapView;


#pragma mark -
#pragma mark View lifecycle

// Allow rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
	CLLocationCoordinate2D firstLocation;
	firstLocation.latitude = 46.251795;
	firstLocation.longitude = -63.126068;
    
    showsLocalTileSource = YES;
    
    NSURL *tilesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"electoraldistricts" ofType:@"mbtiles"]];
    RMMBTilesTileSource *tileSource = [[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL];
    
	self.mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)
                                       andTilesource:tileSource
                                    centerCoordinate:firstLocation
                                           zoomLevel:8
                                        maxZoomLevel:[tileSource maxZoom]
                                        minZoomLevel:[tileSource minZoom]
                                     backgroundImage:nil];
    
    self.mapView.backgroundColor = [UIColor blackColor];
    
	[self.view addSubview:mapView];
	[self.view sendSubviewToBack:mapView];
}

- (void)dealloc
{
    [self.mapView removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (IBAction)swtichTilesource:(id)sender
{
    id <RMTileSource> newTileSource = nil;
    
    if (showsLocalTileSource)
    {
        showsLocalTileSource = NO;
        
        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"geography-class" ofType:@"plist"]];
        newTileSource = [[RMTileStreamSource alloc] initWithInfo:info];
    }
    else
    {
        showsLocalTileSource = YES;
        
        NSURL *tilesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"electoraldistricts" ofType:@"mbtiles"]];
        newTileSource = [[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL];
    }
    
    self.mapView.tileSource = newTileSource;
}

@end
