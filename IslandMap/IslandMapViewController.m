//
//  ViewController.m
//  IslandMap
//
//  Created by Kris Bulman on 12-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IslandMapViewController.h"
#import "RMMapView.h"
#import "RMMarker.h"
#import "RMProjection.h"
#import "RMAnnotation.h"
#import "RMQuadTree.h"
#import "RMMBTilesTileSource.h"
#import "RMTileStreamSource.h"
#import "SimpleKML.h"
#import "SimpleKMLContainer.h"
#import "SimpleKMLDocument.h"
#import "SimpleKMLFeature.h"
#import "SimpleKMLPlacemark.h"
#import "SimpleKMLPoint.h"
#import "SimpleKMLLinearRing.h"
#import "HexColorMacros.h"

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

    SimpleKML *kml = [SimpleKML KMLWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"herbarium" ofType:@"kml"] error:NULL];    
    
    
    // look for a document feature in it per the KML spec
    //
    if (kml.feature && [kml.feature isKindOfClass:[SimpleKMLDocument class]])
    {
        // see if the document has features of its own
        //
        for (SimpleKMLFeature *feature in ((SimpleKMLContainer *)kml.feature).features)
        {
            // see if we have any placemark features with a point
            //
            if ([feature isKindOfClass:[SimpleKMLPlacemark class]] && ((SimpleKMLPlacemark *)feature).point)
            {
                SimpleKMLPoint *point = ((SimpleKMLPlacemark *)feature).point;
                
                // create a normal point annotation for it
                //

                NSLog(@"Add marker @ {%f,%f}", point.coordinate.longitude, point.coordinate.latitude);
                RMAnnotation *annotation = [RMAnnotation annotationWithMapView:self.mapView coordinate:point.coordinate andTitle:[NSString stringWithFormat:@"Hello", point.coordinate.longitude]];
                
                
                annotation.coordinate = point.coordinate;
                annotation.title      = feature.name;
                annotation.annotationIcon = redMarkerImage;
                annotation.anchorPoint = CGPointMake(0.5, 1.0);
                [mapView addAnnotation:annotation];
 
            }
        }
    }
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




#pragma mark - View lifecycle

- (void)viewDidLoad
{
	NSLog(@"viewDidLoad");
    [super viewDidLoad];

	center.latitude = 46.251795;
	center.longitude = -63.126068;
    
    showsLocalTileSource = YES;
    
    NSURL *tilesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pei" ofType:@"mbtiles"]];
    RMMBTilesTileSource *tileSource = [[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL];
    
	self.mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)
                                       andTilesource:tileSource
                                    centerCoordinate:center
                                           zoomLevel:8
                                        maxZoomLevel:[tileSource maxZoom]
                                        minZoomLevel:[tileSource minZoom]
                                     backgroundImage:nil];
    
    self.mapView.backgroundColor = UIColorFromRGBWithAlpha(0xEEEEEE, 1);
    self.mapView.delegate = self;
    self.mapView.enableClustering = YES;
	[self.view addSubview:mapView];
	[self.view sendSubviewToBack:mapView];
    [self performSelector:@selector(addMarkers) withObject:nil afterDelay:0.5];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [self.mapView removeFromSuperview];
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
        
        NSURL *tilesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pei" ofType:@"mbtiles"]];
        newTileSource = [[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL];
    }
    
    self.mapView.tileSource = newTileSource;
}



#pragma mark -
#pragma mark Delegate methods


- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map 
{
    if ([annotation.annotationType isEqualToString:kRMClusterAnnotationTypeName]) 
    {
        [map zoomInToNextNativeZoomAt:[map coordinateToPixel:annotation.coordinate] animated:YES];
    }
}

- (RMMapLayer *)mapView:(RMMapView *)aMapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMapLayer *marker = nil;
    
    if ([annotation.annotationType isEqualToString:kRMClusterAnnotationTypeName])
    {
        marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"marker-blue.png"] anchorPoint:annotation.anchorPoint];
        if (annotation.title)
            [(RMMarker *)marker changeLabelUsingText:annotation.title];
    }
    else
    {
        marker = [[RMMarker alloc] initWithUIImage:annotation.annotationIcon anchorPoint:annotation.anchorPoint];
        if (annotation.title)
            [(RMMarker *)marker changeLabelUsingText:annotation.title];
    }
    
    return marker;
}



@end
