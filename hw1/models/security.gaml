/**
* Name: festival
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model security

/* Insert your model definition here */

global {
	
	int noguests<-5;
	
	init {
		create infocentre {
			badAppleIndex<--1;
			pointl<-nil;
		}
		create security {
			killBadAppleIndex<--1;
			killPoint<-nil;
		}
		create tavern with:(location:point (15,15));
		create tavern with:(location:point (60,60));
		create pub with:(location:point (90,90));
		create pub with:(location:point (30,30));
		create foodstall with:(location:point (75,75));	
		create foodstall with:(location:point (95,95));	
		create guests number:noguests
		{
		 isthirsty<-rnd(100);
		 ishungry<-rnd(100);
		 pointl<-nil;
		 foodbrain<-nil;
		 pubbrain<-nil;
		 tavernbrain<-nil;
		 atinfocentre<-false;
		 useBrain<-0;
		 badApple<-0;
		 killme<--1;
		}
		
		loop counter from:0 to:noguests-1{
			guests myagent<-guests[counter];
			myagent <- myagent.setName(counter);
		}
		
		}
	
	}
	
	


species guests skills: [moving]{
	
	int isthirsty;
	int ishungry;
	int r;
	int index;
	list<int> foodbrain;
	list<int> pubbrain;
	list<int> tavernbrain;
	int useBrain;
	int badApple;
	int killme;
	bool atinfocentre;
	point pointl;
	string guestName<-'undefined';
	point target<-{15,15};
	
	action setName(int num){
		guestName<-'My name is guest '+num;
		index<-num;
	}
	
	aspect base{
		rgb agentcolor<- rgb('purple');
		
		if(isthirsty<=0 and ishungry<=0 ){
			agentcolor<-rgb('black');
			
		}
		else if(ishungry<=0 ){
			agentcolor<-rgb('blue');
		}
		
		else if(isthirsty<=0 ){
			agentcolor<-rgb('yellow');
		}
	
		draw circle(1) color: agentcolor;
	}
	
	reflex killmyself when :(killme!=-1 and killme=index){
		if (location = pointl) {
			killme<--1;
			ask infocentre{
				self.badAppleIndex<--1;
				self.pointl<-nil;
			}
			ask security{
				self.killBadAppleIndex<--1;
				self.killPoint<-nil;
			}
			write guestName+ ' is dead...';
			do die;
		}
	}
	
	
	reflex enjoyTheFestival when:(isthirsty!=0 and ishungry!=0)
	{

		do wander;
		isthirsty<-isthirsty-1;
		ishungry<-ishungry-1;
		if (isthirsty<=0 and ishungry<=0) {
			write guestName+ ' Im thirsty and hungry';
		} else if (isthirsty<=0) {
			write guestName+ ' Im thirsty';
		} else if (ishungry<=0) {
			write guestName+ ' Im hungry';
		}
	}
	
	reflex ifThirstyOrIfHungry when:((isthirsty<=0 or ishungry<=0) and atinfocentre=false) {
		
		if (isthirsty<=0 and ishungry<=0) {
			// if tavernbrain has no value, go to info center
			if (tavernbrain = []) {
				write guestName+ " tavernbrain is empty - going to info centre to find a tavern";
				do goto target:{50,50};
			} else {
				// if tavernbrain has value, randomly choose between brain or info centre
				// Go to tavern or info centre
				useBrain<-rnd(0, 1);
				if (useBrain = 1) {
					write guestName+ " tavernbrain has some values and I'm using them to go";		
					atinfocentre<-true;		
					do goto target:tavern[tavernbrain[rnd(0,length(tavernbrain)-1)]].location;				
				} else {
					write guestName+ " tavernbrain has some values but I want to find something new - going to info centre";
					do goto target:{50,50};
				}
			}
		} else if (isthirsty<=0) {
			// if pubbrain has no value, go to info center
			if (pubbrain = []) {
				write guestName+ " pubbrain is empty - going to info centre to find a tavern";
				do goto target:{50,50};
			} else {
				// if pubbrain has value, randomly choose between brain or info centre
				// Go to pub or info centre
				useBrain<-rnd(0, 1);
				if (useBrain = 1) {
					write guestName+ " pubbrain has some values and I'm using them to go";
					atinfocentre<-true;
					do goto target:pub[pubbrain[rnd(0,length(pubbrain)-1)]].location;				
				} else {
					write guestName+ " pubbrain has some values but I want to find something new - going to info centre";
					do goto target:{50,50};
				}
			}
		} else if (ishungry<=0) {
			// if foodbrain has no value, go to info center
			if (foodbrain = []) {
				write guestName+ " foodbrain is empty - going to info centre to find a tavern";
				do goto target:{50,50};
			} else {
				// if foodbrain has value, randomly choose between brain or info centre
				// Go to foodstall or info centre
				useBrain<-rnd(0, 1);
				if (useBrain = 1) {
					write guestName+ " foodbrain has some values and I'm using them to go";
					atinfocentre<-true;
					do goto target:foodstall[foodbrain[rnd(0,length(foodbrain)-1)]].location;				
				} else {
					write guestName+ " foodbrain has some values but I want to find something new - going to info centre";
					do goto target:{50,50};
				}
			}
		}
			
		//do goto target:{50,50};
		

		if (location={50,50}){
			write guestName + 'i have reached the info centre';
			atinfocentre<-true;
		}
	}
		
		
	reflex ifatinfocentretrue when: (atinfocentre=true and pointl=nil){
		r<-rnd(0,1);

		if(isthirsty<=0 and ishungry<=0){
			write guestName+ ' : im hungry and is thirsty';
			ask infocentre{
				myself.pointl<-tavern[myself.r].location;
			}
			if !(tavernbrain contains r) {
				write "Found a new tavern, adding to my brain";
				add r to: tavernbrain;
			}
		}
		
		else if (isthirsty<=0){
			write guestName+ ' : im thirsty';
			ask infocentre{
				myself.pointl<-pub[myself.r].location;
			}
			if !(pubbrain contains r) {
				write "Found a new pub, adding to my brain";
				add r to: pubbrain;
			}
		}
		
		else if (ishungry<=0){
			write guestName+ ' : im hungry';
			ask infocentre{
				myself.pointl<-foodstall[myself.r].location;
			}
			if !(foodbrain contains r) {
				write "Found a new foodstall, adding to my brain";
				add r to: foodbrain;
			}
		}
		
		badApple<-rnd(0,1);
		if (badApple = 1) {
			write guestName+ " bad guy detected";
			ask infocentre {
				write "bad guy informed to info centre with index" + myself.index;
				self.badAppleIndex<-myself.index;
				self.pointl<-myself.pointl;
				write "location of target - " +myself.pointl;
			}
		} else {
			write guestName+ " is a good guy!";
		}
	}
	
	reflex gototarget when: (pointl!=nil){
		do goto target:pointl;

		if (killme = -1) {
			if(location=tavern[0].location or location=tavern[1].location){
				write guestName + ': I have reached tavern and drank and eaten. Time to party!';
				ask tavern{
					myself.ishungry<-100;
					myself.isthirsty<-100;
					myself.pointl<-nil;
					myself.atinfocentre<-false;
					}
			}
			if(location=foodstall[0].location or location=foodstall[1].location){
				write guestName + ': I have reached foodstall and eaten. Time to party!';
				ask foodstall{
					myself.ishungry<-100;
					myself.pointl<-nil;
					myself.atinfocentre<-false;
				}
			}
			if(location=pub[0].location or location=pub[1].location){
				write guestName + ': I have reached the pub and drank. Time to party!';
				ask pub{
					myself.isthirsty<-100;
					myself.pointl<-nil;
					myself.atinfocentre<-false;
				}
			}	
		}
	}
		
	
}


