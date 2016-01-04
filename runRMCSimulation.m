function resultRMC=runRMCSimulation(d1,d2,r,giter,f)
    
    addpath('pav')
    %parameters
    par.tol     = 1e-5;
    par.maxiter = 1000;
    par.maxrank = min([d1,d2,500]);
    par.verbose = 0;
        
    
    muiter=[0.01,0.05,0.1,0.2,0.5,0.7,1,5,10,20];
    probiter=0.05:0.05:0.95;    
    resultRMC=zeros(length(giter), length(probiter), length(muiter), length(f));
    
    U=randn(d1,r);
    V=randn(d2,r);
    theta=U*V'; 
    theta=sqrt(d1*d2)*theta/norm(theta,'fro');
   
    mu0=sum(svd(theta));%Check
    Omega=rand(size(theta));
    
    for gi=1:length(giter)
        g=giter{gi};
        Y=theta;
        for j=1:d2
            Y(:,j)=g(theta(:,j));
        end

        for pi=1:length(probiter)
            p=probiter(pi);
            
            [ii,jj]=find(Omega<=p);
            YOmega=Y(Omega<=p);
            [YOmega,ii,Jcol]=processInput(ii,jj,YOmega);
            par.PAV_QP=qpparams(Jcol);
            for m=1:length(muiter)
                mu=mu0*muiter(m);
                [Ysmc,iter,~]=rmc(ii,Jcol,jj,YOmega,d1,d2,mu,par);
                k=evalRanking(theta,Ysmc.U*Ysmc.V',f);k(3)=sqrt(k(3));
                fprintf('Size: %dX%d, rk:%d, p:%f, gi:%d, mu:%f, \n\t iter:%d ktau:%f, srho:%f, rmse:%f\n',...
                    d1,d2,r,p,gi,mu,iter,k(1),k(2),k(3));
                resultRMC(gi,pi,m,:)= k;                
            end
        end          
    end    
end    
    
