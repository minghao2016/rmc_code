clear;clc;clear global
addpath('../utils/');

Y=importdata('../../data/neurosynth_counts/count_matrix-1231-3169_unorm.csv');
probiter = 0.2:0.2:0.8;
[d1,d2]=size(Y);

for i=1:5
    disp(randn(1))
    Omega=rand(size(Y));
    for pi=1:length(probiter)
        p =probiter(pi);
        p_val=p+0.1; % 10 percent validation always
        p_test=p+0.2; % 10 percent test always
        fprintf('p:%f,pval:%f,p_test:%f\n',p,p_val,p_test)
                
        [ii,jj]=find(Omega<=p);
        yy=Y(Omega<=p);
        [yy,ii,Jcol]=processInput(ii,jj,yy);
        fprintf('\tTrain:%d, %d\n', length(Jcol)-1,length(yy))
        
        [ii_val,jj_val]= find((Omega>p) & (Omega <= p_val));
        yy_val=Y((Omega>p) & (Omega <= p_val));
        [yy_val,ii_val,Jcol_val]=processInput(ii_val,jj_val,yy_val,length(Jcol)-1);
        fprintf('\tValidation:%d, %d\n', length(Jcol_val)-1,length(yy_val))
        
        [ii_test,jj_test]= find((Omega>p_val) & (Omega <= p_test));
        yy_test=Y((Omega>p_val) & (Omega <= p_test));
        [yy_test,ii_test,Jcol_test] = processInput(ii_test,jj_test,yy_test,length(Jcol)-1);
        fprintf('\tTest: %d, %d\n', length(Jcol_test)-1,length(yy_test))
        
        
        fprintf('\t unique: %d,%d; zeros:%d,%d\n',...
            length(unique(yy_test)),length(unique(yy_val)),...
            length(find(yy_test==0)),length(find(yy_val==0)))
        
        train={yy,ii,Jcol};
        val={yy_val,ii_val,Jcol_val};
        test={yy_test,ii_test,Jcol_test};
        
       
        save(sprintf('../../data/neurosynth_counts/folds%d/neurosynth_%d_unorm.mat',i,round(p*100)),...
            'yy','yy_val','yy_test','ii','ii_val','ii_test',...
            'Jcol','Jcol_val','Jcol_test','jj','jj_val','jj_test','d1','d2')
    end
end
