/* Make sure to copy the right path to the data */
libname data '/workspaces/myfolder/workbench-handson/data';

proc print data = data.customs (obs=10); run;

proc forest data = data.customs seed = 12345;
   input Volume Weight Price / level = interval;
   input CertificateOfOrigin EUCitizen Perishable Fragile PreDeclared MultiplePackage Category OnlineDeclaration ExporterValidation 
            SecuredDelivery LithiumBatteries ExpressDelivery EntryPoint Origin PaperlessBilling PaymentMethod  / level=nominal;
   target Inspection / level = nominal;
   output out=work.scoredCustoms copyvars=(Inspection EntryPoint Origin);
run;

proc assessbias data=work.scoredCustoms;
   var P_InspectionYes;
   target Inspection / event="Yes" level=nominal;
   fitstat pvar=P_InspectionNo / pevent="No" ;
   sensitiveVar Origin;
run;


/****************************************/
/* Corresponding SAS Viya platform code */
/****************************************/

/*
cas; 
caslib _all_ assign;

proc forest data = casuser.customs seed = 12345;
   input Volume Weight Price / level = interval;
   input CertificateOfOrigin EUCitizen Perishable Fragile PreDeclared MultiplePackage Category OnlineDeclaration ExporterValidation 
            SecuredDelivery LithiumBatteries ExpressDelivery EntryPoint Origin PaperlessBilling PaymentMethod  / level=nominal;
   target Inspection / level = nominal;
   output out=casuser.scoredCustoms copyvars=(Inspection EntryPoint Origin);
run;

proc cas;
	fairAITools.assessBias /
	    event				   = "Yes",
	    predictedVariables	= {"P_InspectionYes", "P_InspectionNo"},
	    response			   = "Inspection",
	    responseLevels		= {"Yes", "No"},
		 modelTableType		= "NONE",
	    sensitiveVariable	= "Origin",
	    table				   = {name="scoredCustoms", caslib="casuser"};
run;
*/