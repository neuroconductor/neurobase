function varargout=rest_misc(AOperation, varargin)	
%Misc functions set for REST
%------------------------------------------------------------------------------------------------------------------------------
%	Copyright(c) 2007~2010
%	State Key Laboratory of Cognitive Neuroscience and Learning in Beijing Normal University
%	Written by Xiao-Wei Song 
%	http://resting-fmri.sourceforge.net
%Dawnwei.Song @ gmail.com
% 20070609
%------------------------------------------------------------------------------------------------------------------------------
% 	Mail to Authors:  <a href="Dawnwei.Song@gmail.com">Xiaowei Song</a>; <a href="ycg.yan@gmail.com">Chaogan Yan</a> 
%	Version=1.2;
%	Release=20081223;
%   Modified by Yan Chao-Gan 080808: also support NIFTI images.
%   Last Modified by Yan Chao-Gan 081223: check the NIFTI templates.
%   Revised by YAN Chao-Gan, 091126. LastSphereMask would be stored under temp dir other than {REST_DIR}.

switch upper(AOperation),
case 'ISEXISTFIGURE', 						%IsExistFigure
	if nargin~=2, error('Usage: result =rest_misc( ''IsExistFigure'' , AFigureHandle);'); end	
	if nargin>0,
		varargout{1} =IsExistFigure(varargin{1});
	end	
	
case 'FORCECHECKEXISTFIGURE', 	%  ForceCheckExistFigure
	if nargin~=2, error('Usage: result =rest_misc( ''ForceCheckExistFigure'' , AFigureHandle);'); end	
	if nargin>0,
		varargout{1} =ForceCheckExistFigure(varargin{1});
	end	
	
case 'COMPLAINWHYTHISOCCUR', 	%ComplainWhyThisOccur	
	if nargin~=1, error('Usage: rest_misc( ''ComplainWhyThisOccur'');'); end
	error(sprintf('Error call: Why did this occur?\nThere must be something wrong.\nrun "clear all" or re-start MATLAB to avoid this error.\n Dawnwei.song 20070526'));

case 'REPLACESINGLEQUOTA', 		% Replace single ' in filename or dirname to make sure the legal string used in sliceViewer and waveGraph
	if nargin~=2, error('Usage: rest_misc( ''ReplaceSingleQuota'', AFilename);'); end	
	AFilename =varargin{1};
	varargout{1} = regexprep(AFilename, '(''{1})', '''''');
	
case 'DISPLAYLASTEXCEPTION'	, %DisplayLastException, 20070530
	if nargin~=1, error('Usage: rest_misc( ''DisplayLastException'');'); end
	if nargout>0,
		varargout{1} =DisplayLastException;
	else
		DisplayLastException;
	end
	
case 'GETDATETIMESTR', 	% GetDateTimeStr	
	if nargin~=1, error('Usage: rest_misc( ''GetDateTimeStr'');'); end
	varargout{1} =GetDateTimeStr;
case 'GETDATESTR', 	% GetDateStr	
	if nargin~=1, error('Usage: rest_misc( ''GetDateStr'');'); end
	varargout{1} =GetDateStr;	
	
case 'GETMATLABVERSION',		%GetMatlabVersion
	if nargin~=1, error('Usage: rest_misc( ''GetMatlabVersion'');'); end
	varargout{1} =GetMatlabVersion;
	
case 'GETCURRENTUSER', 	%GetCurrentUser	
	if nargin~=1, error('Usage: rest_misc( ''GetCurrentUser'');'); end
	varargout{1} =getenv('USERNAME');	% for Windows
	if isempty(varargout{1}),
		varargout{1} =getenv('USER');% for Unix ...
	end
	
