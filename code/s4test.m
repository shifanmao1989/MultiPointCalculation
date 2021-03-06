%this code tests the calculation of 4-point correlation
%functions of rigid-rod, wormlike chain, and Gaussian chains
clear;

%Which chains?
WLC_ON=0;
GS_ON=1;
RR_ON=0;

%Chain structural information
N=4;
NM_WL=logspace(-1,1,1);
NM_GS=10 ;
NM_RR=1;

%Chain chemical information
FA=1;
LAM=1;

%Calculation parameters
d=3;
ORDEig=5;
ORDL=5;
NumLayer=500;

%wavevector and structure factor
figure;hold;set(gca,'fontsize',15);leg=[];
QM=logspace(-5,3,60);
Q1=zeros(length(QM),1);
Q2=zeros(length(QM),1);
Q3=zeros(length(QM),1);
Q4=zeros(length(QM),1);
ang1=0;
ang2=pi-ang1;
for ii=1:length(QM)
    pert1 = 0;%[1,0,0]*QM(ii)*1e-5;
    pert2 = 0;%[0,1,0]*QM(ii)*1e-5;
    Q1(ii,1:3)=QM(ii)*[1,0,0]+pert1+pert2;
    Q2(ii,1:3)=transpose(rotz(ang1)*Q1(ii,1:3)')+pert1-pert2;
    Q3(ii,1:3)=-Q1(ii,1:3)-pert1+pert2;
    Q4(ii,1:3)=-Q2(ii,1:3)-pert1-pert2;
end

%%%% WLC %%%%
if (WLC_ON==1)
    cnt=1;
    for NM_WLC=NM_WL
        if length(NM_WL)==1
            col=0;
        else
            col=(cnt-1)/(length(NM_WL)-1)
        end
        for ii=1:length(QM)
            s4=s4wlc(N,NM_WLC,LAM,FA,Q1(ii,1:3)/N/NM_WLC,...
                                     Q2(ii,1:3)/N/NM_WLC,...
                                     Q3(ii,1:3)/N/NM_WLC,...
                                     Q4(ii,1:3)/N/NM_WLC,...
                                     ORDEig,ORDL,NumLayer);
            s4aaaa(ii)=s4(1,1,1,1);
        end
        plot(QM,s4aaaa/power(N*NM_WLC,4),'linewidth',2,'color',[0 0 1-col]);
        leg=[leg {['WLC NM=',sprintf('%.2f',NM_WLC)]}];
        cnt=cnt+1;
    end
end

%%%% Gaussian Chain %%%%
if (GS_ON==1)
    g4aaaa=zeros(length(QM),1);
    g4aaab=zeros(length(QM),1);
    g4aaba=zeros(length(QM),1);
    g4abaa=zeros(length(QM),1);
    for ii=1:length(QM)
       g4=s4gaussian(N,NM_GS,LAM,FA,Q1(ii,1:3)/N/NM_GS,...
                                     Q2(ii,1:3)/N/NM_GS,...
                                     Q3(ii,1:3)/N/NM_GS,...
                                     Q4(ii,1:3)/N/NM_GS,d);
       g4=g4/power(N*NM_GS,4);
       g4aaaa(ii)=g4(1,1,1,1);
       g4aaab(ii)=g4(1,1,1,2);
       g4aaba(ii)=g4(1,1,2,1);
       g4abaa(ii)=g4(1,2,1,1);
    end
    plot(QM,g4aaaa,'k-',...
        QM,g4aaba,'b-',...
        QM,g4abaa,'r-','linewidth',2);

    g4aaaa=zeros(length(QM),1);
    g4aaab=zeros(length(QM),1);
    g4aaba=zeros(length(QM),1);
    g4abaa=zeros(length(QM),1);
    
       
%     plot(QM,g4aaaa,'k-','linewidth',2);
%     leg=[leg {['Gaussian']}];
end
% 
% %%% Gaussian Chain :: simple version (based on s2gaussian.m) %%%%
% if (GS_ON==1)
%     for ii=1:length(QM)
%        ii
%        g4=s4gaussian2(N,NM_GS,LAM,FA,Q1(ii,1:3)/N/NM_GS,...
%                                      Q2(ii,1:3)/N/NM_GS,...
%                                      Q3(ii,1:3)/N/NM_GS,...
%                                      Q4(ii,1:3)/N/NM_GS,d);
%        g4aaaa(ii)=g4(1,1,1,1);
%     end
%     plot(QM,g4aaaa/power(N*NM_GS,6)/FA/FA,'b.-','linewidth',2);
%     leg=[leg {['Gaussian NM=',sprintf('%.2f',NM_GS)]}];
% end

%%%% Rigid Rod %%%%
if (RR_ON==1)
    r4aaaa=zeros(length(QM),1);
    r4aaab=zeros(length(QM),1);
    r4aaba=zeros(length(QM),1);
    r4abaa=zeros(length(QM),1);
    for ii=1:length(QM)
       ii
       r4=s4rigid(N,NM_RR,LAM,FA,Q1(ii,1:3)/N/NM_RR,...
                                 Q2(ii,1:3)/N/NM_RR,...
                                 Q3(ii,1:3)/N/NM_RR,...
                                 Q4(ii,1:3)/N/NM_RR,1);
       r4=r4/power(N*NM_RR,4);
       r4aaaa(ii)=r4(1,1,1,1);
       r4aaab(ii)=r4(1,1,1,2);
       r4aaba(ii)=r4(1,1,2,1);
       r4abaa(ii)=r4(1,2,1,1);
    end
    plot(QM,r4aaaa,'k--',...
        QM,r4aaba,'bx--',...
        QM,r4abaa,'r--','linewidth',2);
%     plot(QM,r4aaaa,'b-','linewidth',2);
%     leg=[leg {'Rigid Rod'}];
elseif (RR_ON==2)
    r4aaaa = load('data/R4_N20NM1');
    plot(r4aaaa(:,1),r4aaaa(:,2),'b-','linewidth',2);
    leg=[leg {'Rigid Rod'}];
end

legend(leg);
% title(['f_A = ', num2str(FA), '\lambda = ', num2str(LAM)])
set(gca,'xscale','log');set(gca,'yscale','linear');ylim([0,1.3]);
xlabel('Normalized Wavevector kL');
ylabel('Normalized Structure Factor S/L^4')