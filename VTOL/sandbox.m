fname='exampleBC';

saveas(gcf,[fname,'.eps'],'epsc');

system(['epstopdf',' ',[fname,'.eps']]);

system(['pdfcrop',' ',[fname,'.pdf']]);

system(['mv',' ',[fname,'-crop.pdf'],' ',[fname,'.pdf']]);