f = find(respEsti.respAngles>180);
results = respEsti.respAngles;
results(f) = results(f)-360*ones(1,length(f));
f0 = find(results>90);
results(f0) = NaN;

angles = [2 358 ;4 356 ;8 352];
numbins = 50; mn = -90; mx = 90;
bins = linspace(mn,mx,numbins);

figure;
for i = 1:size(angles,1)
    f1 = find(expData.angles == angles(i,1));
    f2 = find(expData.angles==angles(i,2));
    
    subplot(3,1,i)
    hist(results(f1),50);
    h = findobj(gca,'Type','patch');
        set(h,'FaceColor','r','EdgeColor','w')
    %set(h,'FaceColor','r','EdgeColor','w')
    hold on;
    hist(results(f2),50); hold on;
    title(sprintf('Angles %d %d',angles(i,1), angles(i,2)));
    
    for j=1:length(bins)-1
        res1 = results(f1);
        bin = res1>bins(j) & res1<bins(j+1);
        binsRes(i,j,1) = sum(bin);
        res2 = results(f2);
        bin = res2>bins(j) & res2<bins(j+1);
        binsRes(i,j,2) = sum(bin);
    end
    
    means(i,1) = nanmean(results(f1));
    means(i,2) = nanmean(results(f2));
    corr(i,1) = (sum(results(f1)>0))/length(f1);
    corr(i,2) = (sum(results(f2)<0))/length(f2);
    acc(i) = mean([corr(i,1),corr(i,2)]);
end

%%
nm = 30;
figure;
subplot(3,1,1)
plot(squeeze(binsRes(1,:,1)),'b'); hold on;
plot(squeeze(binsRes(1,:,2)),'r'); 

ylim([0 30]);
set(gca,'XTick',linspace(0,50,nm))
set(gca,'XTickLabel',round(linspace(mn,mx,nm)))

subplot(3,1,2)
plot(squeeze(binsRes(2,:,1)),'b'); hold on;
plot(squeeze(binsRes(2,:,2)),'r'); 
ylim([0 30]);
set(gca,'XTick',linspace(0,50,nm))
set(gca,'XTickLabel',round(linspace(mn,mx,nm)))

subplot(3,1,3)
plot(squeeze(binsRes(3,:,1)),'b'); hold on;
plot(squeeze(binsRes(3,:,2)),'r'); 
ylim([0 30]);
set(gca,'XTick',linspace(0,50,nm))
set(gca,'XTickLabel',round(linspace(mn,mx,nm)))



