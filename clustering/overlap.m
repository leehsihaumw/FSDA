function [OmegaMap, BarOmega, MaxOmega, rcMax] = overlap(k, v, Pi, Mu, S, tol, lim)
%overlap computes the exact overlap given the parameters of the mixture
%
%<a href="matlab: docsearch('overlap')">Link to the help function</a>
%
%  Required input arguments:
%  
%  k  : number of components (groups)
%  v  : dimensionality (number of variables) 
%  Pi : vector of size k containing mixing proportions
%  Mu : matrix of size k-by-v containing (in the rows) the centroids of the
%       k groups
%  S  : 3D array of size v-by-v-by-k containing covariance matrices of the
%       k groups.
%
%  Optional input arguments:
%  
%  tol : tolerance (default is 1e-06)
%  lim : scalar = maximum number of integration terms (default is 100000)
%               REMARK: Optional parameters tol and lim will be used by
%               function ncx2mixtcdf.m which computes the cdf of a linear
%               combination of non central chi2 r.v.. This is the
%               probability of overlapping.
%
% OUTPUT
%
%    OmegaMap : k-by-k matrix containing map of misclassification
%               probabilities. More precisely, OmegaMap(i,j) is the
%               probability that group i overlaps with group j 
%               (i ~= j)=1, 2, ..., k
%               OmegaMap(i,j) = w_{j|i} is the probability that X
%               coming from the i-th component (group) is classified
%               to the j-th component.
%    BarOmega : scalar associated with average overlap.
%               BarOmega is computed as (sum(sum(OmegaMap))-k)/(0.5*k(k-1))
%    MaxOmega : scalar associated with maximum overlap. MaxOmega is the
%               maximum of OmegaMap(i,j)+OmegaMap(j,i)
%               (i ~= j)=1, 2, ..., k
%       rcMax : column vector of length equal to 2 containing the indexes
%               associated with the pair of components producing the
%               highest overlap (largest off diagonal element of matrix
%               OmegaMap)
%
%
% Copyright 2008-2014.
% Written by FSDA team
%
%
%<a href="matlab: docsearch('overlap')">Link to the help function</a>
% Last modified 08-Dec-2013

% Examples:

%{
%    Finding exact overlap for the Iris data

    load fisheriris;
    Y=meas;
    Mu=grpstats(Y,species);

    S=zeros(4,4,3);
    S(:,:,1)=cov(Y(1:50,:));
    S(:,:,2)=cov(Y(51:100,:));
    S(:,:,3)=cov(Y(101:150,:));

    pigen=ones(3,1)/3;
    k=3;
    p=4;
    [OmegaMap, BarOmega, MaxOmega, rcMax]=overlap(k,p,pigen,Mu,S)
%}

%% Beginning of code

if nargin<5
    error('error: not all input terms have been supplied')
end
if nargin==6
    lim=100000;
end
if nargin ==5
   tol=1e-6;
   lim=100000;
end

[li,di,const1]=ComputePars(v,k,Pi,Mu,S);
fixcl=zeros(k,1);
c=1;
asympt=0;
[OmegaMap, BarOmega, MaxOmega, rcMax]=GetOmegaMap(c, v, k, li, di, const1, fixcl, tol, lim, asympt);

end
