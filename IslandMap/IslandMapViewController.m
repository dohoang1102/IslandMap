//
//  ViewController.m
//  IslandMap
//
//  Created by Kris Bulman on 12-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IslandMapViewController.h"
#import "RMMarker.h"
#import "RMProjection.h"
#import "RMAnnotation.h"
#import "RMQuadTree.h"
#import "RMMBTilesTileSource.h"
#import "RMTileStreamSource.h"

@implementation IslandMapViewController
{
    BOOL showsLocalTileSource;
    CLLocationCoordinate2D center;
}

@synthesize mapView;

- (void)addMarkers
{
    
    CLLocationCoordinate2D markerPosition;
        
    UIImage *redMarkerImage = [UIImage imageNamed:@"marker-red.png"];

    markerPosition.latitude = center.latitude;
    markerPosition.longitude = center.longitude;
        
    NSLog(@"Add marker @ {%f,%f}", markerPosition.longitude, markerPosition.latitude);
    
    RMAnnotation *annotation = [RMAnnotation annotationWithMapView:self.mapView coordinate:markerPosition andTitle:[NSString stringWithFormat:@"Hello", markerPosition.longitude]];
    
    annotation.annotationIcon = redMarkerImage;
    annotation.anchorPoint = CGPointMake(0.5, 1.0);
                
    [self.mapView addAnnotation:annotation];
            
}

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
    
	center.latitude = 46.251795;
	center.longitude = -63.126068;
    
    showsLocalTileSource = YES;
    
    NSURL *tilesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"electoraldistricts" ofType:@"mbtiles"]];
    RMMBTilesTileSource *tileSource = [[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL];
    
	self.mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)
                                       andTilesource:tileSource
                                    centerCoordinate:center
                                           zoomLevel:8
                                        maxZoomLevel:[tileSource maxZoom]
                                        minZoomLevel:[tileSource minZoom]
                                     backgroundImage:nil];
    
    self.mapView.backgroundColor = [UIColor blackColor];
    self.mapView.delegate = self;
    
	[self.view addSubview:mapView];
	[self.view sendSubviewToBack:mapView];
    [self performSelector:@selector(addMarkers) withObject:nil afterDelay:0.5];
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

#pragma mark -
#pragma mark Delegate methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMarker *marker = nil;
    
    marker = [[RMMarker alloc] initWithUIImage:annotation.annotationIcon anchorPoint:annotation.anchorPoint];
        
    if (annotation.title)
    {
        marker.textForegroundColor = [UIColor blackColor];
        [marker changeLabelUsingText:annotation.title];
    }
    
    return marker;
}


@end
