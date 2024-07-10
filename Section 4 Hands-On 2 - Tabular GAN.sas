/* Make sure to copy the right path to the data */
libname data '/workspaces/myfolder/workbench-handson/data';

proc tabulargan         data=data.customs seed=123 numSamples=100;
      input               Volume Weight Price / level = interval;
      input               packageID CertificateOfOrigin EUCitizen Perishable Fragile PreDeclared MultiplePackage Category OnlineDeclaration ExporterValidation 
                          SecuredDelivery LithiumBatteries ExpressDelivery EntryPoint Origin PaperlessBilling PaymentMethod Inspection / level=nominal;
      gmm                 alpha=1 maxClusters=10 seed=42 VB(maxVbIter=30);
      aeoptimization      ADAM LearningRate=0.0001 numEpochs=3;
      ganoptimization     ADAM(beta1=0.55 beta2=0.95)  numEpochs=5;
      train               embeddingDim=64 miniBatchSize=300 useOrigLevelFreq;
      savestate           rstore=work.astore;
      output              out=work.SynthesizeCustoms;
 run;

 

/****************************/
/* Corresponding CAS action */
/****************************/

/*
 proc cas; 
     loadactionset "generativeAdversarialNet";
     action tabularGanTrain result = r /
	     table        = {name="customs", caslib="casuser", vars= {"packageID","CertificateOfOrigin","EUCitizen","Perishable",
							"Fragile","PreDeclared","MultiplePackage","Category","OnlineDeclaration","ExporterValidation",
							"SecuredDelivery","LithiumBatteries","ExpressDelivery","EntryPoint","Origin","PaperlessBilling",
							"PaymentMethod","Inspection","Weight","Price","Volume"}},
	     nominals     = {"packageID","CertificateOfOrigin","EUCitizen","Perishable","Fragile","PreDeclared","MultiplePackage",
							"Category","OnlineDeclaration","ExporterValidation","SecuredDelivery","LithiumBatteries",
							"ExpressDelivery","EntryPoint","Origin","PaperlessBilling","PaymentMethod","Inspection"},
	     gmmOptions   = {alpha=1, maxClusters=10, seed=42,
	                     inference={maxVbIter=30}},
	     optimizerAe  = {method='ADAM',numEpochs=3,learningRate=0.0001},
	     optimizerGan = {method='ADAM',numEpochs=5,beta1=0.55,beta2=0.95},
		 embeddingDim = 64,
		 miniBatchSize= 300,
	     seed         = 123,
	     numSamples   = 100,
		 gpu          = {useGPU = False},
	     saveState    = {name="astore", replace=True},
	     casOut       = {name="SynthesizeCustoms", replace=True};

	print r;

run;
quit;
*/