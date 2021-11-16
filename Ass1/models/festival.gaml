/**
* Name: festival
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model festival

/* Insert your model definition here */

global {
	
	int noguests<-3;
	int notaverns<-2;
	
	init {
		create infocentre;
		create tavern with:(location:point (15,15));
		create tavern with:(location:point (60,60));
		create pub with:(location:point (90,90));
		create pub with:(location:point (30,30));		
		create guests number:noguests
		{
		 isthirsty<-rnd(100);
		 ishungry<-rnd(100);
		 pointl<-nil;
		 sos<-false;
		}
		
		loop counter from:1 to:noguests{
			guests myagent<-guests[counter-1];
			myagent <- myagent.setName(counter);
		}
		
		}
	
	}
	
	


species guests skills: [moving]{
	
	int isthirsty;
	int ishungry;
	bool sos;
	point pointl;
	string guestName<-'undefined';
	point target<-{15,15};
	
	action setName(int num){
		guestName<-'person '+num;
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
	
	
	
	
	reflex enjoy_the_festival when:(isthirsty!=0 and ishungry!=0)
	{
		write ishungry;
		write isthirsty;
		do wander;
		isthirsty<-isthirsty-1;
		ishungry<-ishungry-1;	
	}
	
	reflex ifthirstyaorishungry when:((isthirsty<=0 or ishungry<=0) and sos=false) {
		
		do goto target:{50,50};
		write location;	
		if (location={50,50}){
			write 'im here';
			sos<-true;
			
		}	
		}
		
		
	reflex ifsostrue when: (sos=true and pointl=nil){
		
		if(isthirsty<=0 or ishungry<=0){
			write guestName+ ' : im hungry and is thirsty';
			ask infocentre{
				myself.pointl<-{25,25};
			}
			
		}
		
	}
	
	reflex gototarget when: (pointl!=nil){
		do goto target:pointl;
		write "on the way";
		
		if(location={25,25}){
			write 'what would u like to have';
			ask tavern{
				myself.ishungry<-100;
				myself.isthirsty<-100;
				myself.pointl<-nil;
				myself.sos<-false;
			}
		}
	}
		
	
	}
	




species infocentre{
	
	aspect base{
		draw square(10) at: {50,50} color: #orange;
	}
	
}


species tavern{
	
	aspect base{
		draw square(4) at: location color: #yellow;
	}
}

species pub{
	
	aspect base{
		draw square(4) at: location color: #pink;
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
		}
}
}
