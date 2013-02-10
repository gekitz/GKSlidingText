### GKSlidingText
=================

Ever wanted the use the same Sliding Text like Apple uses on the lock screen or in the Music.app (or like we do it in [iRadio](http://www.iradio-app.com)) to display the song/artist? Here is __GKSlidingText__ which reproduces this endless sliding effect.

### How to use it
=================

- just drag and drop the `GKSlidingText.h` and `GKSlidingText.m` into your project.
- add `QuartzCore.framework` to your project (if you haven't added it yet)
- look at the sample code below.
- this project contains a sample project as well, just have a look at the implementation of `ViewController.m` 
- have fun and follow [@gekitz](http://www.twitter.com/gekitz).


### Sample Code
===============
	
	GKSlidingText *slidingText = [[GKSlidingText alloc] initWithFrame:CGRectMake(20, 160, 280, 25)];
		
	slidingText.text = @"This is a sliding text wohooo slide slide...";
	[self.view addSubview:slidingText];
     
Under the following [link](https://dl.dropbox.com/u/311618/slidingtext.mov) you can see a video of what this source code actually produces. 

### License
===========
Under MIT. See license file for details.



    