case 'GETRESTVERSION', 		%GetRestVersion
	if nargin~=1, error('Usage: rest_misc( ''GetRestVersion'');'); end
	%if rest_misc( 'GetMatlabVersion')>=7.3,
		[pathstr, name, ext] = fileparts(mfilename('fullpath'));
		theOldDir =pwd;	cd(pathstr);
		theHelp =help('rest');  cd(theOldDir);
		
		[posBegin, posEnd] =regexp(theHelp, 'Version=[0-9\.]+;');
		tmpToken =theHelp(posBegin:posEnd);
		[posBegin, posEnd] =regexp(tmpToken, '[0-9\.]+');
		theVersion =tmpToken(posBegin:posEnd);		
		
		[posBegin, posEnd] =regexp(theHelp, 'Release=[0-9\.]+;');
		tmpToken =theHelp(posBegin:posEnd);
		[posBegin, posEnd] =regexp(tmpToken, '[0-9\.]+');
		theRelease =tmpToken(posBegin:posEnd);
				
		varargout{1} =theVersion;
		varargout{2} =theRelease;
	% else
		% varargout{1} ='1.1';
		% varargout{2} ='20070830';
	% end	
	
case 'WHEREISREST', 		%WhereIsREST
	if nargin~=1, error('Usage: rest_misc( ''WhereIsREST'');'); end
	[pathstr, name, ext] = fileparts(mfilename('fullpath'));
	varargout{1} =pathstr;
	
	
% mlock locks the currently running
% M-file or MEX-file in memory so that subsequent clear functions
% do not remove it.Use the munlock function to return
% the file to its normal, clearable state.Locking an M-file or MEX-file in memory also prevents any persistent variables defined in the file from
% getting reinitialized.	
case 'UNLOCKMFILEINMEMORY',		%UnLockMFileInMemory	
	if nargin~=2, error('Usage: rest_misc( ''UnLockMFileInMemory'', ''MFilename'');'); end
	theMFilename = varargin{1};
	if mislocked(theMFilename),	
		eval(sprintf('munlock %s', theMFilename));
	end
	
case 'UNLOCKRESTFILES', 		%UnlockRestFiles
	if nargin~=1, error('Usage: rest_misc( ''UnlockRestFiles'');'); end	
	munlock('rest_sliceviewer'); 
	munlock('rest_powerspectrum'); 
	clear all


case 'CLEARTEMPFILES', 		%ClearTempFiles, Clear temp files in temp dir generated by REST(such as fc.m, alff.m, rest_bandpass.m ...)	
	%Suspended 20070904, dawnsong, 
	%Todo: delete all temp direcotries before REST shut down
	if nargin~=1, error('Usage: rest_misc( ''ClearTempFiles'');'); end
	dirFCTemp 	=dir(fullfile(tempdir, 'fc_*'));
	dirALFFTemp	=dir(fullfile(tempdir, 'ALFF_*'));
	dirBandPassTemp =dir(fullfile(tempdir,'BandPass_*'));
	
	for x=1:size(struct2cell(dirFCTemp),2),
		ans=rmdir(fullfile(tempdir, dirFCTemp(x).name), 's');%suppress the error msg
	end
	for x=1:size(struct2cell(dirALFFTemp),2),
		ans=rmdir(fullfile(tempdir, dirALFFTemp(x).name), 's');%suppress the error msg
	end
	for x=1:size(struct2cell(dirBandPassTemp),2),
		ans=rmdir(fullfile(tempdir, dirBandPassTemp(x).name), 's');%suppress the error msg
	end
	
	
case 'CHECKTEMPLATE', 		%CheckTemplate, Extract AAL & Brodmann gz file	
	if nargin~=1, error('Usage: rest_misc( ''CheckTemplate'');'); end
	path =rest_misc( 'WhereIsREST');
	if ~(exist(fullfile(path,'Template','aal.nii'), 'file')==2), %Yan Chao-Gan 081223: check the NIFTI templates.
		theGZfile =fullfile(path,'Template','aal.nii.gz');
		if ~(exist(theGZfile, 'file')==2),
			error(sprintf('AAL template file %s is lost!', theGZfile));			
		else
			rest_misc( 'ExtractGZ', theGZfile, fullfile(path,'Template'));
		end
	end
	if ~(exist(fullfile(path,'Template','brodmann.nii'), 'file')==2), %Yan Chao-Gan 081223: check the NIFTI templates.
		theGZfile =fullfile(path,'Template','brodmann.nii.gz');
		if ~(exist(theGZfile, 'file')==2),
			error(sprintf('BRODMANN template file %s is lost!', theGZfile));			
		else
			rest_misc( 'ExtractGZ', theGZfile, fullfile(path,'Template'));
		end
	end
	if ~(exist(fullfile(path,'Template','ch2.nii'), 'file')==2), %Yan Chao-Gan 081223: check the NIFTI templates.
		theGZfile =fullfile(path,'Template','ch2.nii.gz');
		if ~(exist(theGZfile, 'file')==2),
			error(sprintf('Ch2 template file %s is lost!', theGZfile));			
		else
			rest_misc( 'ExtractGZ', theGZfile, fullfile(path,'Template'));
		end
    end
    if ~(exist(fullfile(path,'Template','ch2bet.nii'), 'file')==2), %Yan Chao-Gan 100403,
        theGZfile =fullfile(path,'Template','ch2bet.nii.gz');
        if ~(exist(theGZfile, 'file')==2),
            error(sprintf('Ch2 Bet template file %s is lost!', theGZfile));
        else
            rest_misc( 'ExtractGZ', theGZfile, fullfile(path,'Template'));
        end
    end
