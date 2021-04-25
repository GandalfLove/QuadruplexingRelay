/*
_IO_EM_DX_XX indicates embedded controller IO
 */

//Inputs

leadLps := _IO_EM_DI_00;		//Trigger Switch (lps denotes "low pressure switch" used in refrigeration pumpdown applicationsS)
lagLps 	 := _IO_EM_DI_02;
lag2Lps := _IO_EM_DI_03;
lag3Lps := _IO_EM_DI_04;

//Counter to cycle lead output when trigger switch occurs
counter(												
	not leadLps,						// counter.CU, Unit trigger switch initiates counter
	counter.CV = 4 and not leadLps, 	// counter.RESET, Reset Counter when counter.CV(count)=4 and trogger occurs
	4 									// counter.PV, Set maximum count to 4
) ;								
	
 case counter.CV of			//Declares lead list based on count of pumpdowns
 							
	0:						
							// Lead List 1
		c1 := leadLps;
		c2 := lagLps;
		c3 := lag2Lps;
		c4 := lag3Lps;
		
	1:	
		              		// Lead List 2
		c2 := leadLps;
		c3 := lagLps;
		c4 := lag2Lps;
		c1 := lag3Lps;
		
	2:	
							// Lead List 3
		c3 := leadLps;
		c4 := lagLps;
		c1 := lag2Lps;
		c2 := lag3Lps;
		
	3:						
							// Lead List 4
		c4 := leadLps;
		c1 := lagLps;
		c2 := lag2Lps;
		c3 := lag3Lps;
		
	END_CASE;
	
	
//Outputs

_IO_EM_DO_00 := c1 and leadLps;	//c1 motor starter
_IO_EM_DO_01 := c2 and leadLps;	//c2 motor starter
_IO_EM_DO_02 := c3 and leadLps;	//c3 motor starter	
_IO_EM_DO_03 := c4 and leadLps;	//c4 motor starter