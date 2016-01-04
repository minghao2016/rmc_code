function sv=NNP_LR_SP(mu,sv,options)
% Computes projection onto mu nuclear norm ball of global matrix X+spZ

global X spZ
[d1,d2]=size(spZ);

[X.U,S,X.V]=lansvd('Axz','Atxz',d1,d2,sv,'L',options);
diagS = diag(S);

diagS = ProjectOntoL1Ball(diagS, mu, 1);

svp = max(length(find(diagS>0)),1);
diagS = diagS(1:svp);

if svp < sv %|| iter < 10
    sv = min(svp + 1, d2);
    %sv=sv;
else
    sv = min(svp + 10, d2);
end

X.U = X.U(:, 1:svp) * diag(sqrt(diagS));
X.V = X.V(:, 1:svp) * diag(sqrt(diagS));