case 'EXTRACTGZ',	%ExtractGZ, Extract gz cmpressed file to specified dir
	if nargin~=3, error('Usage: rest_misc( ''ExtractGZ'', AGZFile, ADestDir);'); end
	AGZFile =varargin{1};
	ADestDir=varargin{2};
	gunzip(AGZFile, ADestDir);
	
case 'EXPORTCELLS2TXT',	%ExportCells2Txt
	if nargin~=3, error('Usage: rest_misc( ''ExportCells2Txt'', ACellStruct, AFilename);'); end
	ACellStruct =varargin{1};
	AFilename	=varargin{2};
	hFile =fopen(AFilename, 'w');
	if hFile>0,
		for x=1:size(ACellStruct, 1),
			fprintf(hFile, '%s\r\n', ACellStruct{x, 1});
		end
		fclose(hFile);
	else 
		error(sprintf('Can''t open file: %s', AFilename));
	end	
case 'IMPORTLINESFROMTXT',	%ImportLinesFromTxt
	if nargin~=2, error('Usage: [Lines]=rest_misc( ''ImportLinesFromTxt'', AFilename);'); end	
	AFilename	=varargin{1};
	varargout{1} =textread(AFilename,'%s', 'delimiter','\n');
	
case 'VIEWROI', 	%ViewROI
	if nargin~=2, error('Usage: rest_misc( ''ViewROI'', AROIDef);'); end	
	AROIDef	=varargin{1};
	ViewROI(AROIDef);

case 'SETFIGVIEWSTYLE',		%SetFigViewStyle	%Still Need more work! 20071103
	if nargin~=2, error('Usage: rest_misc( ''SetFigViewStyle'', AFigHandle);'); end	
	AFigHandle =varargin{1};
	%'FontName', 'Fixed', ...
	SetFigViewStyle(AFigHandle);

case 'ATTENTION_COORDINATES',		%Attention_Coordinates
	if nargin~=1, error('Usage: rest_misc( ''Attention_Coordinates'');'); end	
	AMsg =sprintf('Attention:\nPositive X means left and negative X means right in SliceViewer''s image!!! The coordinates you defined would be based on the origin of the EPI image, so the ORIGIN must be defined correctly before any calculation!!!');
	warndlg(AMsg,'Attention about coordinates in REST!!!');

	
otherwise
	
end

function Result=IsExistFigure(AHandle)
	Result =0;
	if ~isempty(AHandle) && (AHandle>0)
		Result= any( allchild(0)== AHandle) ; %get(gca,'Children')	
	end	
	
function Result	=ForceCheckExistFigure(AHandle)
	Result =0;
	try
		thePos =get(AHandle, 'Position');
		if numel(thePos)==4,
			Result =1;
		end	
	catch
		Result =0;
	end
	
function Result =DisplayLastException()
	theError = lasterror;
	Result =sprintf('\nException occured.\t(%s)\n\t%s', theError.identifier,  theError.message);			
	if isfield(theError, 'stack')	%Matlab 6.5 compatible
		for x=1:length(theError.stack)
			Result =sprintf('%s\n\t<a href="error:%s,%d,0">%d#line</a>,\t\t%s,\tin "%s"', ...
						Result, ...
						getfield(theError.stack(x,1), 'file'), ...
						getfield(theError.stack(x,1), 'line'), ...
						getfield(theError.stack(x,1), 'line'), ...
						getfield(theError.stack(x,1), 'name'), ...
						getfield(theError.stack(x,1), 'file'));			
		end
	end
	fprintf('%s\n', Result);	
	
