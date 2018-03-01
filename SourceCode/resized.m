%% Image processing project
% Meldrick REIMMER, Danie SONIZARA and Selma BOUDISSA
% Date: 11/01/2018
% Supervisor: Dr.Sidibé Desire and  Mojdeh Rastgoo PhD.

%% Resized function method
function varargout = resized(varargin)
% RESIZED M-file for resized.fig
%      RESIZED, by itself, creates a new RESIZED or raises the existing
%      singleton*.
%
%      H = RESIZED returns the handle to a new RESIZED or the handle to
%      the existing singleton*.
%
%      RESIZED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESIZED.M with the given input arguments.
%
%      RESIZED('Property','Value',...) creates a new RESIZED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resized_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resized_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resized

% Last Modified by GUIDE v2.5 11-Jan-2018 01:00:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @resized_OpeningFcn, ...
    'gui_OutputFcn',  @resized_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before resized is made visible.
function resized_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resized (see VARARGIN)

% Choose default command line output for resized
handles.output = hObject;

%Background

% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('background.jpg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes resized wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resized_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% ************************************************************************
% --- Executes on button press in pushbutton1= Load button
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.jpg;*.png;','Select Image');

if (FileName)==0
    return
end



FullPathName = [PathName,FileName];
image=imread(FullPathName);
axes(handles.axes1);
%Display
imshow(imread(FullPathName));

col=size(imread(FullPathName),1);
rows=size(imread(FullPathName),2);
set(handles.text6,'String',col);
set(handles.text4,'String',rows);
set(handles.text7,'String',FullPathName);

%% ************************************************************************
% --------------------------------------------------------------------
function Remove_Object_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.*','Select Image');

if (FileName)==0
    return
end


FullPathName = [PathName,'\',FileName];
image=imread(FullPathName);
axes(handles.axes1);


col=size(imread(FullPathName),1);
rows=size(imread(FullPathName),2);
set(handles.text6,'String',col);
set(handles.text4,'String',rows);
set(handles.text7,'String',FullPathName);

%FullPathName=get(handles.text7,'String');
pixel=get(handles.txtpixels,'String');
pixel=str2num(pixel);
pixel=80;


%script4vertical(FullPathName,pixel)
guidata(hObject, handles);

%number of pixels to expand
pixels=50;

%Loading the image
inputImage=(imread(FullPathName));

%usage of roipoly matlab function
Mask=roipoly(inputImage);

%get the grayscale image
grayImage=double(rgb2gray(inputImage));

n=pixels;

for i=1:n
    ENERGY_IMG=getEnergyImage(grayImage); %%apply sobel filter to get Gradient Image
    % set values of selected pixels to a small number
    
    for i=1:size(Mask,1)
        for j=1:size(Mask,2)
            if(Mask(i,j) ~= 0 )
                ENERGY_IMG(i,j)=-200;
            end
        end
    end
    
    
    seamVector=findSeam(ENERGY_IMG); %find a seam vector from the given energy map
    
    %Remove seam from original image
    inputImage = removeSeam(inputImage,seamVector);
    Mask=removeSeam(Mask,seamVector);
    %Remove Seam from grayImage too
    grayImage=removeSeam(grayImage,seamVector);
end

positionss=[429 239 308 285];
axes(handles.axes2);
title('Final Image');
%display
imshow(uint8(inputImage));



%% ************************************************************************
function Preserve_Object_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.*','Select Image');

if (FileName)==0
    return
end

FullPathName = [PathName,'\',FileName];
image=imread(FullPathName);
axes(handles.axes1);
%display and load
imshow(imread(FullPathName),handles.axes1);


col=size(imread(FullPathName),1);
rows=size(imread(FullPathName),2);
set(handles.text6,'String',col);
set(handles.text4,'String',rows);
set(handles.text7,'String',FullPathName);
% hObject    handle to Preserve_Object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ************************************************************************
function Propotionate_Resize_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.*','Select Image');

if (FileName)==0
    return
end


FullPathName = [PathName,'\',FileName];
image=imread(FullPathName);
axes(handles.axes1);
%load and display
imshow(imread(FullPathName),handles.axes1);


col=size(imread(FullPathName),1);
rows=size(imread(FullPathName),2);
set(handles.text6,'String',col);
set(handles.text4,'String',rows);
set(handles.text7,'String',FullPathName);





%% ************************************************************************
function Reduce_Height_Callback(hObject, eventdata, handles)
set(handles.pushbutton2,'Visible','on');
set(handles.txtpixels,'Visible','on');
set(handles.text2,'Visible','on');
[FileName,PathName] = uigetfile('*.*','Select Image');

if (FileName)==0
    return
end

FullPathName = [PathName,'\',FileName];
image=imread(FullPathName);
axes(handles.axes1);
%load and display
imshow(imread(FullPathName),handles.axes1);


col=size(imread(FullPathName),1);
rows=size(imread(FullPathName),2);
set(handles.text6,'String',col);
set(handles.text4,'String',rows);
set(handles.text7,'String',FullPathName);


% hObject    handle to Reduce_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ************************************************************************
function Reduce_Width_Callback(hObject, eventdata, handles)

set(handles.pushbutton2,'Visible','on');
set(handles.txtpixels,'Visible','on');
set(handles.text2,'Visible','on');

[FileName,PathName] = uigetfile('*.*','Select Image');

if (FileName)==0
    return
end

FullPathName = [PathName,'\',FileName];
%load image
image=imread(FullPathName);
axes(handles.axes1);
%display and load
imshow(imread(FullPathName),handles.axes1);

col=size(imread(FullPathName),1);
rows=size(imread(FullPathName),2);
set(handles.text6,'String',col);
set(handles.text4,'String',rows);
set(handles.text7,'String',FullPathName);


% hObject    handle to Reduce_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




%% --- Executes during object creation, after setting all properties.
function txtpixels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtpixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
FullPathName=get(handles.text7,'String');
pixel=get(handles.txtpixels,'String');
pixel=str2num(pixel);
script4vertical(FullPathName,pixel)

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




%% --- Executes on button press in Enlarge.
function Enlarge_Callback(hObject, eventdata, handles)
FullPathName=get(handles.text7,'String');
n=get(handles.txtpixels,'String');
n=str2num(n); 
imageName=FullPathName;
z=get(handles.radioHeight,'Value');

set(handles.Enlarge,'Enable','off') 
inputImage=double(imread(imageName));

if(z==true)
    inputImage=imrotate(inputImage,90);
end

%apply sobel filter to get Gradient Image
ENERGY_IMG=getEnergyImage(inputImage);
for i=1:n
    %find a seam vector from the given energy map
    seamVector=findSeam(ENERGY_IMG);
    
    %add seam to the original image
    inputImage = addSeam(inputImage,seamVector);
    
    %also add seam in energy image
    ENERGY_IMG=addSeam(ENERGY_IMG,seamVector,1);
end
if(z==true)
    inputImage=imrotate(inputImage,-90);
end
axes(handles.axes2);
% display
imshow(uint8(round(inputImage)));

% hObject    handle to Enlarge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in cmdShrink.
function cmdShrink_Callback(hObject, eventdata, handles)
FullPathName=get(handles.text7,'String');
n=get(handles.txtpixels,'String');
n=str2num(n);
imageName=FullPathName;
z=get(handles.radioHeight,'Value');

inputImage=(imread(imageName));
if(z==true)
    inputImage=imrotate(inputImage,90);
end
%%
for i=1:n
    %apply sobel filter to get the gradient image
    ENERGY_IMG=getEnergyImage(inputImage);
    %find seam to be removed
    seamVector=findSeam(ENERGY_IMG);
    
    %Remove seam from original image
    inputImage = removeSeam(inputImage,seamVector);
end
if(z==true)
    inputImage=imrotate(inputImage,-90);
end

axes(handles.axes2);

imshow(uint8(inputImage));



%% --- Executes on button press in cmdRemove_Object.
function cmdRemove_Object_Callback(hObject, eventdata, handles)
% hObject    handle to cmdRemove_Object (see GCBO)
FullPathName=get(handles.text7,'String');
n=get(handles.txtpixels,'String');
n=str2num(n);
imageName=FullPathName;
z=get(handles.radioHeight,'Value');
%load
inputImage=(imread(imageName));
axes(handles.axes1);
%roipoly matlab function for region of interest selection
BW = roipoly(inputImage);
% load BWx3
wpix = max(sum(BW,1));
hpix = max(sum(BW,2));

if z
    n = wpix;
else
    n = hpix;
end

set(handles.txtpixels,'String',num2str(n))
guidata(hObject, handles);
if(z==true)
    inputImage=imrotate(inputImage,90);
    BW=imrotate(BW,90);
end
%get the size of the input image
h=size(inputImage,1)+1;

for i=1:n
    %%apply sobel filter to getGradient Image
    ENERGY_IMG=getEnergyImage(inputImage);
    
    ENERGY_IMG(logical(BW))=-(h)*abs(max(max(ENERGY_IMG)));
    
    %find a seam vector from thegiven energy map
    seamVector=findSeam(ENERGY_IMG);
    
    %Remove seam from original image
    inputImage = removeSeam(inputImage,seamVector);
    
    BW=removeSeam(BW,seamVector);
end
if(z==true)
    inputImage=imrotate(inputImage,-90);
end
axes(handles.axes2);
%display
imshow(uint8(inputImage));
handles.output = inputImage;
guidata(hObject, handles);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in cmdPreserve_Object.
function cmdPreserve_Object_Callback(hObject, eventdata, handles)

FullPathName=get(handles.text7,'String');
n=get(handles.txtpixels,'String');
n=str2num(n);
imageName=FullPathName;
z=get(handles.radioHeight,'Value');
%load 
inputImage=(imread(imageName));
axes(handles.axes1);
BW = roipoly(inputImage);
%z = wpix > hpix;
% load BWx3
if(z==true)
    inputImage=imrotate(inputImage,90);
    BW=imrotate(BW,90);
end
%size of the ibput image
h=size(inputImage,1)+1;

for i=1:n
    %%apply sobel filter to getGradient Image
    ENERGY_IMG=getEnergyImage(inputImage);
    
    ENERGY_IMG(logical(BW))=+(h)*abs(max(max(ENERGY_IMG)));
    
    %find a seam vector from thegiven energy map
    seamVector=findSeam(ENERGY_IMG);
    
    %Remove seam from original image
    inputImage = removeSeam(inputImage,seamVector);
    
    BW=removeSeam(BW,seamVector);
end
if(z==true)
    inputImage=imrotate(inputImage,-90);
end
axes(handles.axes2);
imshow(uint8(inputImage));

% hObject    handle to cmdPreserve_Object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Executes on button press in saveoutput.
function saveoutput_Callback(hObject, eventdata, handles)
% hObject    handle to saveoutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex] = uiputfile({'.jpg;.jpeg;*.png','Images (.jpg,.jpeg,*.png)'},'');
if length(PathName) > 1 && length(FileName) > 1
    path = strcat(PathName ,FileName);
    img = getimage(handles.axes2);
    if isempty(img)
        handles.txt.String = 'Nothing to save yet';
    else
    imwrite(img,path)
    handles.txt.String = strcat('Result saved at ',path);
    end
end
        
        
name=fullfile(PathName,FileName);
imwrite(uint8(handles.output),name)


% --- Executes during object creation, after setting all properties.
function cmdShrink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmdShrink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
