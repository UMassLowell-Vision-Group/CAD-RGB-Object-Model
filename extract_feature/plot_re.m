tickname={'cow','bus','botle','mbik','boat', 'sofa','chair', 'pers','table', ... 
 'dog', 'aero', 'bike', 'bird','car','horse','trn','sheep','plant','cat','tv'};


accuracy = [83.9	73.6	41.7	59.3	49.6	26.5	16.4	23.8	13.0	32.8	52.4	65.6	29.7	45.1	41.3	49.7	52.7	70.6	70.3	88.9;
78.4	81.5	60.4	56.4	49.9	26.0	16.4	19.3	1.7	9.6	36.7	24.2	18.4	36.0	2.5	6.6	5.8	30.6	54.3	76.5;
51.7	44.1	12.3	56.4	39.2	22.2	12.4	18.8	16.4	46.2	60.5	76.1	36.3	53.2	58.0	75.8	63.3	85.5	68.1	88.9];
accuracy = accuracy / 100;


plot([1:20],accuracy(1,:),'r-o',[1:20],accuracy(2,:),'g--d',[1:20],accuracy(3,:),'b--p','LineWidth',1.7);
set(gca,'XTickLabel',tickname(1:20));

xtick_rotate([1:20],45,tickname,'Fontsize',10,'FontWeight','Bold');



ylabel('Accuracy','Fontsize',12,'FontWeight','Bold');

xlabel('Category','Fontsize',12,'FontWeight','Bold');
title('Classification Accuracy For Each Category','Fontsize',12);
legend('Fusion CNN','Shape CNN', 'Texture CNN','Fontsize',12,'FontWeight','Bold');
%xlabel('Ground Truth');