species infocentre{
	
	int badAppleIndex;
	point pointl;
	
	aspect base{
		draw square(10) at: {50,50} color: #orange;
	}
	
	reflex updateSecurity when: (badAppleIndex != -1) {
		write "INFO CENTRE ALERT: Bad guy identified "+badAppleIndex;
		ask security {
			self.killBadAppleIndex<-myself.badAppleIndex;
			self.killPoint<-myself.pointl;
		}
	}
}

species security skills: [moving]{
	
	int killBadAppleIndex;
	point killPoint;
	
	aspect base{
		draw triangle(3) color: #red;
	}
	
	reflex approachBadApple when: (killPoint != nil) {
		write "SECURITY ALERT - Security approaching bad guest now "+killBadAppleIndex;
		write "SECURITY ALERT - location of target - " +killPoint;
		do goto target:killPoint speed:4.0;
	}
	
	reflex killBadApple when: (killBadAppleIndex != -1 and location = killPoint) {
		write "SECURITY ALERT - Kill order given to bad guest "+killBadAppleIndex;
		ask guests {
			self.killme<-myself.killBadAppleIndex;
		}
	}
}

species tavern{
	
	aspect base{
		draw rectangle(7,4) at: location color: #yellow;
	}
}

species pub{
	
	aspect base{
		draw rectangle(5,3) at: location color: #pink;
	}
}

species foodstall{
	
	aspect base{
		draw rectangle(5,3) at: location color: #skyblue;
	}
}


experiment exp type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
output {
		display mydisplay{
			species guests aspect:base;
			species infocentre aspect:base;
			species tavern aspect:base;
			species pub aspect:base;
			species foodstall aspect:base;
			species security aspect:base;
		}
}
}