function Result=GetDateTimeStr()
	theDatetime=fix(clock);%[year month day hour minute seconds]
	Result =sprintf('%.4d%.2d%.2d_%.2d%.2d',theDatetime(1),theDatetime(2),theDatetime(3),theDatetime(4),theDatetime(5));	
	
function Result =GetDateStr()
	theDatetime=fix(clock);%[year month day hour minute seconds]
	Result =sprintf('%.4d%.2d%.2d',theDatetime(1),theDatetime(2),theDatetime(3));	

	
function Result=GetMatlabVersion()
	theVer =version;
	Result =str2num( theVer(1:3) );
	
%20071103
function ViewROI(AROIDef)
	if rest_SphereROI( 'IsBallDefinition', AROIDef)
		%The ROI definition is a Ball definition
		try
			[filename, pathname] = uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';}, ...
															'Pick one brain map');
			if any(filename~=0) && ischar(filename) && length(filename)>4 ,	% not canceled and legal					
				theBrainMap =fullfile(pathname, filename);
				[theOneTimePoint VoxelSize, Header] = rest_readfile(theBrainMap);
				BrainSize =size(theOneTimePoint);
				
				[AROICenter, AROIRadius] =rest_SphereROI('STR2ROIBALL', AROIDef);
				rest_SphereROI( 'BallDefinition2Mask' , AROIDef, BrainSize, VoxelSize, Header, fullfile(tempdir,['LastSphereMask'])); %Revised by YAN Chao-Gan, 120817. Output to the temp dir.
				
				theViewer =rest_sliceviewer('ShowImage', theBrainMap);
                
                rest_sliceviewer('ShowOverlay',theViewer, fullfile(tempdir,['LastSphereMask']));  %Revised by YAN Chao-Gan, 120817. In case of strange user name.
                
				%rest_sliceviewer('ShowOverlay',theViewer, fullfile(tempdir,['LastSphereMask_',rest_misc('GetCurrentUser')]));  %Revised by YAN Chao-Gan, 091126. LastSphereMask would be stored under temp dir other than {REST_DIR}. %rest_sliceviewer('ShowOverlay',theViewer, fullfile(rest_misc('WhereIsREST'),'LastSphereMask'));
				
				%Dawnsong 20071102 Revise to make sure the left image/Right brain is +
				%rest_sliceviewer('SetPhysicalPosition', theViewer, [-1, 1, 1] .* AROICenter);
				
				rest_sliceviewer('SetPhysicalPosition', theViewer, AROICenter);
			end			
		catch
			rest_misc( 'DisplayLastException');
		end	
		
	elseif exist(AROIDef,'file')==2	% Make sure the Definition file exist
		[pathstr, name, ext] = fileparts(AROIDef);
		if strcmpi(ext, '.txt'),
			tmpX=load(AROIDef);
			if size(tmpX,2)>1,
				%Average all columns to make sure tmpX only contain one column
				tmpX = mean(tmpX')';
			end
			AROITimeCourse =tmpX;
			hFig =figure('Name', AROIDef, 'NumberTitle', 'off'); 
			plot(1:length(AROITimeCourse), AROITimeCourse);
			title(AROIDef);
		elseif strcmpi(ext, '.img') || strcmpi(ext, '.nii') || strcmpi(ext, '.gz')
			%The ROI definition is a mask file
			%maskROI =rest_loadmask(nDim1, nDim2, nDim3, AROIDef);		
			rest_sliceviewer('ShowOverlay', AROIDef);
		else
			error(sprintf('REST doesn''t support the selected ROI definition now, Please check: \n%s', AROIDef));
		end
	else
		error(sprintf('Wrong ROI definition, Please check: \n%s', AROIDef));
	end
	
function SetFigViewStyle(AFigHandle)
	theObjects =findobj(AFigHandle);
	for x=1:length(theObjects),
		theType =get(theObjects(x), 'Type');
		if strcmpi(theType, 'uicontrol'),
			% theFontName =get(theObjects(x), 'FontName');
			% if strcmpi(theFontName, 'default'),
			set(theObjects(x), 'FontName', 'FixedWidth');
			% end
		end
	end