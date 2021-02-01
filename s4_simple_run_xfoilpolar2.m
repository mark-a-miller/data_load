%% Script for running xfoilpolar2.m %
%Easily load in and view airfoil polar data generated in Xfoil format%
%Output is a structure containing data sorted by AoA and fileinfo%
%There are two methods for using the function as shown below:

%Load airfoils from a prescribed folder location, queries for individual
%files, can select multiple airfoils%
folder = ['C:\mypath']; %Enter your own path here

afdata = xfoilpolar2(folder);


%% You can also specify the airfoil name directly with the optional second input:

folder = ['C:\mypath']; %Enter your own path here
%Airfoil names can either be strings or cell arrays of strings.
% afname = 'N63214_Re1E6_xtr1_Ncrit3.dat'; 
afname = {'N63214_Re1E6_xtr1_Ncrit3.dat','N63214_Re2E6_xtr1_Ncrit3.dat'};

afdata = xfoilpolar2(folder,afname);